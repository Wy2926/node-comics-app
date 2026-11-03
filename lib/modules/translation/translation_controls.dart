import 'translation_language_picker.dart';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/widgets/mobile_nodelane_account.dart';
import 'package:mangayomi/modules/widgets/nodelane_reader_surface.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'translation_settings.dart';
import 'translation_view_controller.dart';

void showTranslationControls(
  BuildContext context,
  TranslationViewController controller, {
  String title = '漫画翻译',
  String? subtitle,
  bool browser = false,
}) {
  final mobile = isMobile && !isTv;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: mobile,
    useSafeArea: mobile,
    showDragHandle: false,
    shape: mobile ? NodeLaneTokens.readerSheetShape : null,
    backgroundColor: mobile ? Colors.transparent : null,
    builder: (context) {
      final content = TranslationControlsContent(
        controller: controller,
        mobile: mobile,
        title: title,
        subtitle: subtitle,
        browser: browser,
      );
      return mobile
          ? ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * .8,
              ),
              child: content,
            )
          : content;
    },
  );
}

/// Both reader and browser use the same controller and recovery actions.
/// The mobile variant only changes their presentation.
class TranslationControlsContent extends StatelessWidget {
  const TranslationControlsContent({
    super.key,
    required this.controller,
    this.mobile = false,
    this.title = '漫画翻译',
    this.subtitle,
    this.browser = false,
  });
  final TranslationViewController controller;
  final bool mobile, browser;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) =>
      mobile ? _mobile(context) : _legacy(context);

  Widget _legacy(BuildContext context) => SafeArea(
    top: false,
    child: ListenableBuilder(
      listenable: controller,
      builder: (context, _) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.runtime == null)
              ListTile(
                title: const Text('登录后开启翻译'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openPage(context, const TranslationSettings()),
              ),
            SwitchListTile.adaptive(
              title: const Text('翻译当前阅读范围'),
              subtitle: const Text('按当前页和随后两页处理'),
              value: controller.enabled,
              onChanged: controller.runtime == null
                  ? null
                  : (value) => controller.configure(enabled: value),
            ),
            SwitchListTile(
              title: const Text('显示译图'),
              value: controller.showTranslation,
              onChanged: (value) =>
                  controller.configure(showTranslation: value),
            ),
            for (final target in controller.targets)
              ListTile(
                title: Text(
                  '第 ${controller.targets.indexOf(target) + 1} 张 · ${controller.state(target).noText ? '无可译文字' : controller.state(target).message}',
                ),
                trailing: controller.state(target).actions.isEmpty
                    ? null
                    : PopupMenuButton<TranslationAction>(
                        onSelected: (action) =>
                            controller.perform(target, action),
                        itemBuilder: (_) => [
                          for (final action in controller.state(target).actions)
                            PopupMenuItem(
                              value: action,
                              child: Text(_actionLabel(action)),
                            ),
                        ],
                      ),
              ),
            if (controller.error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(controller.error!),
              ),
            ListTile(
              title: const Text('翻译设置'),
              trailing: const Icon(Icons.settings_outlined),
              onTap: () => _openPage(context, const TranslationSettings()),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _mobile(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final icons = NodeLaneIcons.of(context);
    return NodeLaneReaderSurface(
      child: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final statuses = controller.targets.where((target) {
              final state = controller.state(target);
              return state.message.isNotEmpty ||
                  state.noText ||
                  state.actions.isNotEmpty;
            }).toList();
            final scopeControl = SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text('翻译当前阅读范围', style: colors.readerLabel),
              subtitle: Text(
                browser ? '处理当前及相邻图片' : '按当前页和随后两页处理',
                style: colors.readerSecondary,
              ),
              value: controller.enabled,
              onChanged: controller.runtime == null
                  ? null
                  : (value) => controller.configure(enabled: value),
            );
            final displayControl = NodeLaneSegments<bool>(
              pill: true,
              labelStyle: colors.readerLabel,
              value: controller.showTranslation,
              segments: const [
                ButtonSegment(value: false, label: Text('原图')),
                ButtonSegment(value: true, label: Text('译图')),
              ],
              onChanged: (value) =>
                  controller.configure(showTranslation: value),
            );
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NodeLaneReaderHeading(
                  title: title,
                  closeLabel: MaterialLocalizations.of(context)
                      .closeButtonTooltip,
                  onClose: () => Navigator.pop(context),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (subtitle != null) ...[
                          Text(subtitle!, style: colors.readerSecondary),
                          const SizedBox(height: 12),
                        ],
                        if (controller.runtime == null) ...[
                          NodeLaneGroupSurface(
                            child: ListTile(
                              leading: Icon(
                                icons.account,
                                color: colors.accent,
                                size: 24,
                              ),
                              title: Text(
                                '登录后开启翻译',
                                style: colors.readerLabel.copyWith(
                                  color: colors.accent,
                                ),
                              ),
                              trailing: Icon(
                                icons.forward,
                                size: 16,
                                color: colors.muted,
                              ),
                              onTap: () => _openPage(
                                context,
                                const MobileNodeLaneAccountPage(),
                              ),
                            ),
                          ),
                          if (!browser) const SizedBox(height: 16),
                        ],
                        if (!browser || controller.runtime != null) ...[
                          if (browser)
                            NodeLaneGroupSurface(
                              child: Column(
                                children: [
                                  scopeControl,
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      12,
                                      0,
                                      12,
                                      12,
                                    ),
                                    child: displayControl,
                                  ),
                                ],
                              ),
                            )
                          else ...[
                            NodeLaneGroupSurface(child: scopeControl),
                            const SizedBox(height: 16),
                            displayControl,
                          ],
                          if (browser) ...[
                            const SizedBox(height: 16),
                            NodeLaneGroupSurface(
                              child: Column(
                                children: [
                                  const TranslationLanguageRow(),
                                  Divider(
                                    height: 1,
                                    indent: 56,
                                    color: colors.line,
                                  ),
                                  _BrowserTranslationProgress(
                                    controller: controller,
                                    statuses: statuses,
                                    rowBuilder: (target) =>
                                        _statusRow(context, target),
                                  ),
                                ],
                              ),
                            ),
                          ] else if (statuses.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            NodeLaneGroupSurface(
                              child: Column(
                                children: [
                                  for (var i = 0; i < statuses.length; i++) ...[
                                    if (i > 0)
                                      Divider(
                                        height: 1,
                                        indent: 56,
                                        color: colors.line,
                                      ),
                                    _statusRow(context, statuses[i]),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ],
                        if (controller.error != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            controller.error!,
                            style: colors.readerSecondary.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                        if (!browser || controller.runtime == null) ...[
                          const SizedBox(height: 16),
                          const NodeLaneGroupSurface(
                            child: TranslationLanguageRow(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _statusRow(BuildContext context, TranslationTarget target) {
    final state = controller.state(target);
    final colors = NodeLaneTokens.of(context);
    final icons = NodeLaneIcons.of(context);
    final working = {
      TranslationPhase.preparing,
      TranslationPhase.submitting,
      TranslationPhase.awaitingInput,
      TranslationPhase.queued,
      TranslationPhase.running,
    }.contains(state.phase);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: working
          ? SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.accent,
              ),
            )
          : Icon(
              state.phase == TranslationPhase.failed ||
                      state.phase == TranslationPhase.uncertain
                  ? icons.error
                  : icons.downloaded,
              size: 24,
              color: colors.accent,
            ),
      title: Text(
        '第 ${controller.targets.indexOf(target) + 1} 张 · ${state.noText ? '无可译文字' : state.message}',
        style: colors.readerLabel,
      ),
      trailing: state.actions.isEmpty
          ? null
          : PopupMenuButton<TranslationAction>(
              tooltip: '本页翻译操作',
              icon: Icon(icons.more, color: colors.muted),
              onSelected: (action) => controller.perform(target, action),
              itemBuilder: (_) => [
                for (final action in state.actions)
                  PopupMenuItem(
                    value: action,
                    child: Text(_actionLabel(action)),
                  ),
              ],
            ),
    );
  }

  String _actionLabel(TranslationAction action) => switch (action) {
    TranslationAction.verify => '核实状态',
    TranslationAction.readResult => '重新读取译图',
    TranslationAction.retry => '重试本页翻译',
    TranslationAction.regenerate => '重新翻译本页',
  };

  void _openPage(BuildContext context, Widget page) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(MaterialPageRoute<void>(builder: (_) => page));
  }
}

/// A summary by default; existing per-image recovery actions stay one tap away.
class _BrowserTranslationProgress extends StatefulWidget {
  const _BrowserTranslationProgress({
    required this.controller,
    required this.statuses,
    required this.rowBuilder,
  });
  final TranslationViewController controller;
  final List<TranslationTarget> statuses;
  final Widget Function(TranslationTarget) rowBuilder;

  @override
  State<_BrowserTranslationProgress> createState() =>
      _BrowserTranslationProgressState();
}

class _BrowserTranslationProgressState
    extends State<_BrowserTranslationProgress> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final states = widget.controller.targets
        .map(widget.controller.state)
        .toList();
    final completed = states
        .where((state) => state.phase == TranslationPhase.succeeded)
        .length;
    final issues = states
        .where(
          (state) =>
              state.phase == TranslationPhase.failed ||
              state.phase == TranslationPhase.uncertain,
        )
        .length;
    return Column(
      children: [
        ListTile(
          contentPadding: NodeLaneTokens.rowPadding,
          leading: Icon(
            issues > 0 ? icons.error : icons.translate,
            size: NodeLaneTokens.iconSize,
            color: t.accent,
          ),
          title: Text(
            states.isEmpty
                ? '当前页面暂未发现可翻译图片'
                : '已完成 $completed / ${states.length} 张',
            style: t.readerLabel,
          ),
          subtitle: states.isEmpty
              ? null
              : Text(
                  issues > 0
                      ? '$issues 张需要处理 · 点击查看'
                      : widget.controller.enabled
                      ? '当前阅读范围 · 点击查看进度'
                      : '开启后处理当前及相邻图片',
                  style: t.readerSecondary,
                ),
          trailing: widget.statuses.isEmpty
              ? null
              : Icon(
                  expanded ? icons.down : icons.forward,
                  size: NodeLaneTokens.smallIconSize,
                  color: t.muted,
                ),
          onTap: widget.statuses.isEmpty
              ? null
              : () => setState(() => expanded = !expanded),
        ),
        if (expanded)
          for (final target in widget.statuses) ...[
            Divider(height: 1, indent: 56, color: t.line),
            widget.rowBuilder(target),
          ],
      ],
    );
  }
}
