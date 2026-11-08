import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/about/software_update_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

Future<void> showAppUpdateAnnouncement(
  BuildContext context,
  UpdateInfo update,
) async {
  final router = GoRouter.of(context);
  if (router.state.uri.path == '/appUpdate') return;
  final view = await showDialog<bool>(
    context: context,
    builder: (_) => AppUpdateDialog(version: update.$1),
  );
  if (view == true &&
      context.mounted &&
      router.state.uri.path != '/appUpdate') {
    await context.push('/appUpdate', extra: update);
  }
}

/// A reminder only. Release notes and all installation actions live on the page.
class AppUpdateDialog extends StatefulWidget {
  const AppUpdateDialog({super.key, required this.version});
  final String version;
  @override
  State<AppUpdateDialog> createState() => _AppUpdateDialogState();
}

class _AppUpdateDialogState extends State<AppUpdateDialog> {
  bool _decided = false;
  void _finish(bool view) {
    if (_decided) return;
    setState(() => _decided = true);
    Navigator.of(context).pop(view);
  }

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), l = context.l10n;
    return NodeLaneModalScope(
      child: Dialog(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        insetPadding: NodeLaneTokens.modalInset,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NodeLaneTokens.modalRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: NodeLaneTokens.dialogMaxWidth,
          child: Stack(
            children: [
              const PositionedDirectional(
                top: 8,
                end: 12,
                child: AppUpdateMotif(),
              ),
              if (!MediaQuery.highContrastOf(context))
                PositionedDirectional(
                  bottom: 0,
                  end: 0,
                  child: ExcludeSemantics(
                    child: CustomPaint(
                      size: const Size(28, 28),
                      painter: _UpdateCorner(t.accent),
                    ),
                  ),
                ),
              LayoutBuilder(
                builder: (context, constraints) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 52, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(l.app_name, style: t.readerLabel),
                            const SizedBox(height: NodeLaneTokens.space16),
                            Semantics(
                              namesRoute: true,
                              header: true,
                              child: Text(
                                l.new_update_available,
                                style: t.detailTitle,
                              ),
                            ),
                            const SizedBox(height: NodeLaneTokens.space8),
                            Text(
                              widget.version,
                              style: t.pageTitle.copyWith(fontSize: 36),
                            ),
                            const SizedBox(height: NodeLaneTokens.space8),
                            Text(
                              l.app_update_details_hint,
                              style: t.readerSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight * .65,
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilledButton(
                              onPressed: _decided ? null : () => _finish(true),
                              child: Text(
                                l.app_update_view,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: NodeLaneTokens.space8),
                            TextButton(
                              onPressed: _decided ? null : () => _finish(false),
                              child: Text(l.app_update_later),
                            ),
                          ],
                        ),
                      ),
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

class _UpdateCorner extends CustomPainter {
  const _UpdateCorner(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..close(),
      Paint()..color = color.withValues(alpha: .45),
    );
  }

  @override
  bool shouldRepaint(_UpdateCorner oldDelegate) => color != oldDelegate.color;
}
