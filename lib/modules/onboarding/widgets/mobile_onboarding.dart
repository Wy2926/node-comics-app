import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Only the current step scrolls; exit and next remain above the keyboard.
class MobileOnboardingFrame extends StatelessWidget {
  const MobileOnboardingFrame({
    super.key,
    required this.step,
    required this.title,
    required this.description,
    required this.child,
    required this.busy,
    required this.leaveLabel,
    required this.onLeave,
    this.onBack,
    this.onNext,
    this.error,
  });

  final int step;
  final String title, description, leaveLabel;
  final Widget child;
  final bool busy;
  final VoidCallback onLeave;
  final VoidCallback? onBack, onNext;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: onBack == null
              ? null
              : IconButton(
                  onPressed: busy ? null : onBack,
                  tooltip: l10n.go_back,
                  icon: const BackButtonIcon(),
                ),
          title: Semantics(
            label: l10n.onboarding_step_count(step, 2),
            child: ExcludeSemantics(child: Text('$step / 2')),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: PageStorageKey('mobile-onboarding-$step'),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: TextStyle(color: colors.muted, height: 1.45),
                      ),
                      const SizedBox(height: 24),
                      if (busy) ...[
                        const LinearProgressIndicator(),
                        const SizedBox(height: 16),
                      ],
                      child,
                      if (error != null) ...[
                        const SizedBox(height: 12),
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            error!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Divider(height: 1, color: colors.line),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (onNext != null) ...[
                      FilledButton(
                        onPressed: busy ? null : onNext,
                        child: Text(l10n.onboarding_next),
                      ),
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: busy ? null : onLeave,
                        child: Text(leaveLabel),
                      ),
                    ] else
                      FilledButton(
                        onPressed: busy ? null : onLeave,
                        child: Text(leaveLabel),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _label(BuildContext context, ItemType type) => switch (type) {
  ItemType.manga => context.l10n.manga,
  ItemType.anime => context.l10n.anime,
  ItemType.novel => context.l10n.novel,
};

class MobileOnboardingLibraries extends StatelessWidget {
  const MobileOnboardingLibraries({
    super.key,
    required this.selected,
    required this.busy,
    required this.onToggle,
    required this.onRestore,
  });
  final Set<ItemType> selected;
  final bool busy;
  final ValueChanged<ItemType> onToggle;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      MobileSettingsGroup(
        children: [
          for (final type in ItemType.values)
            CheckboxListTile.adaptive(
              title: Text(_label(context, type)),
              value: selected.contains(type),
              onChanged:
                  busy || (selected.length == 1 && selected.contains(type))
                  ? null
                  : (_) => onToggle(type),
            ),
        ],
      ),
      OutlinedButton.icon(
        onPressed: busy ? null : onRestore,
        icon: const Icon(Icons.settings_backup_restore_rounded),
        label: Text(
          context.l10n.onboarding_restore,
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}

/// The owner retains URL validation, media identity, writes and folder scans.
class MobileOnboardingSources extends StatelessWidget {
  const MobileOnboardingSources({
    super.key,
    required this.libraries,
    required this.repoType,
    required this.onRepoType,
    required this.urlController,
    required this.onUrlChanged,
    required this.canAdd,
    required this.onAdd,
    required this.busy,
    required this.onAddFolder,
    this.onRemoveFolder,
    this.repoError,
    this.addedName,
    this.folderStatus,
  });
  final List<ItemType> libraries;
  final ItemType repoType;
  final ValueChanged<ItemType> onRepoType;
  final TextEditingController urlController;
  final VoidCallback onUrlChanged, onAdd, onAddFolder;
  final VoidCallback? onRemoveFolder;
  final bool busy, canAdd;
  final String? repoError, addedName;
  final Widget? folderStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MobileSettingsGroup(
          title: l10n.onboarding_add,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.onboarding_body,
                    style: TextStyle(color: colors.muted),
                  ),
                  if (libraries.length > 1) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final type in libraries)
                          ChoiceChip(
                            label: Text(_label(context, type)),
                            selected: repoType == type,
                            showCheckmark: false,
                            onSelected: busy ? null : (_) => onRepoType(type),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextField(
                    controller: urlController,
                    enabled: !busy,
                    autocorrect: false,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) => onUrlChanged(),
                    onSubmitted: (_) {
                      if (canAdd && !busy) onAdd();
                    },
                    decoration: InputDecoration(
                      labelText: l10n.repo_url,
                      border: const OutlineInputBorder(),
                      errorText: repoError,
                      errorMaxLines: 8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: canAdd && !busy ? onAdd : null,
                    child: Text(
                      l10n.onboarding_add,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (addedName != null) ...[
                    const SizedBox(height: 16),
                    Semantics(
                      liveRegion: true,
                      child: Text('${l10n.repo_added}\n$addedName'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        MobileSettingsGroup(
          title: l10n.local_folder,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.onboarding_local_any_type,
                    style: TextStyle(color: colors.muted),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: busy ? null : onAddFolder,
                    icon: const Icon(Icons.folder_open_rounded),
                    label: Text(
                      l10n.onboarding_local_folder,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (folderStatus != null) ...[
                    const SizedBox(height: 16),
                    folderStatus!,
                  ],
                  if (onRemoveFolder != null) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: busy ? null : onRemoveFolder,
                      child: Text(
                        l10n.onboarding_local_remove,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
