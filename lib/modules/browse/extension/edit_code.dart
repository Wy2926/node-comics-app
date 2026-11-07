import 'package:mangayomi/modules/browse/widgets/source_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/manga/home/widget/mobile_source_filters.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_view/json_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/browse/extension/widgets/extension_code_selection_toolbar.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/app_font_family.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_filter_list.dart';
import 'package:mangayomi/services/isolate_service.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/log/log.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/dart.dart';
import 'package:re_highlight/languages/javascript.dart';
import 'package:re_highlight/styles/vs2015.dart';
import 'package:re_highlight/styles/vs.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class CodeEditorPage extends ConsumerStatefulWidget {
  final int? sourceId;
  const CodeEditorPage({super.key, this.sourceId});

  @override
  ConsumerState<CodeEditorPage> createState() => _CodeEditorPageState();
}

class _CodeEditorPageState extends ConsumerState<CodeEditorPage> {
  dynamic result;
  late final source = widget.sourceId == null
      ? null
      : sourceRepository.getById(widget.sourceId!);
  final CodeLineEditingController _controller = CodeLineEditingController();
  late final SelectionToolbarController _selectionToolbarController =
      createExtensionCodeSelectionToolbar();
  Timer? _saveDebounceTimer;

  void _persistSourceCodeNow() {
    if (source == null) return;
    sourceRepository.save(source!);
  }

  List<(String, int)> _getServices(BuildContext context) => [
    ("getPopular", 0),
    ("getLatestUpdates", 1),
    ("search", 2),
    ("getDetail", 3),
    if (source?.itemType == ItemType.manga) ("getPageList", 4),
    if (source?.itemType == ItemType.anime) ("getVideoList", 5),
    if (source?.itemType == ItemType.novel) ("getHtmlContent", 6),
    if (source?.itemType == ItemType.novel) ("cleanHtmlContent", 7),
  ];

  int _serviceIndex = 0;
  int _page = 1;
  String _query = "";
  String _url = "";
  String _html = "";
  bool _isLoading = false;
  String _errorText = "";
  final _logsNotifier = ValueNotifier<List<(LoggerLevel, String, DateTime)>>(
    [],
  );
  // Aliases the app-wide Logger's controller - not owned by this widget, so
  // it must never be closed here (that would break logging for the rest of
  // the app once this screen closes).
  // ignore: close_sinks
  late final _logStreamController = Logger.logStreamController;
  late final StreamSubscription _logSubscription;
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.text = source?.sourceCode ?? "";
    useLogger = true;
    _logSubscription = _logStreamController.stream.listen((event) async {
      _addLog(event);
      try {
        // Wait for the frame to complete so maxScrollExtent is updated
        await WidgetsBinding.instance.endOfFrame;
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      } catch (_) {}
    });
  }

  static const int _maxLogs = 200;

  void _addLog((LoggerLevel, String, DateTime) log) {
    final logs = _logsNotifier.value;
    final newLogs = List<(LoggerLevel, String, DateTime)>.from(logs);
    if (newLogs.length >= _maxLogs) {
      newLogs.removeAt(0);
    }
    newLogs.add(log);
    _logsNotifier.value = newLogs;
  }

  late List<dynamic> filters = source == null
      ? []
      : getFilterList(source: source!);

  Future<void> _chooseFilters() async {
    final selected = await showNodeLaneCatalogSheet<List<dynamic>>(
      context,
      MobileSourceFilterSheet(
        filters: filters,
        sourceName: source?.name,
        defaults: () => getFilterList(source: source!),
      ),
    );
    if (selected == null || !mounted) return;
    filters = selected;
    await _execute();
  }

  Future<void> _execute() async {
    if (_isLoading || source == null) return;
    setState(() {
      result = null;
      _isLoading = true;
      _errorText = '';
    });
    try {
      source!.sourceCode = _controller.text;
      await sourceRepository.save(source!);
      if (!mounted) return;
      final proxy = ref.read(androidProxyServerStateProvider);
      final dynamic data;
      if (_serviceIndex <= 2) {
        final pages = await getIsolateService.get<MPages?>(
          source: source,
          page: _page,
          query: _query,
          filterList: filters,
          serviceType: [
            'getPopular',
            'getLatestUpdates',
            'search',
          ][_serviceIndex],
          proxyServer: proxy,
          useLogger: true,
        );
        data = pages?.toJson();
      } else if (_serviceIndex == 3) {
        final detail = await getIsolateService.get<MManga>(
          source: source,
          url: _url,
          serviceType: 'getDetail',
          proxyServer: proxy,
          useLogger: true,
        );
        data = detail.toJson();
      } else {
        data = await withExtensionService(source!, proxy, (service) async {
          return switch (_serviceIndex) {
            4 => {
              'pages': (await service.getPageList(_url))
                  .map((e) => e.toJson())
                  .toList(),
            },
            5 => (await service.getVideoList(
              _url,
            )).map((e) => e.toJson()).toList(),
            6 => await service.getHtmlContent('test', _url),
            _ => await service.cleanHtmlContent(_html),
          };
        });
      }
      if (mounted) {
        setState(() {
          result = data;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorText = error.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    if (_saveDebounceTimer?.isActive ?? false) {
      _saveDebounceTimer!.cancel();
      _persistSourceCodeNow();
    }
    _logSubscription.cancel();
    _logsNotifier.dispose();
    _scrollController.dispose();
    _controller.dispose();
    useLogger = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    final appFontFamily = ref.watch(appFontFamilyProvider.select((t) => t.$2));
    final editor = NodeLaneGroupSurface(
      child: CodeEditor(
        toolbarController:
            defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android
            ? _selectionToolbarController
            : null,
        style: CodeEditorStyle(
          fontSize: t.label.fontSize,
          fontFamily: appFontFamily,
          textColor: t.ink,
          backgroundColor: t.surface,
          cursorColor: t.accent,
          selectionColor: t.accentOverlay,
          codeTheme: CodeHighlightTheme(
            languages: {
              'dart': CodeHighlightThemeMode(mode: langDart),
              'javascript': CodeHighlightThemeMode(mode: langJavascript),
            },
            theme: Theme.of(context).brightness == Brightness.dark
                ? vs2015Theme
                : vsTheme,
          ),
        ),
        controller: _controller,
        onChanged: (_) {
          source?.sourceCode = _controller.text;
          if (source != null) {
            _saveDebounceTimer?.cancel();
            _saveDebounceTimer = Timer(
              const Duration(milliseconds: 1500),
              _persistSourceCodeNow,
            );
          }
        },
        wordWrap: false,
        indicatorBuilder:
            (context, editingController, chunkController, notifier) => Row(
              children: [
                DefaultCodeLineNumber(
                  controller: editingController,
                  notifier: notifier,
                ),
                DefaultCodeChunkIndicator(
                  width: NodeLaneTokens.smallIconSize,
                  controller: chunkController,
                  notifier: notifier,
                ),
              ],
            ),
        leadingDivider: VerticalDivider(
          width: NodeLaneTokens.glassStroke,
          thickness: NodeLaneTokens.glassStroke,
          color: t.line,
        ),
      ),
    );
    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(context, title: source?.name ?? 'Code Editor'),
        body: Padding(
          padding: NodeLaneTokens.pagePadding,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 7, child: editor),
                    if (context.isTablet) ...[
                      const SizedBox(width: NodeLaneTokens.space16),
                      Expanded(flex: 3, child: _servicePanel(context)),
                    ],
                  ],
                ),
              ),
              if (context.isTablet) ...[
                const SizedBox(height: NodeLaneTokens.space16),
                Flexible(child: _console(context)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _servicePanel(BuildContext context) {
    final icons = NodeLaneIcons.of(context), t = NodeLaneTokens.of(context);
    return ListView(
      children: [
        NodeLaneRow.card(
          title: _getServices(context)
              .firstWhere((e) => e.$2 == _serviceIndex)
              .$1,
          enabled: !_isLoading,
          onTap: () async {
            final value = await showSourceChoice<int>(
              context,
              title: context.l10n.type,
              current: _serviceIndex,
              options: [
                for (final service in _getServices(context))
                  SourceOption(service.$2, service.$1),
              ],
            );
            if (mounted && value != null) {
              setState(() {
                _serviceIndex = value;
                result = null;
                _errorText = '';
              });
            }
          },
        ),
        if (_serviceIndex <= 2)
          _input(
            'Page',
            '1',
            (value) => _page = int.tryParse(value) ?? 1,
            keyboard: TextInputType.number,
          ),
        if (_serviceIndex == 2)
          _input('Query', 'one piece', (value) => _query = value),
        if (_serviceIndex >= 3 && _serviceIndex <= 6)
          _input(
            'URL',
            'https://',
            (value) => _url = value,
            keyboard: TextInputType.url,
          ),
        if (_serviceIndex == 7)
          _input(
            'HTML',
            '<p>Text</p>',
            (value) => _html = value,
            multiline: true,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: NodeLaneTokens.space16),
          child: Wrap(
            spacing: NodeLaneTokens.space8,
            runSpacing: NodeLaneTokens.space8,
            children: [
              FilledButton.icon(
                onPressed: _isLoading || source == null ? null : _execute,
                icon: Icon(icons.anime),
                label: const Text('Execute'),
              ),
              NodeLaneSecondaryButton(
                icon: icons.reset,
                onPressed: _isLoading
                    ? null
                    : () => setState(() {
                        result = null;
                        _errorText = '';
                        filters = source == null
                            ? []
                            : getFilterList(source: source!);
                      }),
                child: Text(context.l10n.reset),
              ),
              if (_serviceIndex == 2 && filters.isNotEmpty)
                NodeLaneSecondaryButton(
                  icon: icons.filter,
                  onPressed: _isLoading ? null : _chooseFilters,
                  child: Text(context.l10n.filter),
                ),
            ],
          ),
        ),
        NodeLaneGroupSurface(
          child: _isLoading
              ? const Padding(
                  padding: NodeLaneTokens.groupPadding,
                  child: NodeLaneEmptyState.loading(),
                )
              : _errorText.isNotEmpty
              ? NodeLaneEmptyState.error(
                  message: _errorText,
                  compact: true,
                  onRetry: _execute,
                )
              : result == null
              ? NodeLaneEmptyState(
                  icon: icons.code,
                  title: context.l10n.no_result,
                )
              : Padding(
                  padding: NodeLaneTokens.groupPadding,
                  child: JsonConfig(
                    data: JsonConfigData(
                      gap: NodeLaneTokens.space16.toInt(),
                      style: JsonStyleScheme(
                        quotation: const JsonQuotation.same('"'),
                        openAtStart: false,
                        arrow: Icon(
                          icons.forward,
                          size: NodeLaneTokens.smallIconSize,
                        ),
                        depth: 4,
                      ),
                      color: JsonColorScheme(
                        normalColor: t.ink,
                        markColor: t.muted,
                        numColor: t.accent,
                        stringColor: t.ink,
                        boolColor: t.accent,
                        nullColor: t.muted,
                        nullBackground: t.soft,
                      ),
                    ),
                    child: JsonView(json: result),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _input(
    String label,
    String hint,
    ValueChanged<String> onChanged, {
    TextInputType keyboard = TextInputType.text,
    bool multiline = false,
  }) => Padding(
    padding: const EdgeInsets.only(top: NodeLaneTokens.space16),
    child: NodeLaneTextField(
      key: ValueKey(label),
      label: label,
      hint: hint,
      enabled: !_isLoading,
      keyboardType: keyboard,
      autocorrect: false,
      enableSuggestions: false,
      initialValue: switch (label) {
        'Page' => '$_page',
        'Query' => _query,
        'URL' => _url,
        _ => _html,
      },
      minLines: multiline ? 3 : 1,
      maxLines: multiline ? null : 1,
      onChanged: onChanged,
    ),
  );

  Widget _console(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    return NodeLaneGroupSurface(
      child: Column(
        children: [
          Padding(
            padding: NodeLaneTokens.rowPadding,
            child: Row(
              children: [
                Icon(icons.code, size: NodeLaneTokens.iconSize),
                const SizedBox(width: NodeLaneTokens.space12),
                Expanded(child: Text('Console Logs', style: t.readerLabel)),
                NodeLaneIconButton(
                  icon: icons.delete,
                  tooltip: context.l10n.clear_logs,
                  onPressed: () => _logsNotifier.value = [],
                ),
              ],
            ),
          ),
          const NodeLaneGroupDivider(),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _logsNotifier,
              builder: (context, logs, child) => logs.isEmpty
                  ? Center(child: Text('No logs yet', style: t.readerSecondary))
                  : SuperListView.separated(
                      controller: _scrollController,
                      padding: NodeLaneTokens.groupPadding,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: NodeLaneTokens.space12),
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final value = logs[index];
                        final error = value.$1 == LoggerLevel.error;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              error ? icons.error : icons.info,
                              size: NodeLaneTokens.smallIconSize,
                              color: error
                                  ? Theme.of(context).colorScheme.error
                                  : t.muted,
                            ),
                            const SizedBox(width: NodeLaneTokens.space8),
                            Expanded(
                              child: SelectableText(
                                value.$2,
                                style: t.readerSecondary,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
