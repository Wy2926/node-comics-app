import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Edits a draft; submitting and saved-search navigation remain independent.
class MobileSearchField extends StatelessWidget {
  const MobileSearchField({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.onClear,
    required this.submitLabel,
    this.autofocus = false,
    this.hint,
    this.onSavedSearches,
  });
  final TextEditingController controller;
  final VoidCallback onSubmit, onClear;
  final VoidCallback? onSavedSearches;
  final String submitLabel;
  final String? hint;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), l10n = context.l10n;
    final icons = NodeLaneIcons.of(context);
    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, _) => TextField(
              controller: controller,
              autofocus: autofocus,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSubmit(),
              style: t.readerLabel,
              decoration: t.searchDecoration(
                hint ?? l10n.search,
                prefixIcon: Icon(icons.search, size: 20, color: t.muted),
                suffixIcon: value.text.isNotEmpty
                    ? IconButton(
                        tooltip: l10n.reset,
                        onPressed: onClear,
                        icon: Icon(icons.clear, size: 20, color: t.muted),
                      )
                    : onSavedSearches == null
                    ? null
                    : IconButton(
                        tooltip: l10n.saved_searches,
                        onPressed: onSavedSearches,
                        icon: Icon(
                          icons.bookmarkOutline,
                          size: 20,
                          color: t.muted,
                        ),
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: submitLabel,
          child: FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(64, 48),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            onPressed: onSubmit,
            child: Text(
              '搜索',
              style: t.readerSecondary.copyWith(
                color: t.onAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
