import 'package:mangayomi/utils/version.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderSliverGrid;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/browse/mobile_repositories.dart';
import 'package:mangayomi/modules/browse/extension/extension_detail.dart';
import 'package:mangayomi/modules/browse/extension/widgets/create_extension.dart';
import 'package:mangayomi/modules/browse/widgets/source_tool_menu.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/browse/widgets/source_browse_panes.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/utils/item_type_filters.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/widgets/source_directory_filters.dart';
import 'package:mangayomi/modules/browse/widgets/source_directory_menu.dart';
import 'package:mangayomi/modules/browse/widgets/source_website_card.dart';
import 'package:mangayomi/modules/feedback/support_request_page.dart';
import 'package:mangayomi/modules/webview/browser_url.dart';
import 'package:mangayomi/modules/browse/providers/browse_initial_tab_provider.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/manga_detail_main.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/library_media_button.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_selection_bar.dart';
import 'package:mangayomi/modules/widgets/nodelane_pane_layout.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/services/mobile_source_catalog.dart';
import 'package:mangayomi/services/support_requests.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

enum _WebsiteAction { pin, latest, browser, settings, info }

class MobileSourcesScreen extends ConsumerStatefulWidget {
  const MobileSourcesScreen({super.key});
  @override
  ConsumerState<MobileSourcesScreen> createState() =>
      _MobileSourcesScreenState();
}

class _MobileSourcesScreenState extends ConsumerState<MobileSourcesScreen>
    with WidgetsBindingObserver {
  final query = TextEditingController();
  final _requestEdits = PageStorageBucket();
  final _scroll = ScrollController();
  final _grids = List.generate(3, (_) => GlobalKey());
  // Open bubbles keep their anchors when the toolbar reflows.
  final _filterAnchor = GlobalKey(), _menuAnchor = GlobalKey();
  final _returnTiles = ValueNotifier<Map<int, (int, int)>>(const {});
  int _openIntent = 0;
  int? _anchor;
  double? _returnOffset;
  final _levels = SourceBrowseHistory<(Source, bool)>();
  (Source, bool)? get _site => _levels.value.site;
  int? get _book => _levels.value.book;
  ModalRoute<dynamic>? _route;
  ItemType type = ItemType.manga;
  bool thirdParty = false, managing = false;
  final selected = <int>{};
  bool _bulkBusy = false;
  bool get selecting =>
      _book == null && thirdParty && ref.read(isLongPressedStateProvider);
  final busy = <int>{};
  final failedActions = <int, ({bool open, bool latest})>{};
  final filtersByDirectory = <(ItemType, bool), DirectoryFilters>{};
  final keywords = <(ItemType, bool), String>{};
  bool _refreshing = false;
  bool _managementShowing = false;
  bool _filterBubble = false;
  NodeLaneNoticeHandle? _notice;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final requested = ref.read(browseInitialTabProvider);
    if (requested != null) {
      type = requested.type;
      thirdParty = requested.kind == BrowseTabKind.extensions;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted &&
            identical(ref.read(browseInitialTabProvider), requested)) {
          ref.read(browseInitialTabProvider.notifier).clear();
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _levels.dispose();
    _returnTiles.dispose();
    _scroll.dispose();
    _notice?.dismiss();
    query.dispose();
    super.dispose();
  }

  @override
  void didHaveMemoryPressure() => _returnTiles.value = const {};

  // Keep only the tiles already mounted at the return anchor. A narrower pane
  // can put them outside the grid's cache; don't recreate them all on Back.
  void _rememberReturnTiles() {
    final ranges = <int, (int, int)>{};
    for (final (i, key) in _grids.indexed) {
      final grid = key.currentContext?.findRenderObject();
      if (grid is RenderSliverGrid &&
          grid.geometry?.visible == true &&
          grid.firstChild != null) {
        ranges[i] = (
          grid.indexOf(grid.firstChild!),
          grid.indexOf(grid.lastChild!),
        );
      }
    }
    _returnTiles.value = ranges;
  }

  Future<void> _directoryFilters(BuildContext anchor) async {
    if (_filterBubble) return;
    FocusScope.of(context).unfocus();
    final key = (type, thirdParty);
    _openIntent++;
    setState(() => _filterBubble = true);
    try {
      await showNodeLaneBubble<void>(
        anchor,
        label: context.l10n.filter,
        width: NodeLaneTokens.bubbleSettingsWidth,
        child: SourceDirectoryFilterPanel(
          directory: key,
          keyword: query.text.trim().toLowerCase(),
          initial: filtersByDirectory[key] ?? const {},
          onChanged: (filters) {
            if (mounted && (type, thirdParty) == key) {
              setState(() => filtersByDirectory[key] = filters);
            }
          },
        ),
      );
    } finally {
      if (mounted) setState(() => _filterBubble = false);
    }
  }

  void _switchDirectory(ItemType media, bool community) {
    FocusScope.of(context).unfocus();
    _openIntent++;
    _levels.clear();
    _returnOffset = null;
    _returnTiles.value = const {};
    keywords[(type, thirdParty)] = query.text;
    final text = keywords[(media, community)] ?? '';
    setState(() {
      type = media;
      thirdParty = community;
      managing = false;
      query.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
      _notice?.dismiss();
    });
  }

  Future<void> _fetch(
    Source source, {
    bool open = false,
    bool latest = false,
  }) async {
    if (source.id == null || busy.contains(source.id)) return;
    final requestedThirdParty = thirdParty;
    final intent = open ? ++_openIntent : null;
    setState(() {
      busy.add(source.id!);
      failedActions.remove(source.id);
    });
    try {
      final proxy = ref.read(androidProxyServerStateProvider);
      if (source.isAdded == true && source.sourceCode?.isNotEmpty == true) {
        await fetchSourcesList(
          id: source.id,
          androidProxyServer: proxy,
          autoUpdateExtensions: false,
          itemType: source.itemType,
          repo: source.repo,
        );
      } else {
        await installSource(
          source,
          proxy,
          source.repo!,
          source.itemType,
          priority: true,
        );
      }
      final loaded = await sourceRepository.findByIdAsync(source.id!);
      if (loaded == null || loaded.sourceCode?.isNotEmpty != true) {
        throw StateError('Source unavailable after installation');
      }
      if (mounted &&
          open &&
          intent == _openIntent &&
          !_managementShowing &&
          _route?.isCurrent != false &&
          type == source.itemType &&
          thirdParty == requestedThirdParty &&
          GoRouter.of(context).routeInformationProvider.value.uri.path ==
              '/browse') {
        _open(loaded, latest: latest);
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => failedActions[source.id!] = (open: open, latest: latest),
        );
      }
      if (mounted &&
          (!open || intent == _openIntent) &&
          type == source.itemType &&
          thirdParty == requestedThirdParty) {
        _showFailure(context.l10n.source_load_retry);
      }
    } finally {
      if (mounted) setState(() => busy.remove(source.id));
    }
  }

  void _showFailure(String message) {
    if (!mounted || _managementShowing || _route?.isCurrent == false) {
      return;
    }
    final router = GoRouter.maybeOf(context);
    if (router != null &&
        router.routeInformationProvider.value.uri.path != '/browse') {
      return;
    }
    _notice?.dismiss();
    _notice = showNodeLaneNotice(message, kind: NodeLaneNoticeKind.error);
  }

  Future<void> _refreshCatalog() async {
    if (_refreshing || _bulkBusy) return;
    _refreshing = true;
    final requestedType = type, requestedThirdParty = thirdParty;
    _notice?.dismiss();
    try {
      if (requestedThirdParty) {
        final refresh = ref.refresh(
          fetchItemSourcesListProvider(
            reFresh: true,
            itemType: requestedType,
          ).future,
        );
        await refresh;
      } else if (requestedType == ItemType.manga) {
        await ref.read(nodeLaneCatalogRefreshProvider).refresh(force: true);
        if (mounted) ref.invalidate(nodeLaneCatalogLoadProvider(requestedType));
      }
    } catch (_) {
      if (mounted &&
          type == requestedType &&
          thirdParty == requestedThirdParty) {
        _showFailure(context.l10n.source_catalog_refresh_failed);
      }
    } finally {
      _refreshing = false;
    }
  }

  void _open(Source source, {bool latest = false}) {
    _openIntent++;
    FocusScope.of(context).unfocus();
    sourceRepository.markLastUsed(source.itemType, source.id);
    if (!context.isTouchTablet) {
      context.push('/mangaHome', extra: (source, latest));
      return;
    }
    if (_site == null) {
      _returnOffset = _scroll.hasClients ? _scroll.offset : null;
      _rememberReturnTiles();
    }
    _anchor = source.id;
    _levels.openSite(
      context,
      (source, latest),
      onClose: () {
        _openIntent++;
        _anchor = null;
      },
    );
  }

  void _openBook((Source, bool) site, int id) {
    if (_site != site || _managementShowing || _route?.isCurrent == false) {
      return;
    }
    _openIntent++;
    FocusScope.of(context).unfocus();
    _anchor = site.$1.id;
    _levels.openBook(context, id);
  }

  void _restoreDirectoryOffset() {
    if (!_scroll.hasClients || _returnOffset == null) return;
    final offset = _returnOffset!.clamp(0.0, _scroll.position.maxScrollExtent);
    if (_scroll.offset != offset) _scroll.jumpTo(offset);
  }

  void _settleDirectory(List<(String, List<Source>)> groups) {
    if (!mounted || !_scroll.hasClients) return;
    if (_site == null && _returnOffset != null) {
      _restoreDirectoryOffset();
      _returnOffset = null;
      _returnTiles.value = const {};
    } else if (_anchor case final id?) {
      _anchor = null;
      for (final (group, entries) in groups.indexed) {
        final index = entries.$2.indexWhere((s) => s.id == id);
        final grid = _grids[group].currentContext?.findRenderObject();
        if (index < 0 || grid is! RenderSliverGrid) continue;
        final layout = grid.gridDelegate.getLayout(grid.constraints);
        final tile = layout.getGeometryForChildIndex(index);
        final top = grid.constraints.precedingScrollExtent + tile.scrollOffset;
        final viewport = _scroll.position.viewportDimension;
        if (top < _scroll.offset + grid.constraints.overlap ||
            top + tile.mainAxisExtent > _scroll.offset + viewport) {
          _scroll.jumpTo(
            (top - (viewport - tile.mainAxisExtent) * .4).clamp(
              0,
              _scroll.position.maxScrollExtent,
            ),
          );
        }
        break;
      }
    }
  }

  void _searchContents() {
    FocusScope.of(context).unfocus();
    context.push('/globalSearch', extra: (query.text.trim(), type));
  }

  Future<void> _pin(Source source, {bool? pinned}) =>
      sourceRepository.writeTransaction(() {
        final current = sourceRepository.getById(source.id!);
        if (current == null) return;
        current.isPinned = pinned ?? !(current.isPinned ?? false);
        current.updatedAt = DateTime.now().millisecondsSinceEpoch;
        sourceRepository.putAllSync([current]);
      });

  void _finishSelection() {
    selected.clear();
    ref.read(isLongPressedStateProvider.notifier).update(false);
  }

  void _startSelection() {
    if (_bulkBusy) return;
    _switchDirectory(type, true);
    selected.clear();
    ref.read(isLongPressedStateProvider.notifier).update(true);
  }

  void _toggleSelection(Source source) {
    if (_bulkBusy || source.id == null || busy.contains(source.id)) return;
    setState(() {
      if (!selected.remove(source.id)) selected.add(source.id!);
    });
    if (selected.isEmpty) _finishSelection();
  }

  Future<void> _applySelection(List<Source> targets, {bool? pinned}) async {
    if (_bulkBusy || targets.isEmpty) return;
    final requestedType = type;
    final official = ref.read(nodeLaneCatalogRepositoryProvider(requestedType));
    if (pinned == null &&
        !await showNodeLaneConfirmation(
          context,
          title: context.l10n.source_uninstall_count(targets.length),
          message: context.l10n.source_uninstall_selected_hint,
          confirmLabel: context.l10n.uninstall,
          destructive: true,
        )) {
      return;
    }
    if (!mounted || !selecting || type != requestedType) {
      return;
    }
    _notice?.dismiss();
    setState(() => _bulkBusy = true);
    var failed = 0;
    try {
      for (final target in targets) {
        if (!mounted) return;
        try {
          final current = sourceRepository.getById(target.id!);
          if (current != null &&
              current.itemType == requestedType &&
              !isNodeLaneCatalogSource(current, official)) {
            if (pinned != null) {
              await _pin(current, pinned: pinned);
            } else if (current.isAdded == true) {
              await sourceRepository.uninstall(ref, current);
            }
          }
          selected.remove(target.id);
          failedActions.remove(target.id);
        } catch (_) {
          failed++;
        }
      }
      if (mounted && failed > 0) {
        _showFailure(context.l10n.source_failed_count(failed));
      } else if (mounted) {
        _finishSelection();
      }
    } finally {
      if (mounted) setState(() => _bulkBusy = false);
    }
  }

  Widget _selectionBar(List<Source> sources) {
    final targets = sources.where((s) => selected.contains(s.id)).toList();
    final installed = targets.where((s) => s.isAdded == true).toList();
    final icons = NodeLaneIcons.of(context);
    return NodeLaneSelectionBar<bool>(
      busy: _bulkBusy,
      moreLabel: context.l10n.more,
      onMore: (pinned) => _applySelection(targets, pinned: pinned),
      actions: [
        NodeLaneToolbarAction(
          label: context.l10n.source_mark_pinned,
          icon: icons.pin,
          enabled: !_bulkBusy && targets.any((s) => s.isPinned != true),
          onPressed: () => _applySelection(targets, pinned: true),
        ),
        NodeLaneToolbarAction(
          label: context.l10n.uninstall,
          icon: icons.delete,
          destructive: true,
          enabled: !_bulkBusy && installed.isNotEmpty,
          onPressed: () => _applySelection(installed),
        ),
      ],
      moreItems: [
        nodeLaneSelectionMenuItem(
          context,
          value: false,
          label: context.l10n.source_unpin,
          icon: icons.pinSelected,
          enabled: targets.any((s) => s.isPinned == true),
        ),
      ],
    );
  }

  Future<void> _sourceActions(Source source, Offset point) async {
    _openIntent++;
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    await showSourceToolMenu<_WebsiteAction>(
      context,
      title: source.name ?? l.source_actions,
      localPoint: (context.findRenderObject()! as RenderBox).globalToLocal(
        point,
      ),
      items: () => [
        (
          _WebsiteAction.pin,
          source.isPinned == true ? l.source_unpin : l.source_pin,
          icons.pin,
        ),
        (_WebsiteAction.latest, l.source_latest_content, icons.latest),
        if (isBrowserUrl(source.baseUrl))
          (_WebsiteAction.browser, l.open_in_browser, icons.browser),
        (_WebsiteAction.info, l.source_website_info, icons.info),
        if (source.isAdded == true)
          (
            _WebsiteAction.settings,
            l.settings_source_preferences,
            icons.settings,
          ),
      ],
      onSelected: (menu, action) async {
        if (!mounted) return;
        if (action != _WebsiteAction.info &&
            action != _WebsiteAction.settings) {
          Navigator.pop(menu);
        }
        switch (action) {
          case _WebsiteAction.info:
            await showSourceWebsiteInfo(menu, source);
          case _WebsiteAction.pin:
            await _pin(source);
          case _WebsiteAction.latest:
            if (source.isAdded == true &&
                source.sourceCode?.isNotEmpty == true) {
              _open(source, latest: true);
            } else {
              await _fetch(source, open: true, latest: true);
            }
          case _WebsiteAction.browser:
            context.push(
              '/mangawebview',
              extra: {'url': source.baseUrl!, 'title': source.name ?? ''},
            );
          case _WebsiteAction.settings:
            await showSourceSettings(menu, source);
        }
      },
    );
  }

  Widget _card(Source source) {
    final installed =
        source.isAdded == true && source.sourceCode?.isNotEmpty == true;
    final update =
        installed &&
        source.isObsolete != true &&
        compareVersions(source.version ?? '', source.versionLast ?? '') < 0;
    final loading = busy.contains(source.id);
    final failed = failedActions[source.id];
    final action = loading
        ? SourceCardAction.loading
        : managing
        ? source.isPinned == true
              ? SourceCardAction.unpin
              : SourceCardAction.pin
        : failed != null
        ? SourceCardAction.retry
        : thirdParty && !installed
        ? SourceCardAction.install
        : thirdParty && update
        ? SourceCardAction.update
        : SourceCardAction.open;
    void open() {
      if (managing) {
        _pin(source);
      } else if (installed) {
        _open(source);
      } else if (!loading) {
        _fetch(source, open: true);
      }
    }

    final onOpen = selecting
        ? _bulkBusy || loading
              ? null
              : () => _toggleSelection(source)
        : loading && !installed
        ? null
        : open;
    return SourceWebsiteCard(
      key: ValueKey('source-${source.id}'),
      source: source,
      action: action,
      selected: selecting ? selected.contains(source.id) : null,
      onOpen: onOpen,
      onAction: loading
          ? null
          : () {
              switch (action) {
                case SourceCardAction.retry:
                  _fetch(source, open: failed!.open, latest: failed.latest);
                case SourceCardAction.install || SourceCardAction.update:
                  _fetch(source);
                case SourceCardAction.pin || SourceCardAction.unpin:
                  _pin(source);
                default:
                  open();
              }
            },
      onDetails: selecting
          ? null
          : (anchor) {
              _openIntent++;
              showSourceWebsiteInfo(anchor, source);
            },
      onLongPress: selecting
          ? (onOpen == null ? null : (_) => onOpen())
          : (point) => _sourceActions(source, point),
    );
  }

  Future<void> _repositories(BuildContext anchor) {
    _openIntent++;
    return NodeLaneBubbleFlow.open<void>(
      anchor,
      title: context.l10n.source_manage_repositories,
      child: MobileRepositoryManager(itemType: type),
    );
  }

  Future<void> _manage(BuildContext menu, DirectoryAction action) async {
    if (_managementShowing || selecting || _bulkBusy) return;
    _openIntent++;
    FocusScope.of(context).unfocus();
    switch (action) {
      case DirectoryAction.repositories:
        await _repositories(menu);
      case DirectoryAction.create:
        await NodeLaneBubbleFlow.push<void>(menu, const CreateExtension());
      case DirectoryAction.request:
        Navigator.pop(menu);
        _managementShowing = true;
        try {
          await pushBrowsePage<void>(
            context,
            SupportRequestPage(
              kind: SupportRequestKind.website,
              editingSession: _requestEdits,
            ),
          );
        } finally {
          _managementShowing = false;
        }
      case DirectoryAction.search:
        Navigator.pop(menu);
        _searchContents();
      case DirectoryAction.local:
        Navigator.pop(menu);
        _open(Source(name: 'local', lang: '', itemType: type));
      case DirectoryAction.bulk:
        Navigator.pop(menu);
        _startSelection();
      case DirectoryAction.update:
        Navigator.pop(menu);
        await _updateInstalled();
    }
  }

  Widget _emptyState({
    required bool searching,
    required bool filtered,
    required bool hasSources,
  }) {
    final icons = NodeLaneIcons.of(context), l10n = context.l10n;
    final noMatch = searching || filtered || hasSources;
    final (String, ValueChanged<BuildContext>)? action;
    if (searching) {
      action = (l10n.source_global_search, (_) => _searchContents());
    } else if (noMatch) {
      action = null;
    } else if (thirdParty) {
      action = (l10n.source_manage_repositories, _repositories);
    } else {
      action = (
        l10n.source_view_third_party,
        (_) => _switchDirectory(type, true),
      );
    }
    return Center(
      child: NodeLaneEmptyState(
        icon: noMatch ? icons.search : icons.web,
        title: noMatch
            ? l10n.source_no_matching_websites
            : l10n.source_no_websites,
        action: switch (action) {
          (final label, final run) => Builder(
            builder: (anchor) => NodeLaneSecondaryButton(
              onPressed: () => run(anchor),
              child: Text(label),
            ),
          ),
          null => null,
        },
      ),
    );
  }

  Future<void> _updateInstalled() async {
    final official = ref.read(nodeLaneCatalogRepositoryProvider(type));
    final updates = sourceRepository
        .getInstalledByItemType(type)
        .where(
          (source) =>
              !isNodeLaneCatalogSource(source, official) &&
              source.isObsolete != true &&
              compareVersions(source.version ?? '', source.versionLast ?? '') <
                  0,
        )
        .toList();
    if (updates.isEmpty) {
      _notice?.dismiss();
      _notice = showNodeLaneNotice(context.l10n.up_to_date);
      return;
    }
    if (!thirdParty || _site != null) _switchDirectory(type, true);
    for (final source in updates) {
      if (!mounted) return;
      await _fetch(source);
    }
  }

  Widget _header(
    List<ItemType> types,
    DirectoryFilters filters, {
    required int? count,
    required bool compact,
  }) {
    final l10n = context.l10n;
    final media = LibraryMediaButton(
      value: type,
      availableTypes: types,
      onChanged: (value) => _switchDirectory(value, thirdParty),
    );
    final sections = NodeLaneSegments<int>(
      value: thirdParty ? 1 : 0,
      pill: true,
      segments: [
        const ButtonSegment(value: 0, label: Text('NodeLane')),
        ButtonSegment(value: 1, label: Text(l10n.source_third_party)),
      ],
      onChanged: (value) => _switchDirectory(type, value == 1),
    );
    final filter = Builder(
      key: _filterAnchor,
      builder: (anchor) => Tooltip(
        message: l10n.filter,
        child: Semantics(
          liveRegion: true,
          label: count == null
              ? l10n.filter
              : '${l10n.filter}, ${l10n.search_result_count(count)}',
          expanded: _filterBubble,
          value: filters.isEmpty ? null : filters.summary(l10n, type),
          child: TextButton.icon(
            style: TextButton.styleFrom(
              minimumSize: const Size.square(NodeLaneTokens.minTapTarget),
              padding: const EdgeInsets.symmetric(
                horizontal: NodeLaneTokens.space4,
              ),
              foregroundColor: _filterBubble || filters.isNotEmpty
                  ? NodeLaneTokens.of(context).accent
                  : NodeLaneTokens.of(context).ink,
            ),
            icon: Badge(
              isLabelVisible: filters.isNotEmpty,
              child: Icon(NodeLaneIcons.of(context).adjustments),
            ),
            label: ExcludeSemantics(child: Text(count?.toString() ?? '…')),
            onPressed: () => _directoryFilters(anchor),
          ),
        ),
      ),
    );
    final menu = SourceDirectoryMenu(
      key: _menuAnchor,
      type: type,
      onOpened: () => _openIntent++,
      onSelected: _manage,
    );
    final navigation = Wrap(
      spacing: NodeLaneTokens.space8,
      runSpacing: NodeLaneTokens.space4,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: compact ? WrapAlignment.spaceBetween : WrapAlignment.start,
      children: [
        media,
        if (compact) menu,
        SizedBox(
          width:
              NodeLaneTokens.catalogTabsWidth *
              (MediaQuery.textScalerOf(context).scale(15) / 15).clamp(1, 2),
          child: sections,
        ),
        if (compact) filter,
      ],
    );
    return Material(
      color: NodeLaneTokens.of(context).canvas,
      child: Padding(
        padding: NodeLaneTokens.headerPadding,
        child: NodeLaneToolbarPair(
          gap: NodeLaneTokens.space12,
          first: navigation,
          second: Row(
            children: [
              Expanded(
                child: NodeLaneTextField.search(
                  controller: query,
                  hint: l10n.source_name_or_title,
                  clearLabel: l10n.search_clear,
                  onSubmitted: (_) => _searchContents(),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              if (!compact) ...[
                const SizedBox(width: NodeLaneTokens.space8),
                filter,
                const SizedBox(width: NodeLaneTokens.space4),
                menu,
              ],
            ],
          ),
        ),
      ),
    );
  }

  SliverGridDelegate _cardGrid(BuildContext context, double available) {
    const gap = NodeLaneTokens.space12;
    final minWidth = NodeLaneTokens.sourceCardMinWidth * context.paneTextScale;
    final columns = context.isTouchTablet && available >= 2 * minWidth + gap
        ? 2
        : 1;
    final width = (available - gap * (columns - 1)) / columns;
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      mainAxisSpacing: gap,
      crossAxisSpacing: gap,
      mainAxisExtent: SourceWebsiteCard.gridExtent(context, width),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(isLongPressedStateProvider);
    final hidden = ref.watch(hideItemsStateProvider);
    final types = visibleItemTypes(hidden);
    if (types.isEmpty) return const SizedBox.shrink();
    if (!types.contains(type)) type = types.first;
    ref.listen(browseInitialTabProvider, (_, next) {
      if (next == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (selecting) _finishSelection();
        _switchDirectory(next.type, next.kind == BrowseTabKind.extensions);
        ref.read(browseInitialTabProvider.notifier).clear();
      });
    });
    final loading = ref.watch(nodeLaneCatalogLoadProvider(type));
    ref.watch(fetchItemSourcesListProvider(reFresh: false, itemType: type));
    final sources = ref.watch(mobileCatalogEntriesProvider(type));
    ref.listen(nodeLaneCatalogLoadProvider(type), (previous, next) {
      if (!_refreshing &&
          !thirdParty &&
          next.hasError &&
          !identical(previous?.error, next.error)) {
        _showFailure(context.l10n.source_catalog_load_failed);
      }
    });
    ref.listen(mobileCatalogEntriesProvider(type), (previous, next) {
      if (!_refreshing &&
          next.hasError &&
          !identical(previous?.error, next.error)) {
        _showFailure(context.l10n.source_catalog_load_failed);
      }
    });
    final catalog = ref.watch(
      mobileDirectorySourcesProvider((type, thirdParty)),
    );
    final DirectoryFilters filters =
        filtersByDirectory[(type, thirdParty)] ?? const {};
    final keyword = query.text.trim();
    final search = keyword.toLowerCase();
    final all = catalog.where((s) => filters.matches(s, search)).toList()
      ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
    final waitingForDirectory =
        catalog.isEmpty &&
        ((!thirdParty && loading.isLoading) || sources.isLoading);
    final groups = <(String, List<Source>)>[
      (
        context.l10n.settings_frequent,
        all.where((s) => s.isPinned == true).toList(),
      ),
      if (!thirdParty)
        (
          context.l10n.source_all_websites,
          all.where((s) => s.isPinned != true).toList(),
        ),
      if (thirdParty)
        (
          context.l10n.installed,
          all.where((s) => s.isAdded == true && s.isPinned != true).toList(),
        ),
      if (thirdParty)
        (
          context.l10n.source_available,
          all.where((s) => s.isAdded != true && s.isPinned != true).toList(),
        ),
    ]..removeWhere((group) => group.$2.isEmpty);
    final cards = [
      for (final (groupIndex, (_, entries)) in groups.indexed)
        SliverChildBuilderDelegate(
          (_, i) => ValueListenableBuilder(
            valueListenable: _returnTiles,
            child: IndexedSemantics(
              index: i,
              child: RepaintBoundary(child: _card(entries[i])),
            ),
            builder: (_, ranges, child) {
              final range = ranges[groupIndex];
              return KeepAlive(
                keepAlive: range != null && i >= range.$1 && i <= range.$2,
                child: child!,
              );
            },
          ),
          childCount: entries.length,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          addSemanticIndexes: false,
        ),
    ];
    final selectable = all
        .where((s) => s.id != null && !busy.contains(s.id))
        .map((s) => s.id!)
        .toSet();
    selected.retainAll(selectable);
    return NodeLaneSurface(
      child: SafeArea(
        bottom: false,
        child: Builder(
          builder: (context) {
            final directory = Scaffold(
              bottomNavigationBar: selecting
                  ? NodeLaneNoticeAvoidance(child: _selectionBar(all))
                  : null,
              appBar: selecting
                  ? nodeLaneSelectionAppBar(
                      context,
                      title: context.l10n.source_selected_count(
                        selected.length,
                      ),
                      cancelLabel: context.l10n.cancel,
                      selectAllLabel: context.l10n.bookshelf_select_all,
                      invertLabel: context.l10n.bookshelf_invert_selection,
                      onCancel: _finishSelection,
                      onSelectAll: _bulkBusy || selectable.isEmpty
                          ? null
                          : () => setState(() {
                              selected.addAll(selectable);
                            }),
                      onInvert: _bulkBusy || selectable.isEmpty
                          ? null
                          : () => setState(() {
                              final inverted = selectable.difference(selected);
                              selected
                                ..clear()
                                ..addAll(inverted);
                            }),
                    )
                  : null,
              body: LayoutBuilder(
                builder: (context, box) {
                  final grid = _cardGrid(
                    context,
                    box.maxWidth - 2 * NodeLaneTokens.gutter,
                  );
                  return RefreshIndicator(
                    onRefresh: _refreshCatalog,
                    child: CustomScrollView(
                      key: PageStorageKey('catalog-${type.name}-$thirdParty'),
                      controller: _scroll,
                      physics: const AlwaysScrollableScrollPhysics(),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      slivers: [
                        if (!selecting)
                          SliverFloatingHeader(
                            child: _header(
                              types,
                              filters,
                              count: waitingForDirectory ? null : all.length,
                              compact:
                                  box.maxWidth <=
                                  NodeLaneTokens.tabletSupportingWidth *
                                      context.paneTextScale,
                            ),
                          ),
                        if (all.isEmpty)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: pageBottomInsets(context).bottom,
                              ),
                              child: waitingForDirectory
                                  ? const NodeLaneEmptyState.loading()
                                  : _emptyState(
                                      searching: keyword.isNotEmpty,
                                      filtered: filters.isNotEmpty,
                                      hasSources: catalog.isNotEmpty,
                                    ),
                            ),
                          ),
                        for (
                          var groupIndex = 0;
                          groupIndex < groups.length;
                          groupIndex++
                        ) ...[
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: NodeLaneTokens.gutter,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: NodeLaneCatalogHeading(
                                groups[groupIndex].$1,
                                action: groupIndex == 0 && !selecting
                                    ? thirdParty
                                          ? context
                                                .l10n
                                                .source_manage_repositories
                                          : managing
                                          ? context.l10n.action_done
                                          : context.l10n.edit
                                    : null,
                                onAction: groupIndex == 0 && !selecting
                                    ? thirdParty
                                          ? _repositories
                                          : (_) => setState(
                                              () => managing = !managing,
                                            )
                                    : null,
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: NodeLaneTokens.gutter,
                            ),
                            sliver: SliverGrid(
                              key: _grids[groupIndex],
                              gridDelegate: grid,
                              delegate: cards[groupIndex],
                            ),
                          ),
                        ],
                        if (all.isNotEmpty)
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height:
                                  (selecting
                                      ? 0
                                      : pageBottomInsets(context).bottom) +
                                  NodeLaneTokens.space24,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
            return ValueListenableBuilder(
              valueListenable: _levels,
              child: NodeLaneContentMotion(
                value: (type, thirdParty),
                child: directory,
              ),
              builder: (paneContext, levels, child) {
                // Local history changes canPop; subscribe here, below the directory.
                _route = ModalRoute.of(paneContext);
                final (:site, :book, :visit) = levels;
                return PopScope(
                  canPop: !selecting && !_bulkBusy,
                  onPopInvokedWithResult: (didPop, _) {
                    if (didPop || _bulkBusy || site != null) return;
                    if (selecting) {
                      _finishSelection();
                    }
                  },
                  child: IgnorePointer(
                    ignoring: _bulkBusy,
                    child: SourceBrowsePanes(
                      visit: visit,
                      directory: CurrentWebsite(id: site?.$1.id, child: child!),
                      onDirectorySettled: () => _settleDirectory(groups),
                      website: site == null
                          ? null
                          : MangaHomeScreen(
                              key: ValueKey((
                                site.$1.id,
                                site.$1.itemType,
                                site.$2,
                              )),
                              source: site.$1,
                              isLatest: site.$2,
                              activeBookId: book,
                              onOpenDetail: (id) => _openBook(site, id),
                            ),
                      book: book == null
                          ? null
                          : MangaReaderDetail(
                              key: ValueKey(book),
                              mangaId: book,
                            ),
                      lockParents:
                          book != null && ref.read(isLongPressedStateProvider),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
