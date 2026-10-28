import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Display-only shelf toolbar. Its owner retains search, import and filters.
class MobileBookshelfHeader extends StatelessWidget {
  static double preferredHeight(double textScale) =>
      184 + 96 * (textScale - 1).clamp(0, 3);
  const MobileBookshelfHeader({
    super.key,
    required this.title,
    required this.searchLabel,
    required this.importLabel,
    required this.filterLabel,
    required this.controller,
    required this.onSearchChanged,
    required this.onImport,
    required this.onFilter,
    required this.mediaMenu,
    required this.menu,
    required this.filtered,
    this.count,
    this.updateControl,
  });

  final String title, searchLabel, importLabel, filterLabel;
  final TextEditingController controller;
  final VoidCallback onSearchChanged, onImport, onFilter;
  final Widget mediaMenu, menu;
  final Widget? updateControl;
  final int? count;
  final bool filtered;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Material(
      color: colors.canvas,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 12, 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -.8,
                            color: colors.ink,
                          ),
                        ),
                        mediaMenu,
                      ],
                    ),
                  ),
                  ?updateControl,
                  IconButton.filledTonal(
                    tooltip: importLabel,
                    onPressed: onImport,
                    style: IconButton.styleFrom(
                      backgroundColor: colors.accentSoft,
                      foregroundColor: colors.accent,
                      minimumSize: const Size(44, 44),
                    ),
                    icon: const Icon(Icons.add_rounded),
                  ),
                  menu,
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (_) => onSearchChanged(),
                      textInputAction: TextInputAction.search,
                      style: TextStyle(fontSize: 16, color: colors.ink),
                      decoration: InputDecoration(
                        hintText: count == null
                            ? searchLabel
                            : '$searchLabel · $count',
                        hintStyle: TextStyle(color: colors.muted),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: colors.muted,
                          size: 22,
                        ),
                        suffixIcon: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: controller,
                          builder: (context, value, _) => value.text.isEmpty
                              ? const SizedBox.shrink()
                              : IconButton(
                                  tooltip: MaterialLocalizations.of(context)
                                      .deleteButtonTooltip,
                                  onPressed: () {
                                    controller.clear();
                                    onSearchChanged();
                                  },
                                  icon: const Icon(
                                    Icons.cancel_rounded,
                                    size: 20,
                                  ),
                                ),
                        ),
                        filled: true,
                        fillColor: colors.soft,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colors.accent,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Badge(
                    isLabelVisible: filtered,
                    child: IconButton(
                      tooltip: filterLabel,
                      onPressed: onFilter,
                      style: IconButton.styleFrom(
                        minimumSize: const Size(48, 48),
                        foregroundColor: filtered ? colors.accent : colors.ink,
                      ),
                      icon: const Icon(Icons.tune_rounded),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
