import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// The mobile hierarchy is media, then sources or extensions. Routing and
/// queries stay with BrowseScreen; this header only presents their controls.
class MobileBrowseHeader extends StatelessWidget {
  const MobileBrowseHeader({
    super.key,
    required this.title,
    required this.mediaMenu,
    required this.sourcesLabel,
    required this.extensionsLabel,
    required this.extensionsSelected,
    required this.onSectionChanged,
    required this.searchHint,
    required this.searchController,
    required this.onQueryChanged,
    required this.onGlobalSearch,
    required this.filterLabel,
    required this.onFilter,
    required this.clearLabel,
    required this.actions,
    this.updateCount = 0,
  });

  final String title, sourcesLabel, extensionsLabel, searchHint;
  final String filterLabel, clearLabel;
  final Widget mediaMenu;
  final List<Widget> actions;
  final bool extensionsSelected;
  final int updateCount;
  final TextEditingController searchController;
  final ValueChanged<bool> onSectionChanged;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onGlobalSearch, onFilter;

  @override
  Widget build(BuildContext context) {
    final inheritedMetrics = MediaQuery.of(context);
    // Scaffold consumes the keyboard inset. Subscribe to the view's metrics
    // here so dismissing Android's keyboard restores the header without a tap.
    return MediaQuery.fromView(
      view: View.of(context),
      child: Builder(
        builder: (keyboardContext) => MediaQuery(
          // Retain the surrounding safe-area and user text-scale adjustments.
          data: inheritedMetrics,
          child: _content(
            context,
            MediaQuery.viewInsetsOf(keyboardContext).bottom > 0,
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, bool compact) {
    final colors = NodeLaneTokens.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 12, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: !compact,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: colors.ink,
                          ),
                        ),
                        mediaMenu,
                      ],
                    ),
                  ),
                  ...actions,
                ],
              ),
            ),
          ),
          Visibility(
            visible: !compact,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.soft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      _section(context, sourcesLabel, false),
                      _section(context, extensionsLabel, true),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: extensionsSelected
                    ? TextField(
                        controller: searchController,
                        onChanged: onQueryChanged,
                        onSubmitted: (_) => FocusScope.of(context).unfocus(),
                        textInputAction: TextInputAction.search,
                        style: TextStyle(fontSize: 16, color: colors.ink),
                        decoration: InputDecoration(
                          hintText: searchHint,
                          filled: true,
                          fillColor: colors.soft,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: clearLabel,
                                  onPressed: () {
                                    searchController.clear();
                                    onQueryChanged('');
                                  },
                                  icon: const Icon(Icons.cancel_rounded),
                                ),
                        ),
                      )
                    : Material(
                        color: colors.soft,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: onGlobalSearch,
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Icon(Icons.search_rounded, color: colors.muted),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    searchHint,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: colors.muted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: filterLabel,
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                onPressed: onFilter,
                icon: Icon(
                  extensionsSelected
                      ? Icons.translate_rounded
                      : Icons.tune_rounded,
                  color: colors.ink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String label, bool extensions) {
    final colors = NodeLaneTokens.of(context);
    final selected = extensionsSelected == extensions;
    return Expanded(
      child: Semantics(
        selected: selected,
        child: Material(
          color: selected ? colors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => onSectionChanged(extensions),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selected ? colors.ink : colors.muted,
                          fontSize: 15,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (extensions && updateCount > 0) ...[
                      const SizedBox(width: 6),
                      Badge(label: Text(updateCount.toString())),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
