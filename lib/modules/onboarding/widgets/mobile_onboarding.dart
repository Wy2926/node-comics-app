import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/nodelane_brand_mark.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

const _mediaOrder = [ItemType.manga, ItemType.novel, ItemType.anime];

/// The owner retains navigation and work; only the current step scrolls.
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
    final l = context.l10n, t = NodeLaneTokens.of(context);
    final welcome = step == 1;
    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(
          context,
          title: '$step / 2',
          semanticTitle: l.onboarding_step_count(step, 2),
          titleStyle: t.readerSecondary,
          busy: busy,
          onBack: onBack,
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: PageStorageKey('mobile-onboarding-$step'),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(
                    NodeLaneTokens.gutter,
                    NodeLaneTokens.space8,
                    NodeLaneTokens.gutter,
                    NodeLaneTokens.space8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (welcome) ...[
                        const Center(child: NodeLaneBrandMark()),
                        const SizedBox(height: NodeLaneTokens.space16),
                        Text(
                          l.onboarding_welcome,
                          textAlign: TextAlign.center,
                          style: t.readerSecondary,
                        ),
                        const SizedBox(height: NodeLaneTokens.space8),
                      ],
                      Semantics(
                        header: true,
                        child: Text(
                          title,
                          textAlign: welcome
                              ? TextAlign.center
                              : TextAlign.start,
                          style: t.detailTitle,
                        ),
                      ),
                      const SizedBox(height: NodeLaneTokens.space8),
                      Text(
                        description,
                        textAlign: welcome ? TextAlign.center : TextAlign.start,
                        style: t.readerSecondary,
                      ),
                      const SizedBox(height: NodeLaneTokens.space24),
                      child,
                      if (error != null) ...[
                        const SizedBox(height: NodeLaneTokens.space12),
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            error!,
                            style: t.readerSecondary.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  NodeLaneTokens.gutter,
                  NodeLaneTokens.space8,
                  NodeLaneTokens.gutter,
                  NodeLaneTokens.space8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: busy ? null : onNext ?? onLeave,
                      child: Text(
                        onNext == null ? leaveLabel : l.onboarding_continue,
                      ),
                    ),
                    if (onNext != null) ...[
                      const SizedBox(height: NodeLaneTokens.space4),
                      TextButton(
                        onPressed: busy ? null : onLeave,
                        child: Text(leaveLabel),
                      ),
                    ],
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
  Widget build(BuildContext context) {
    final l = context.l10n, t = NodeLaneTokens.of(context);
    final icons = NodeLaneIcons.of(context);
    final testingColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xffffcb70)
        : const Color(0xff956315);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: NodeLaneTokens.space12,
          runSpacing: NodeLaneTokens.space4,
          children: [
            Text(l.onboarding_reading_content, style: t.readerLabel),
            Text(l.onboarding_choose_one, style: t.readerSecondary),
          ],
        ),
        const SizedBox(height: NodeLaneTokens.space8),
        NodeLaneGroupSurface(
          children: [
            for (final type in _mediaOrder)
              NodeLaneRow(
                title: _label(context, type),
                valueLeading: type == ItemType.manga
                    ? null
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: testingColor.withValues(alpha: .1),
                          border: Border.all(
                            color: testingColor.withValues(alpha: .3),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.science_outlined,
                              size: 13,
                              color: testingColor,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                context.l10n.onboarding_untested,
                                style: t.caption.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: testingColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                icon: switch (type) {
                  ItemType.manga => icons.manga,
                  ItemType.novel => icons.novel,
                  ItemType.anime => icons.anime,
                },
                selected: selected.contains(type),
                checkable: true,
                enabled:
                    !busy && !(selected.length == 1 && selected.contains(type)),
                onTap: () => onToggle(type),
              ),
          ],
        ),
        const SizedBox(height: NodeLaneTokens.space16),
        NodeLaneRow.card(
          title: l.onboarding_restore,
          subtitle: l.onboarding_restore_hint,
          icon: icons.tracking,
          enabled: !busy,
          onTap: onRestore,
        ),
      ],
    );
  }
}

/// URL drafts, media identity, repository writes and scans remain with the owner.
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
    required this.onBrowse,
    required this.onAddFolder,
    this.repoError,
    this.addedName,
    this.folderStatus,
  });
  final List<ItemType> libraries;
  final ItemType repoType;
  final ValueChanged<ItemType> onRepoType;
  final TextEditingController urlController;
  final VoidCallback onUrlChanged, onAdd, onBrowse, onAddFolder;
  final bool busy, canAdd;
  final String? repoError, addedName;
  final Widget? folderStatus;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, t = NodeLaneTokens.of(context);
    final icons = NodeLaneIcons.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NodeLaneRow.card(
          title: l.bookshelf_browse_sources,
          subtitle: l.onboarding_browse_hint,
          icon: icons.navigation,
          enabled: !busy,
          onTap: onBrowse,
        ),
        const SizedBox(height: NodeLaneTokens.space16),
        if (folderStatus == null)
          NodeLaneRow.card(
            title: l.onboarding_import_folder,
            subtitle: l.onboarding_import_folder_hint,
            icon: icons.folderOutline,
            enabled: !busy,
            onTap: onAddFolder,
          )
        else
          NodeLaneDisclosure(
            key: const ValueKey('onboarding-local'),
            title: l.onboarding_import_folder,
            subtitle: l.onboarding_import_folder_hint,
            icon: icons.folderOutline,
            minHeight: NodeLaneTokens.catalogRowHeight,
            initiallyExpanded: true,
            child: folderStatus!,
          ),
        const SizedBox(height: NodeLaneTokens.space16),
        NodeLaneDisclosure(
          key: const ValueKey('onboarding-repository'),
          title: l.onboarding_third_party,
          subtitle: l.onboarding_third_party_hint,
          icon: icons.webLink,
          minHeight: NodeLaneTokens.catalogRowHeight,
          initiallyExpanded:
              urlController.text.isNotEmpty ||
              repoError != null ||
              addedName != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: NodeLaneTokens.groupPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l.onboarding_repository_hint,
                      style: t.readerSecondary,
                    ),
                    if (libraries.length > 1) ...[
                      const SizedBox(height: NodeLaneTokens.space12),
                      NodeLaneSegments<ItemType>(
                        value: repoType,
                        segments: [
                          for (final type in _mediaOrder.where(
                            libraries.contains,
                          ))
                            ButtonSegment(
                              value: type,
                              label: Text(_label(context, type)),
                            ),
                        ],
                        onChanged: busy ? null : onRepoType,
                      ),
                    ],
                  ],
                ),
              ),
              const NodeLaneGroupDivider(),
              Padding(
                padding: NodeLaneTokens.groupPadding,
                child: NodeLaneTextField(
                  controller: urlController,
                  label: l.onboarding_repository_address,
                  hint: l.onboarding_repository_address_hint,
                  enabled: !busy,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => onUrlChanged(),
                  onSubmitted: (_) {
                    if (canAdd && !busy) onAdd();
                  },
                ),
              ),
              const NodeLaneGroupDivider(),
              Padding(
                padding: NodeLaneTokens.groupPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (repoError != null) ...[
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          repoError!,
                          style: t.readerSecondary.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                      const SizedBox(height: NodeLaneTokens.space12),
                    ],
                    NodeLaneSecondaryButton(
                      onPressed: canAdd && !busy ? onAdd : null,
                      child: Text(l.onboarding_add_repository),
                    ),
                    if (addedName != null) ...[
                      const SizedBox(height: NodeLaneTokens.space12),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          '${l.repo_added}\n$addedName',
                          style: t.readerSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
