import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Only edits a draft. The owner decides when and where to submit it.
class MobileSearchField extends StatelessWidget {
  const MobileSearchField({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.onClear,
    required this.submitLabel,
    this.autofocus = false,
  });
  final TextEditingController controller;
  final VoidCallback onSubmit, onClear;
  final String submitLabel;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context), l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: Semantics(
            label: l10n.search,
            child: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, _) => TextField(
                controller: controller,
                autofocus: autofocus,
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
          tooltip: submitLabel,
          constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
          onPressed: onSubmit,
          icon: const Icon(Icons.search_rounded),
        ),
      ],
    );
  }
}
