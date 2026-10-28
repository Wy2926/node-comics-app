import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/modules/browse/extension/widgets/extension_lang_list_tile_widget.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_empty.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';

class ExtensionsLang extends ConsumerWidget {
  final ItemType itemType;
  const ExtensionsLang({required this.itemType, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final mobile = isMobile && !isTv;
    final actions = <Widget>[
      PopupMenuButton(
        popUpAnimationStyle: popupAnimationStyle,
        itemBuilder: (context) {
          return [
            PopupMenuItem<int>(value: 0, child: Text(l10n.enable_all)),
            PopupMenuItem<int>(value: 1, child: Text(l10n.disable_all)),
          ];
        },
        onSelected: (value) {
          bool enable = true;
          if (value == 0) {
          } else if (value == 1) {
            enable = false;
          }
          final sources = sourceRepository.getByItemType(itemType);
          final now = DateTime.now().millisecondsSinceEpoch;
          for (var source in sources) {
            source
              ..isActive = enable
              ..updatedAt = now;
          }
          sourceRepository.putAll(sources);
        },
      ),
    ];
    final body = StreamBuilder(
      stream: sourceRepository.watchByItemType(itemType),
      builder: (context, snapshot) {
        if (mobile && snapshot.hasError) {
          return ErrorState(detail: snapshot.error.toString());
        }
        if (mobile &&
            snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        List<Source>? entries = snapshot.hasData ? snapshot.data : [];
        final languages = entries!.map((e) => e.lang!).toSet().toList();

        languages.sort((a, b) => a.compareTo(b));
        if (mobile && languages.isEmpty) {
          return ListView(
            children: [
              MobileBrowseEmpty(
                icon: Icons.translate_rounded,
                title: l10n.no_result,
                actionLabel: l10n.add_extensions_repo,
                onAction: () =>
                    context.push('/SourceRepositories', extra: itemType),
              ),
            ],
          );
        }
        return SuperListView.builder(
          padding: mobile
              ? const EdgeInsets.only(top: 12, bottom: 16)
              : tvPageInsets,
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final lang = languages[index];
            return ExtensionLangListTileWidget(
              lang: lang,
              onChanged: (val) {
                final now = DateTime.now().millisecondsSinceEpoch;
                final toUpdate = entries
                    .where(
                      (source) =>
                          source.lang!.toLowerCase() == lang.toLowerCase(),
                    )
                    .map(
                      (source) => source
                        ..isActive = val
                        ..updatedAt = now,
                    )
                    .toList();
                sourceRepository.putAll(toUpdate);
              },
              value: entries
                  .where(
                    (element) =>
                        element.lang!.toLowerCase() == lang.toLowerCase() &&
                        element.isActive!,
                  )
                  .isNotEmpty,
            );
          },
        );
      },
    );
    return mobile
        ? MobileBrowsePage(
            title: '${itemType.localized(l10n)} · ${l10n.language}',
            actions: actions,
            body: body,
          )
        : Scaffold(
            appBar: AppBar(title: Text(l10n.extensions), actions: actions),
            body: body,
          );
  }
}
