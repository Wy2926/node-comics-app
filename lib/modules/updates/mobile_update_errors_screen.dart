import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/widgets/mobile_error_list.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class MobileUpdateErrorsScreen extends StatelessWidget {
  const MobileUpdateErrorsScreen({
    super.key,
    required this.errors,
    required this.findManga,
    required this.onMigrate,
    required this.onDismiss,
    required this.onClear,
  });

  final List<UpdateError> errors;
  final Manga? Function(int id) findManga;
  final ValueChanged<Manga> onMigrate;
  final ValueChanged<int> onDismiss;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => MobileErrorList(
    title: context.l10n.update_errors,
    emptyMessage: context.l10n.no_update_errors,
    clearLabel: context.l10n.clear_all,
    itemCount: errors.length,
    onClear: onClear,
    findChildIndexCallback: (key) {
      final index = errors.indexOf((key as ObjectKey).value as UpdateError);
      return index < 0 ? null : index;
    },
    itemBuilder: (context, index) {
      final error = errors[index];
      // Keep the original lazy lookup. No extra per-row subscriptions or
      // network covers are introduced by the phone view.
      final manga = findManga(error.mangaId);
      final cover = manga?.customCoverImage;
      final colors = NodeLaneTokens.of(context);
      return MobileSettingsGroup(
        key: ObjectKey(error),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 40,
                      height: 56,
                      child: cover != null && cover.isNotEmpty
                          ? Image.memory(
                              Uint8List.fromList(cover),
                              fit: BoxFit.cover,
                              cacheWidth:
                                  (40 * MediaQuery.devicePixelRatioOf(context))
                                      .ceil(),
                              errorBuilder: (_, _, _) => Icon(
                                Icons.broken_image_outlined,
                                color: colors.muted,
                              ),
                            )
                          : ColoredBox(
                              color: colors.soft,
                              child: Icon(
                                Icons.book_outlined,
                                color: colors.muted,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    error.name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: colors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ExpansionTile(
            key: PageStorageKey(error),
            shape: const Border(),
            collapsedShape: const Border(),
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Text(context.l10n.error),
            subtitle: Text(
              error.error,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SelectableText has its own scroll position; do not share the
              // expansion tile's boolean PageStorage entry with that offset.
              SelectableText(
                error.error,
                key: const PageStorageKey('error-text'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (manga != null)
                  OutlinedButton.icon(
                    onPressed: () => onMigrate(manga),
                    icon: const Icon(Icons.swap_horiz_rounded),
                    label: Text(context.l10n.migrate),
                  ),
                TextButton.icon(
                  onPressed: () => onDismiss(error.mangaId),
                  icon: const Icon(Icons.close_rounded),
                  label: Text(context.l10n.dismiss),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
