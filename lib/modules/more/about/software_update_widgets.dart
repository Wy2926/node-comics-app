import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class AppUpdateHeader extends StatelessWidget {
  const AppUpdateHeader({
    super.key,
    required this.version,
    required this.currentVersion,
    required this.available,
  });
  final String version, currentVersion;
  final bool available;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NodeLaneTokens.space16,
        vertical: NodeLaneTokens.space24,
      ),
      child: Stack(
        children: [
          if (version.length <= 8 &&
              MediaQuery.textScalerOf(context).scale(16) <= 22)
            const PositionedDirectional(
              end: 0,
              top: 64,
              child: AppUpdateMotif(),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExcludeSemantics(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CustomPaint(
                    size: const Size(45, 44),
                    painter: _PageMark(t.accent),
                  ),
                ),
              ),
              const SizedBox(height: NodeLaneTokens.space12),
              Text(l.app_name, style: t.detailSectionTitle),
              const SizedBox(height: NodeLaneTokens.space8),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: t.accentSoft,
                    borderRadius: BorderRadius.circular(
                      NodeLaneTokens.controlRadius,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NodeLaneTokens.space12,
                      vertical: NodeLaneTokens.space4,
                    ),
                    child: Text(
                      available ? l.new_update_available : l.installed_version,
                      style: t.secondary.copyWith(
                        color: t.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: NodeLaneTokens.space12),
              Semantics(
                header: true,
                child: Text(
                  version,
                  style: t.pageTitle.copyWith(
                    fontSize: 52,
                    height: 1.1,
                    letterSpacing: -1.5,
                  ),
                ),
              ),
              if (available && currentVersion.isNotEmpty) ...[
                const SizedBox(height: NodeLaneTokens.space8),
                Text(
                  '${l.installed_version} $currentVersion',
                  style: t.readerSecondary,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// A quiet page outline shared by the page and reminder, hidden in high contrast.
class AppUpdateMotif extends StatelessWidget {
  const AppUpdateMotif({super.key});
  @override
  Widget build(BuildContext context) => MediaQuery.highContrastOf(context)
      ? const SizedBox.shrink()
      : ExcludeSemantics(
          child: CustomPaint(
            size: const Size(128, 120),
            painter: _PageLine(NodeLaneTokens.of(context).accent),
          ),
        );
}

class _PageLine extends CustomPainter {
  const _PageLine(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final pen = Paint()
      ..color = color.withValues(alpha: .25)
      ..strokeWidth = .8
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(6, 92)
      ..cubicTo(8, 52, 74, 57, 120, 20)
      ..cubicTo(100, 56, 110, 88, 62, 102);
    canvas.drawPath(path, pen);
    canvas.drawLine(const Offset(120, 20), const Offset(114, 111), pen);
    final dots = Paint()..color = color.withValues(alpha: .35);
    for (var i = 0; i < 3; i++) {
      canvas.drawCircle(Offset(51 + i * 12, 12), 1.5, dots);
    }
  }

  @override
  bool shouldRepaint(_PageLine oldDelegate) => color != oldDelegate.color;
}

class _PageMark extends CustomPainter {
  const _PageMark(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < 3; i++) {
      final x = 3.0 + i * 9;
      final path = Path()
        ..moveTo(x, 15)
        ..lineTo(x + 20, 2)
        ..quadraticBezierTo(x + 24, 0, x + 24, 5)
        ..lineTo(x + 24, 29)
        ..lineTo(x + 4, 42)
        ..quadraticBezierTo(x, 44, x, 39)
        ..close();
      canvas.drawPath(
        path,
        Paint()..color = color.withValues(alpha: .28 + i * .2),
      );
    }
  }

  @override
  bool shouldRepaint(_PageMark oldDelegate) => color != oldDelegate.color;
}

/// The release content retains its scroll position while transfer state changes.
/// Extreme text scaling gets a separately scrollable footer, with no clipping.
class AppUpdatePageLayout extends StatelessWidget {
  const AppUpdatePageLayout({
    super.key,
    required this.content,
    required this.footer,
  });
  final Widget content, footer;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            key: const PageStorageKey('app-update-content'),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: content,
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight * .55),
          child: SingleChildScrollView(
            key: const PageStorageKey('app-update-actions'),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: footer,
          ),
        ),
      ],
    ),
  );
}
