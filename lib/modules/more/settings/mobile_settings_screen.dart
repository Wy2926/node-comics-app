import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/translation/translation_settings.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class MobileSettingsScreen extends ConsumerStatefulWidget {
  const MobileSettingsScreen({super.key});

  @override
  ConsumerState<MobileSettingsScreen> createState() =>
      _MobileSettingsScreenState();
}

class _MobileSettingsScreenState extends ConsumerState<MobileSettingsScreen> {
  final _search = TextEditingController();
  String _query = '';

  void _clear() {
    _search.clear();
    setState(() => _query = '');
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final hiddenItems = ref.watch(hideItemsStateProvider);
    MobileSettingsLink link(
      String title,
      IconData icon,
      String route, {
      String? subtitle,
    }) => MobileSettingsLink(
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: () {
        FocusScope.of(context).unfocus();
        context.push(route);
      },
    );

    final sections = <({String? title, List<MobileSettingsLink> links})>[
      (
        title: l10n.reading,
        links: [
          MobileSettingsLink(
            title: '漫画翻译',
            icon: Icons.translate_rounded,
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TranslationSettings()),
              );
            },
          ),
          if (!hiddenItems.contains('/MangaLibrary'))
            link(
              l10n.reader,
              Icons.chrome_reader_mode_outlined,
              '/readerMode',
              subtitle: l10n.reader_subtitle,
            ),
          if (!hiddenItems.contains('/NovelLibrary'))
            link(
              '${l10n.novel} ${l10n.reader}',
              Icons.menu_book_outlined,
              '/novelReaderMode',
            ),
          if (!hiddenItems.contains('/AnimeLibrary'))
            link(l10n.player, Icons.play_circle_outline, '/playerOverview'),
        ],
      ),
      (
        title: l10n.app_settings,
        links: [
          link(
            l10n.appearance,
            Icons.palette_outlined,
            '/appearance',
            subtitle: l10n.appearance_subtitle,
          ),
          link(l10n.general, Icons.tune_rounded, '/general'),
          link(l10n.security, Icons.shield_outlined, '/security'),
        ],
      ),
      (
        title: l10n.data_and_storage,
        links: [
          link(
            l10n.browse,
            Icons.explore_outlined,
            '/browseS',
            subtitle: l10n.browse_subtitle,
          ),
          link(l10n.downloads, Icons.download_outlined, '/downloads'),
          link(l10n.tracking, Icons.sync_rounded, '/track'),
          link(l10n.syncing, Icons.cloud_sync_outlined, '/sync'),
        ],
      ),
      (
        title: null,
        links: [link(l10n.about, Icons.info_outline_rounded, '/about')],
      ),
    ];
    // Search only the visible menu labels; it does not query stored settings,
    // accounts, sources, or service data.
    final query = _query.trim().toLowerCase();
    final filtered = sections
        .map(
          (section) => (
            title: section.title,
            links: section.links
                .where(
                  (entry) => '${entry.title} ${entry.subtitle ?? ''}'
                      .toLowerCase()
                      .contains(query),
                )
                .toList(),
          ),
        )
        .where((section) => section.links.isNotEmpty)
        .toList();

    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: (MediaQuery.textScalerOf(context).scale(22) * 1.3 + 16)
              .clamp(kToolbarHeight, double.infinity),
          title: Text(
            l10n.settings,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            key: const PageStorageKey('mobile-settings'),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: TextField(
                  controller: _search,
                  onChanged: (value) => setState(() => _query = value),
                  onSubmitted: (_) => FocusScope.of(context).unfocus(),
                  textInputAction: TextInputAction.search,
                  style: TextStyle(fontSize: 16, color: colors.ink),
                  decoration: InputDecoration(
                    hintText: l10n.search,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: l10n.reset,
                            onPressed: _clear,
                            icon: const Icon(Icons.close_rounded),
                          ),
                    filled: true,
                    fillColor: colors.soft,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 36,
                        color: colors.muted,
                      ),
                      const SizedBox(height: 16),
                      Text(l10n.no_result, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      TextButton(onPressed: _clear, child: Text(l10n.reset)),
                    ],
                  ),
                ),
              for (final section in filtered)
                MobileSettingsGroup(
                  title: section.title,
                  children: section.links,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
