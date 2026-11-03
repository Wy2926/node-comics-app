import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// Keep one maintenance flow open per entry, including while a confirmed
/// operation is waiting for its existing backup or repository call.
class MobileLibraryAction extends StatefulWidget {
  const MobileLibraryAction({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onOpen,
  });
  final String title, subtitle;
  final IconData icon;
  final Future<void> Function() onOpen;

  @override
  State<MobileLibraryAction> createState() => _MobileLibraryActionState();
}

class _MobileLibraryActionState extends State<MobileLibraryAction> {
  bool _busy = false;

  Future<void> _open() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.onOpen();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.failed)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: AbsorbPointer(
      absorbing: _busy,
      child: NodeLaneRow(
        title: widget.title,
        subtitle: widget.subtitle,
        subtitleMaxLines: 2,
        icon: widget.icon,
        onTap: _open,
      ),
    ),
  );
}
