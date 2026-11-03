import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_brand_mark.dart';

/// The full screen shown while the app finishes starting up.
///
/// The transparent brand artwork sits on the active theme's background.
class LoadingIcon extends StatelessWidget {
  const LoadingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: const Center(child: NodeLaneBrandMark()),
    );
  }
}
