import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_brand_mark.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/modules/browse/providers/browse_initial_tab_provider.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/data_and_storage/widgets/unified_restore.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/onboarding/providers/onboarding_state_provider.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/utils/local_directory_access.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/onboarding/widgets/onboarding_nav_preview.dart';
import 'package:mangayomi/modules/onboarding/widgets/onboarding_folder_status.dart';
import 'package:mangayomi/modules/onboarding/widgets/onboarding_controls.dart';
import 'package:mangayomi/modules/onboarding/widgets/mobile_onboarding.dart';

/// The nav destination for each library, so a library the user does not read
/// can be kept out of the bar.
const _libraryRoutes = {
  ItemType.manga: '/MangaLibrary',
  ItemType.anime: '/AnimeLibrary',
  ItemType.novel: '/NovelLibrary',
};

/// First-run and replayable setup. Phones choose content, then browse the
/// existing catalogue, import a folder or add a third-party repository.
/// Desktop keeps its navigation arrangement; TV keeps remote-friendly controls.
/// The owner manages preferences and work, while mobile widgets render state.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A Navigator of its own, because this is mounted from
    // MaterialApp.builder, outside the router's, and everything that floats
    // needs one above it: the back arrow's tooltip, the repository field's
    // selection handles, and the dialogs the restore flow puts up.
    //
    // The state lives in the route rather than around the Navigator, or a
    // step change would rebuild the Navigator and leave the route showing the
    // step before it.
    return Navigator(
      onGenerateRoute: (_) => PageRouteBuilder(
        pageBuilder: (_, _, _) => const _OnboardingBody(),
        // The screen is already being faded in by the caller; a second
        // transition here would fight it.
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}

class _OnboardingBody extends ConsumerStatefulWidget {
  const _OnboardingBody();

  @override
  ConsumerState<_OnboardingBody> createState() => _OnboardingScreenState();
}

enum _Step { libraries, navigation, repository }

class _OnboardingScreenState extends ConsumerState<_OnboardingBody>
    with WidgetsBindingObserver {
  final _controller = TextEditingController();

  _Step _step = _firstStep;

  /// Which way the last step change went, so the new words arrive from the
  /// side they came from. Going back animating like going forward is what made
  /// the movement feel arbitrary.
  bool _forward = true;

  /// A television only ever reads anime, so the question is not asked there
  /// and this is the answer. Everywhere else only manga starts ticked.
  final Set<ItemType> _libraries = isTv ? {ItemType.anime} : {ItemType.manga};
  bool _mergeLibraries = false;
  ItemType _repoType = ItemType.manga;

  bool _adding = false;
  bool _restoring = false;
  bool _pickingFolder = false;
  bool _finishing = false;
  String? _actionError, _folderError;
  bool get _busy => _adding || _restoring || _pickingFolder || _finishing;
  bool get _mobile => isMobile && !isTv;
  String? _error;
  Repo? _added;

  /// The library the repository was filed under, which is not necessarily
  /// [_repoType] by the time the user leaves: they can change the picker, or
  /// go back and stop reading that library altogether.
  ItemType? _addedFor;

  /// Whether a folder of the user's own files was added, which is content the
  /// app can open with no repository and no network at all.
  /// The local folders already set up before this screen ran.
  ///
  /// The default `local` folder is not among these; the provider holds the
  /// ones a user has added themselves.
  List<LocalFolder> get _existingFolders =>
      ref.watch(localFoldersStateProvider);

  /// Whether the folder this screen added is still on the list.
  ///
  /// Asked of the list rather than remembered, because the list can change
  /// underneath: removing the folder from Settings, or from the button below,
  /// used to leave this step still reporting a folder that had gone.
  bool get _addedLocalFolder =>
      _addedFolderPath != null &&
      ref
          .watch(localFoldersStateProvider)
          .any((folder) => folder.path == _addedFolderPath);

  /// The folder that was added here, so a wrong pick can be undone without
  /// going to look for it in Settings.
  String? _addedFolderPath;

  /// The names of the titles that folder turned out to hold, so the user can
  /// see what they just added rather than only how many.
  List<String> _foundTitleNames = const [];

  /// How the folder's titles were split across the libraries. The scanner
  /// decides that per title from what is inside it, so this is the answer to
  /// "did my anime land in Anime", which a bare count cannot give.
  Map<ItemType, int> _foundByType = const {};
  bool _scanningFolder = false;

  /// Whether the picked folder sits inside the app's own downloads directory,
  /// which is almost always a mistake.
  bool _folderIsInDownloads = false;

  /// How many titles the scan found, once it has finished. Zero is the
  /// interesting answer: it almost always means the folder above the one that
  /// was picked.
  int? _foundTitles;

  @override
  void initState() {
    super.initState();
    // Back has to be claimed from the binding, not from a route or a Router.
    // This screen replaces MaterialApp.builder's child, which puts it above
    // both the router and its Navigator, so a PopScope never sees the press
    // and BackButtonListener cannot find a Router to ask. Observers are
    // offered the press in reverse order of registration, and this one
    // registers after the router, so it gets first refusal for as long as it
    // is on screen.
    WidgetsBinding.instance.addObserver(this);
    // A television never visits the library step, so the step that would have
    // written the choice never runs. Write it here instead, or the answer the
    // flow made on the reader's behalf would be silently dropped and manga and
    // novel would stay in the rail.
    if (isTv) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _applyLibraries();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  /// Always handled, so back never reaches the router underneath and pops from
  /// behind a first run that is still going. On the first step there is
  /// nothing behind it, so it does nothing and Skip stays the way out.
  @override
  Future<bool> didPopRoute() async {
    // Restore dialogs belong to the inner navigator and must receive Back
    // before the welcome step, including while restore owns the busy state.
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      await navigator.maybePop();
      return true;
    }
    if (!_busy && _step != _firstStep) _back();
    return true;
  }

  /// How long a step change takes, or nothing at all when the platform has
  /// been asked to keep still.
  /// A single frame rather than [Duration.zero], because the implicit
  /// animations assert on a zero-length controller.
  Duration get _motion => MediaQuery.disableAnimationsOf(context)
      ? const Duration(milliseconds: 1)
      : const Duration(milliseconds: 260);

  bool get _urlLooksValid {
    final text = _controller.text.trim();
    return text.isNotEmpty && Uri.tryParse(text)?.isAbsolute == true;
  }

  /// The chosen libraries in the order the nav bar shows them, so the
  /// repository step offers them the same way round.
  List<ItemType> get _chosen =>
      ItemType.values.where(_libraries.contains).toList();

  /// The steps that will actually be shown, in order.
  ///
  /// Not a constant: the arrange step drops out for a single library or a wide
  /// window, so the flow is two steps long as often as three.
  List<_Step> get _visibleSteps => [
    if (!isTv) _Step.libraries,
    if (_shouldArrangeBar) _Step.navigation,
    _Step.repository,
  ];

  /// Where the flow starts. A television skips straight to the source, because
  /// the two questions before it have one answer each there: anime, and a rail
  /// rather than a bar.
  static _Step get _firstStep => isTv ? _Step.repository : _Step.libraries;

  /// Whether the arrange step has anything to offer.
  ///
  /// The phone shell always groups media under Library. Its legacy merge
  /// preference is not changed by this flow. The old arrange step remains
  /// only for narrow desktop layouts that still use that preference.
  bool get _shouldArrangeBar =>
      !_mobile && _chosen.length > 1 && !context.isTablet && !isTv;

  void _next() {
    if (_busy) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (_step == _Step.libraries) {
      _applyLibraries();
      setState(() {
        _forward = true;
        _actionError = null;
        _repoType = _chosen.first;
        _step = _shouldArrangeBar ? _Step.navigation : _Step.repository;
      });
      return;
    }
    ref.read(mergeLibraryNavMobileStateProvider.notifier).set(_mergeLibraries);
    setState(() {
      _forward = true;
      _step = _Step.repository;
    });
  }

  /// Restores a NodeLane backup or imports a supported third-party backup
  /// through the shared picker, then checks whether source setup is needed.
  Future<void> _restore() async {
    if (_busy) return;
    setState(() {
      _restoring = true;
      _actionError = null;
    });
    try {
      final restored = await performRestore(context, ref);
      if (!mounted) return;
      if (!restored) return;
      // A NodeLane backup includes repositories only when settings were saved.
      // Third-party imports can restore a library without configuring sources.
      if (_hasAnyRepo) {
        ref.read(onboardingCompletedStateProvider.notifier).complete();
      } else {
        setState(() {
          _forward = true;
          _step = _Step.repository;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _actionError = context.l10n.failed);
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  /// Adds a folder of the user's own files.
  ///
  /// A peer of the repository, not a footnote under it. It is the one thing
  /// the app can do with nothing installed and no connection, so somebody who
  /// already has files should not have to skip past an empty screen to use
  /// them. The folder is named after itself rather than asking, since a name
  /// is one more decision and Settings can rename it later.
  Future<void> _addLocalFolder() async {
    if (_busy) return;
    setState(() {
      _pickingFolder = true;
      _folderError = null;
    });
    try {
      // A null iOS selection means cancellation, not a second picker request.
      final path = Platform.isIOS
          ? await LocalDirectoryAccess.pickDirectory()
          : await FilePicker.getDirectoryPath(
              linuxOptions: const LinuxOptions(lockParentWindow: true),
            );
      if (path == null || !mounted) return;
      final folders = ref.read(localFoldersStateProvider).toList();
      if (!folders.any((folder) => folder.path == path)) {
        folders.add(
          LocalFolder(
            name: LocalFolder.fromPath(path: path).name ?? p.basename(path),
            path: path,
          ),
        );
        ref.read(localFoldersStateProvider.notifier).set(folders);
      }
      setState(() {
        _addedFolderPath = path;
        _folderIsInDownloads = false;
        _foundTitles = null;
        _foundTitleNames = const [];
        _foundByType = const {};
      });
      final base = await StorageProvider().getDirectory();
      if (!mounted) return;
      setState(() {
        _folderIsInDownloads =
            base != null && p.isWithin(p.join(base.path, 'downloads'), path);
        _scanningFolder = true;
      });
      await ref.read(scanLocalLibraryProvider.future);
      if (!mounted) return;
      // Keep the existing scanner's per-folder identity and media counts.
      final prefix = '${p.basename(path)}/';
      final mine = mangaRepository
          .getLocalArchive()
          .where((manga) => (manga.link ?? '').startsWith(prefix))
          .toList();
      setState(() {
        _foundTitles = mine.length;
        _foundTitleNames = mine
            .map((manga) => manga.name ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
        _foundByType = {
          for (final type in ItemType.values)
            if (mine.any((manga) => manga.itemType == type))
              type: mine.where((manga) => manga.itemType == type).length,
        };
      });
    } catch (_) {
      if (mounted) setState(() => _folderError = context.l10n.failed);
    } finally {
      if (mounted) {
        setState(() {
          _pickingFolder = false;
          _scanningFolder = false;
        });
      }
    }
  }

  /// Takes back the folder this screen added.
  ///
  /// Picking the wrong level is easy, and the wrong level is silent: the
  /// scanner reads a single manga's folder as a shelf of empty titles. Without
  /// this the only way back is Settings, after the first run is over.
  void _removeLocalFolder() {
    if (_busy) return;
    final path = _addedFolderPath;
    if (path == null) return;
    ref
        .read(localFoldersStateProvider.notifier)
        .set(
          ref
              .read(localFoldersStateProvider)
              .where((folder) => folder.path != path)
              .toList(),
        );
    setState(() {
      _addedFolderPath = null;
      _folderError = null;
      _folderIsInDownloads = false;
      _foundTitles = null;
      _foundTitleNames = const [];
      _foundByType = const {};
    });
  }

  /// "6 manga, 3 anime" rather than "9 titles found", when the folder turned
  /// out to hold more than one kind.
  String _typeBreakdown(AppLocalizations l10n) {
    if (_foundByType.length <= 1) {
      return l10n.onboarding_local_found('$_foundTitles');
    }
    return _foundByType.entries
        .map((entry) => '${entry.value} ${_libraryLabel(l10n, entry.key)}')
        .join(', ');
  }

  /// Whether any library has a repository, asked after a restore that may have
  /// brought some in.
  bool get _hasAnyRepo => ItemType.values.any(
    (type) => ref.read(extensionsRepoStateProvider(type)).isNotEmpty,
  );

  /// Returns to the previous question, skipping the arrange step when it was
  /// skipped on the way in.
  ///
  /// Nothing is undone. Each step applies its answer as it is left, and coming
  /// back and going forward again simply applies the new one.
  void _back() {
    if (_busy) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _forward = false;
      _actionError = null;
      _step = _step == _Step.repository && _shouldArrangeBar
          ? _Step.navigation
          : _firstStep;
    });
  }

  /// Keeps the chosen libraries in the nav bar and hides the rest, leaving
  /// anything else already hidden alone.
  void _applyLibraries() {
    final hidden = ref.read(hideItemsStateProvider).toSet();
    for (final entry in _libraryRoutes.entries) {
      if (_libraries.contains(entry.key)) {
        hidden.remove(entry.value);
      } else {
        hidden.add(entry.value);
      }
    }
    ref.read(hideItemsStateProvider.notifier).set(hidden.toList());
  }

  Future<void> _addRepo() async {
    if (_busy || !_urlLooksValid) return;
    final type = _repoType;
    final l10n = l10nLocalizations(context)!;
    final url = _controller.text.trim();
    setState(() {
      _adding = true;
      _error = null;
    });
    try {
      final repo = await ref.read(getRepoInfosProvider(jsonUrl: url).future);
      if (!mounted) return;
      if (repo == null) {
        setState(() => _error = l10n.onboarding_repo_failed);
        return;
      }
      final currentRepos = ref.read(extensionsRepoStateProvider(type));
      final alreadyExists = currentRepos.any((r) {
        final rUrl = r.jsonUrl?.trim().toLowerCase();
        final newUrl = repo.jsonUrl?.trim().toLowerCase();
        return (rUrl != null &&
                (rUrl == newUrl || rUrl == '$newUrl/' || '$rUrl/' == newUrl)) ||
            r == repo;
      });
      if (!alreadyExists) {
        await ref.read(extensionsRepoStateProvider(type).notifier).set([
          ...currentRepos,
          repo,
        ]);
      }
      if (!mounted) return;
      setState(() {
        _added = repo;
        _addedFor = type;
        _controller.clear();
      });
    } catch (e) {
      // Whatever went wrong, the user's move is the same: check the address
      // or the connection. A raw exception under a text field is noise.
      if (mounted) setState(() => _error = l10n.onboarding_repo_failed);
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  /// An explicit destination wins over the repository's next installation step.
  /// Skipping without content simply closes setup on the existing route.
  void _finish({BrowseTab? browseTarget, bool openLibrary = false}) {
    if (_busy) return;
    setState(() {
      _finishing = true;
      _actionError = null;
    });
    try {
      // The library the repository was filed under, and only while the user
      // still reads it. Changing the picker afterwards, or going back and
      // dropping that library, would otherwise land them on an extensions list
      // with nothing in it.
      final landing = _addedFor;
      final target =
          browseTarget ??
          (landing != null && _libraries.contains(landing)
              ? BrowseTab(landing, BrowseTabKind.extensions)
              : null);
      if (target != null) {
        ref.read(browseInitialTabProvider.notifier).request(target);
        ref.read(routerProvider).go('/browse');
      } else if (openLibrary) {
        ref.read(routerProvider).go(_libraryRoutes[_chosen.first]!);
      } else {
        _complete();
        return;
      }
      // Let the router accept the destination before dismissing setup.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _complete();
        }
      });
    } catch (_) {
      _finishFailed();
    }
  }

  void _complete() {
    try {
      ref.read(onboardingCompletedStateProvider.notifier).complete();
    } catch (_) {
      _finishFailed();
    }
  }

  void _finishFailed() {
    if (!mounted) return;
    setState(() {
      _finishing = false;
      _actionError = context.l10n.failed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final theme = Theme.of(context);

    if (_mobile) {
      final first = _step == _Step.libraries;
      final hasRepository = _addedFor != null && _libraries.contains(_addedFor);
      final openLibrary =
          !first && !hasRepository && _existingFolders.isNotEmpty;
      return MobileOnboardingFrame(
        step: first ? 1 : 2,
        title: first ? l10n.app_name : l10n.onboarding_content_title,
        description: first
            ? l10n.onboarding_mobile_libraries_body
            : l10n.onboarding_mobile_sources_body,
        busy: _busy,
        leaveLabel: first
            ? l10n.onboarding_skip
            : openLibrary
            ? l10n.onboarding_open_library
            : l10n.onboarding_start,
        onLeave: () => _finish(openLibrary: openLibrary),
        onBack: first ? null : _back,
        onNext: first ? _next : null,
        error: _actionError,
        child: first
            ? MobileOnboardingLibraries(
                selected: _libraries,
                busy: _busy,
                onToggle: _toggleLibrary,
                onRestore: _restore,
              )
            : MobileOnboardingSources(
                libraries: _chosen,
                repoType: _repoType,
                onRepoType: (type) => setState(() => _repoType = type),
                urlController: _controller,
                onUrlChanged: () => setState(() => _error = null),
                canAdd: _urlLooksValid,
                onAdd: _addRepo,
                busy: _busy,
                repoError: _error,
                addedName: _added == null
                    ? null
                    : _added!.name ?? _added!.jsonUrl ?? '',
                onBrowse: () => _finish(
                  browseTarget: BrowseTab(_chosen.first, BrowseTabKind.sources),
                ),
                onAddFolder: _addLocalFolder,
                folderStatus: _mobileFolderStatus(l10n),
              ),
      );
    }

    final scaffold = Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _content(l10n, theme),
            // A way back to change an earlier answer. Absent on the first
            // step, where there is nothing behind it.
            if (_step != _firstStep)
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: EdgeInsets.all(isTv ? 12 : 4).add(tvPageInsets),
                  child: IconButton(
                    onPressed: _busy ? null : _back,
                    tooltip: l10n.go_back,
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    return scaffold;
  }

  Widget _content(AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isTv ? 48 : 24, vertical: 32)
            .add(tvPageInsets)
            // Room for the keyboard, so the repository field and the button
            // under it stay reachable on a short screen.
            .add(
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
            ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isTv ? 620 : 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              NodeLaneBrandMark(size: isTv ? 96 : 80),
              const SizedBox(height: 16),
              // Above the words rather than below them, so it keeps its place
              // while the content underneath changes height. Not tappable:
              // going forward has to run through _next so each answer is
              // applied, and going back is the arrow's job.
              OnboardingStepDots(
                steps: _visibleSteps.length,
                current: _visibleSteps.indexOf(_step),
                duration: _motion,
              ),
              const SizedBox(height: 16),
              // Only the words and the controls change between steps. The mark
              // above keeps its place, so the screen reads as one place being
              // rewritten rather than three screens flipped through. The height
              // eases as well, or the buttons below would jump between steps
              // that say more and steps that say less.
              AnimatedSize(
                duration: _motion,
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: AnimatedSwitcher(
                  duration: _motion,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    // Forward arrives from below and leaves upward; back does
                    // the reverse, so the movement matches the direction of
                    // travel instead of always looking like a step forward.
                    final entering = child.key == ValueKey(_step);
                    final from = _forward ? 0.05 : -0.05;
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, entering ? from : -from),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    key: ValueKey(_step),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _title(l10n),
                        textAlign: TextAlign.center,
                        style:
                            (isTv
                                    ? theme.textTheme.headlineMedium
                                    : theme.textTheme.headlineSmall)
                                ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _body(l10n),
                        textAlign: TextAlign.center,
                        style:
                            (isTv
                                    ? theme.textTheme.bodyLarge
                                    : theme.textTheme.bodyMedium)
                                ?.copyWith(
                                  color: theme.hintColor,
                                  height: 1.45,
                                ),
                      ),
                      const SizedBox(height: 28),
                      ..._stepBody(l10n),
                    ],
                  ),
                ),
              ),
              if (_actionError != null) Text(_actionError!),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _busy ? null : _finish,
                child: Text(_leaveLabel(l10n)),
              ),
              // Typing a URL on a d-pad is miserable, so on a TV say
              // plainly that leaving now costs nothing.
              if (isTv && _step == _Step.repository && _added == null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.onboarding_later,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _title(AppLocalizations l10n) => switch (_step) {
    _Step.libraries => l10n.onboarding_title,
    _Step.navigation => l10n.onboarding_nav_title,
    _Step.repository => l10n.onboarding_repo_title,
  };

  String _body(AppLocalizations l10n) => switch (_step) {
    _Step.libraries => l10n.onboarding_libraries_body,
    _Step.navigation => l10n.onboarding_nav_body,
    _Step.repository => l10n.onboarding_body,
  };

  String _leaveLabel(AppLocalizations l10n) =>
      _step == _Step.repository &&
          (_added != null || _addedLocalFolder || _existingFolders.isNotEmpty)
      ? l10n.onboarding_continue
      : l10n.onboarding_skip;

  List<Widget> _stepBody(AppLocalizations l10n) => switch (_step) {
    _Step.libraries => [
      OnboardingChoiceRow<ItemType>(
        values: ItemType.values,
        label: (type) => type == ItemType.manga
            ? _libraryLabel(l10n, type)
            : '${_libraryLabel(l10n, type)} · 待测试',
        isSelected: _libraries.contains,
        onTap: _busy ? null : _toggleLibrary,
      ),
      const SizedBox(height: 16),
      FilledButton(
        onPressed: _busy ? null : _next,
        child: Text(l10n.onboarding_next),
      ),
      const SizedBox(height: 12),
      // Given weight next to Next rather than tucked under it. For anyone
      // arriving from another app or a reinstall this is the whole job, and
      // burying it costs them a walk through three questions they have
      // already answered somewhere else.
      OutlinedButton.icon(
        onPressed: _busy ? null : _restore,
        icon: const Icon(Icons.settings_backup_restore, size: 20),
        label: Text(l10n.onboarding_restore),
      ),
    ],
    _Step.navigation => [
      OnboardingChoiceRow<bool>(
        values: const [false, true],
        label: (merged) =>
            merged ? l10n.onboarding_nav_merged : l10n.onboarding_nav_split,
        isSelected: (merged) => merged == _mergeLibraries,
        onTap: _busy
            ? null
            : (merged) => setState(() => _mergeLibraries = merged),
      ),
      const SizedBox(height: 18),
      // The words alone do not settle it. This is the bar the choice produces,
      // with the libraries they actually picked in it.
      OnboardingNavPreview(libraries: _chosen, merged: _mergeLibraries),
      const SizedBox(height: 18),
      FilledButton(
        onPressed: _busy ? null : _next,
        child: Text(l10n.onboarding_next),
      ),
    ],
    _Step.repository => [
      if (_chosen.length > 1) ...[
        OnboardingChoiceRow<ItemType>(
          values: _chosen,
          label: (type) => _libraryLabel(l10n, type),
          isSelected: (type) => type == _repoType,
          onTap: _busy ? null : (type) => setState(() => _repoType = type),
        ),
        const SizedBox(height: 16),
      ],
      TextField(
        controller: _controller,
        // The remote's first OK should open the keyboard rather than land on
        // something the user has to hunt for.
        autofocus: isTv,
        autocorrect: false,
        enabled: !_busy,
        keyboardType: TextInputType.url,
        onChanged: (_) => setState(() => _error = null),
        onSubmitted: (_) => _urlLooksValid && !_busy ? _addRepo() : null,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          isDense: true,
          labelText: l10n.repo_url,
          errorText: _error,
          errorMaxLines: 3,
        ),
      ),
      const SizedBox(height: 12),
      FilledButton(
        onPressed: _urlLooksValid && !_busy ? _addRepo : null,
        child: _adding
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(l10n.onboarding_add),
      ),
      if (_added != null) ...[
        const SizedBox(height: 14),
        OnboardingAddedRepo(name: _added!.name ?? _added!.jsonUrl ?? ''),
      ],
      const SizedBox(height: 20),
      Text(
        l10n.onboarding_or_local,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: Theme.of(context).hintColor),
      ),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: _busy ? null : _addLocalFolder,
        icon: const Icon(Icons.folder_open, size: 20),
        label: Text(l10n.onboarding_local_folder),
      ),
      // What is already set up, for anyone who restored a backup or had
      // folders from before. Without it the step looks like they have none
      // and invites them to add one they already have.
      if (_addedFolderPath == null && _existingFolders.isNotEmpty) ...[
        const SizedBox(height: 12),
        OnboardingFolderStatus(
          message: l10n.onboarding_local_existing('${_existingFolders.length}'),
          titles: _existingFolders
              .map((folder) => folder.name ?? '')
              .where((name) => name.isNotEmpty)
              .toList(),
        ),
      ],
      const SizedBox(height: 6),
      // No type to choose here, unlike the repository above it. A folder is
      // not bound to one: the scanner reads each title's contents and files
      // it accordingly, so one folder can feed all three libraries. Saying so
      // is better than offering a choice that does not exist.
      Text(
        l10n.onboarding_local_any_type,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      if (_folderError != null) ...[
        const SizedBox(height: 12),
        Text(_folderError!),
      ],
      if (_addedLocalFolder) ...[
        const SizedBox(height: 14),
        if (_scanningFolder)
          OnboardingFolderStatus(
            message: l10n.onboarding_local_scanning,
            busy: true,
          )
        else if ((_foundTitles ?? 0) > 0)
          OnboardingFolderStatus(
            message: _folderIsInDownloads
                ? l10n.onboarding_local_in_downloads
                : _typeBreakdown(l10n),
            path: _addedFolderPath,
            titles: _foundTitleNames,
            warn: _folderIsInDownloads,
          )
        else if (_folderError == null)
          // Zero almost always means the folder above this one. The scanner
          // reads the picked folder as a shelf of titles, so a single title's
          // own folder looks like a shelf of chapters with nothing in them.
          OnboardingFolderStatus(
            message: l10n.onboarding_local_empty,
            path: _addedFolderPath,
            warn: true,
          ),
        if (!_scanningFolder) ...[
          const SizedBox(height: 4),
          TextButton(
            onPressed: _removeLocalFolder,
            child: Text(l10n.onboarding_local_remove),
          ),
        ],
      ],
    ],
  };

  void _toggleLibrary(ItemType type) {
    if (_busy) return;
    setState(() {
      if (!_libraries.remove(type) || _libraries.isEmpty) _libraries.add(type);
    });
  }

  Widget? _mobileFolderStatus(AppLocalizations l10n) {
    if (_folderError != null) {
      return OnboardingFolderStatus(
        mobile: true,
        message: _folderError!,
        path: _addedFolderPath,
        warn: true,
        onAddFolder: _addLocalFolder,
        onRemoveFolder: _addedLocalFolder ? _removeLocalFolder : null,
        actionsEnabled: !_busy,
      );
    }
    if (_addedLocalFolder) {
      return OnboardingFolderStatus(
        key: ValueKey(_addedFolderPath),
        mobile: true,
        message: _scanningFolder || _pickingFolder
            ? l10n.onboarding_local_scanning
            : _folderIsInDownloads
            ? l10n.onboarding_local_in_downloads
            : (_foundTitles ?? 0) > 0
            ? _typeBreakdown(l10n)
            : l10n.onboarding_local_empty,
        path: _addedFolderPath,
        titles: _foundTitleNames,
        busy: _scanningFolder || _pickingFolder,
        onAddFolder: _addLocalFolder,
        onRemoveFolder: _removeLocalFolder,
        actionsEnabled: !_busy,
        warn:
            !_scanningFolder &&
            !_pickingFolder &&
            (_folderIsInDownloads || (_foundTitles ?? 0) == 0),
      );
    }
    if (_existingFolders.isEmpty) return null;
    return OnboardingFolderStatus(
      mobile: true,
      message: l10n.onboarding_local_existing('${_existingFolders.length}'),
      onAddFolder: _addLocalFolder,
      actionsEnabled: !_busy,
      titles: _existingFolders
          .map((f) => f.name ?? '')
          .where((name) => name.isNotEmpty)
          .toList(),
    );
  }

  String _libraryLabel(AppLocalizations l10n, ItemType type) => switch (type) {
    ItemType.manga => l10n.manga,
    ItemType.anime => l10n.anime,
    ItemType.novel => l10n.novel,
  };
}
