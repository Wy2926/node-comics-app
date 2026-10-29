import 'package:flutter/material.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Presentation only: editing a draft does not submit a source request.
class MobileGlobalSearchPage extends StatelessWidget {
  const MobileGlobalSearchPage({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.onClear,
    required this.scope,
    required this.query,
    required this.results,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit, onClear;
  final String scope, query;
  final Widget results;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final l10n = context.l10n;
    return MobileBrowsePage(
      title: l10n.global_search,
      body: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * .55,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          label: l10n.search,
                          child: ValueListenableBuilder(
                            valueListenable: controller,
                            builder: (context, value, _) => TextField(
                              controller: controller,
                              autofocus: controller.text.isEmpty,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (_) => onSubmit(),
                              style: TextStyle(fontSize: 16, color: colors.ink),
                              decoration: InputDecoration(
                                hintText: l10n.search,
                                filled: true,
                                fillColor: colors.soft,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(14),
                                suffixIcon: value.text.isEmpty
                                    ? null
                                    : IconButton(
                                        tooltip: l10n.reset,
                                        onPressed: onClear,
                                        icon: const Icon(Icons.close_rounded),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        tooltip: l10n.global_search,
                        constraints: const BoxConstraints(
                          minHeight: 48,
                          minWidth: 48,
                        ),
                        onPressed: onSubmit,
                        icon: const Icon(Icons.search_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ValueKey(query),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(scope, style: TextStyle(color: colors.muted)),
                          const SizedBox(height: 8),
                          Semantics(
                            header: true,
                            child: Text(
                              query.trim().isEmpty
                                  ? l10n.popular
                                  : l10n.global_search_results_for(query),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                    results,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileGlobalSourceSection extends StatelessWidget {
  const MobileGlobalSourceSection({
    super.key,
    required this.title,
    required this.language,
    required this.onOpen,
    required this.loading,
    required this.count,
    required this.itemBuilder,
  });

  final String title, language;
  final VoidCallback onOpen;
  final bool loading;
  final int count;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Semantics(
              button: true,
              child: Material(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onOpen,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Semantics(
                                header: true,
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: colors.ink,
                                  ),
                                ),
                              ),
                              if (language.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  language,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: colors.muted,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.chevron_right_rounded, color: colors.muted),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: LinearProgressIndicator(),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final width = ((constraints.maxWidth - 52) / 2).clamp(
                  120.0,
                  180.0,
                );
                final height =
                    width * 1.42 +
                    10 +
                    MediaQuery.textScalerOf(context).scale(15) * 1.3 * 2;
                return SizedBox(
                  height: height,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: count,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) => SizedBox(
                      width: width,
                      child: itemBuilder(context, index),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class MobileGlobalSearchEmpty extends StatelessWidget {
  const MobileGlobalSearchEmpty({
    super.key,
    required this.message,
    required this.hint,
    required this.actionLabel,
    required this.onAction,
  });
  final String message, hint, actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => MobileBrowseGroup(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.extension_off_outlined,
            size: 36,
            color: NodeLaneTokens.of(context).muted,
          ),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(hint),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: onAction,
            child: Text(actionLabel, textAlign: TextAlign.center),
          ),
        ],
      ),
    ),
  );
}

class MobileGlobalResultCard extends StatelessWidget {
  const MobileGlobalResultCard({
    super.key,
    required this.title,
    required this.cover,
    required this.inLibrary,
    required this.onOpen,
    required this.onQuickAdd,
  });
  final String title;
  final Widget cover;
  final bool inLibrary;
  final VoidCallback onOpen, onQuickAdd;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Semantics(
      button: true,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
          onTap: onOpen,
          onLongPress: onQuickAdd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    NodeLaneTokens.coverRadius,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ExcludeSemantics(
                        child: ColoredBox(color: colors.soft, child: cover),
                      ),
                      if (inLibrary)
                        PositionedDirectional(
                          top: 8,
                          start: 8,
                          child: Semantics(
                            label: context.l10n.in_library,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  Icons.collections_bookmark_rounded,
                                  size: 20,
                                  color: colors.accent,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ExcludeSemantics(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
