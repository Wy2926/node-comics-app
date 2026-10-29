import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class MobileSettingOption<T> {
  const MobileSettingOption(
    this.value,
    this.label, {
    this.subtitle,
    this.leading,
  });
  final T value;
  final String label;
  final String? subtitle;
  final Widget? leading;
}

/// Returns the selected option, so a null-valued default remains distinct from
/// closing the page. The caller owns all preference writes.
Future<MobileSettingOption<T>?> showMobileSettingsPicker<T>(
  BuildContext context, {
  required String title,
  required T current,
  required List<MobileSettingOption<T>> options,
  bool searchable = false,
  String? description,
  String? emptyMessage,
}) => Navigator.of(context).push<MobileSettingOption<T>>(
  MaterialPageRoute(
    builder: (_) => _MobileSettingsPicker<T>(
      title: title,
      current: current,
      options: options,
      searchable: searchable,
      description: description,
      emptyMessage: emptyMessage,
    ),
  ),
);

class _MobileSettingsPicker<T> extends StatefulWidget {
  const _MobileSettingsPicker({
    required this.title,
    required this.current,
    required this.options,
    required this.searchable,
    this.description,
    this.emptyMessage,
  });
  final String title;
  final T current;
  final List<MobileSettingOption<T>> options;
  final bool searchable;
  final String? description;
  final String? emptyMessage;

  @override
  State<_MobileSettingsPicker<T>> createState() =>
      _MobileSettingsPickerState<T>();
}

class _MobileSettingsPickerState<T> extends State<_MobileSettingsPicker<T>> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clear() {
    _search.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final l10n = context.l10n;
    final query = _query.trim().toLowerCase();
    final options = widget.options
        .where(
          (option) => '${option.label} ${option.subtitle ?? ''}'
              .toLowerCase()
              .contains(query),
        )
        .toList();
    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              if (widget.description != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                    child: Text(
                      widget.description!,
                      style: TextStyle(color: colors.muted),
                    ),
                  ),
                ),
              if (widget.searchable)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  sliver: SliverToBoxAdapter(
                    child: TextField(
                      controller: _search,
                      onChanged: (value) => setState(() => _query = value),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
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
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              if (options.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          query.isEmpty
                              ? widget.emptyMessage ?? l10n.no_result
                              : l10n.no_result,
                        ),
                        if (query.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _clear,
                            child: Text(l10n.reset),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final selected = option.value == widget.current;
                    return Semantics(
                      selected: selected,
                      inMutuallyExclusiveGroup: true,
                      child: ListTile(
                        minTileHeight: 64,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: selected
                            ? colors.accentSoft
                            : colors.surface,
                        leading: option.leading,
                        title: Text(option.label),
                        subtitle: option.subtitle == null
                            ? null
                            : Text(option.subtitle!),
                        trailing: selected
                            ? Icon(Icons.check_rounded, color: colors.accent)
                            : null,
                        onTap: () => Navigator.pop(context, option),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
