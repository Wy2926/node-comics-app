import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Presentation shared by the reading history and library updates screens.
/// Queries, chapter navigation and mutations remain with their owners.
class MobileActivityHeader extends StatelessWidget {
  const MobileActivityHeader({
    super.key,
    required this.title,
    required this.mediaMenu,
    required this.actions,
    required this.controller,
    required this.searchLabel,
    required this.clearLabel,
    required this.onSearchChanged,
  });

  final String title, searchLabel, clearLabel;
  final Widget mediaMenu;
  final List<Widget> actions;
  final TextEditingController controller;
  final VoidCallback onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final inheritedMetrics = MediaQuery.of(context);
    return MediaQuery.fromView(
      view: View.of(context),
      child: Builder(
        builder: (keyboardContext) {
          final compact = MediaQuery.viewInsetsOf(keyboardContext).bottom > 0;
          return MediaQuery(
            data: inheritedMetrics,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!compact) ...[
                    Text(
                      title,
                      style: TextStyle(
                        color: colors.ink,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(child: mediaMenu),
                        ...actions,
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextField(
                    controller: controller,
                    onChanged: (_) => onSearchChanged(),
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                    textInputAction: TextInputAction.search,
                    style: TextStyle(fontSize: 16, color: colors.ink),
                    decoration: InputDecoration(
                      hintText: searchLabel,
                      filled: true,
                      fillColor: colors.soft,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: controller,
                        builder: (context, value, _) => value.text.isEmpty
                            ? const SizedBox.shrink()
                            : IconButton(
                                tooltip: clearLabel,
                                onPressed: () {
                                  controller.clear();
                                  onSearchChanged();
                                },
                                icon: const Icon(Icons.cancel_rounded),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MobileActivityCard extends StatelessWidget {
  const MobileActivityCard({
    super.key,
    required this.title,
    required this.chapter,
    required this.cover,
    required this.onRead,
    required this.onDetail,
    required this.readLabel,
    required this.detailLabel,
    this.metadata,
    this.trailing,
    this.muted = false,
  });

  final String title, chapter, readLabel, detailLabel;
  final String? metadata;
  final Widget cover;
  final Widget? trailing;
  final VoidCallback onRead, onDetail;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Semantics(
                button: true,
                label: detailLabel,
                child: Tooltip(
                  message: detailLabel,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: onDetail,
                      child: SizedBox(width: 60, height: 90, child: cover),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Semantics(
                  button: true,
                  label: readLabel,
                  child: InkWell(
                    onTap: onRead,
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 90),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.ink,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            chapter,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: muted ? colors.muted : colors.ink,
                            ),
                          ),
                          if (metadata != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              metadata!,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.muted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 4), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}

class MobileActivityEmpty extends StatelessWidget {
  const MobileActivityEmpty({
    super.key,
    required this.icon,
    required this.message,
    this.resetLabel,
    this.onReset,
  });
  final IconData icon;
  final String message;
  final String? resetLabel;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      children: [
        Icon(icon, size: 44, color: colors.accent),
        const SizedBox(height: 20),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colors.ink,
          ),
        ),
        if (onReset != null) ...[
          const SizedBox(height: 16),
          Center(
            child: TextButton(onPressed: onReset, child: Text(resetLabel!)),
          ),
        ],
      ],
    );
  }
}
