import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

/// Owns the status area once. Pages below retain their existing SafeArea and
/// bottom insets, without knowing which reading modes are enabled.
class ModeBarsLayout extends StatelessWidget {
  const ModeBarsLayout({
    super.key,
    required this.mobile,
    required this.downloadedOnly,
    required this.incognitoMode,
    required this.l10n,
    required this.child,
  });

  final bool mobile, downloadedOnly, incognitoMode;
  final AppLocalizations l10n;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!mobile) {
      return Column(
        children: [
          DownloadedOnlyBar(downloadedOnly: downloadedOnly, l10n: l10n),
          IncognitoModeBar(incognitoMode: incognitoMode, l10n: l10n),
          Expanded(child: child),
        ],
      );
    }
    final visible = downloadedOnly || incognitoMode;
    final colors = NodeLaneTokens.of(context);
    return Column(
      children: [
        if (visible)
          Material(
            color: colors.surface,
            child: SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: colors.line)),
                ),
                child: Semantics(
                  liveRegion: true,
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 8,
                    children: [
                      if (downloadedOnly)
                        _ModeLabel(
                          Icons.cloud_off_outlined,
                          l10n.downloaded_only,
                        ),
                      if (incognitoMode)
                        _ModeLabel(
                          Icons.visibility_off_outlined,
                          l10n.incognito_mode,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          )
        else
          const SizedBox.shrink(),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: visible,
            child: child,
          ),
        ),
      ],
    );
  }
}

class _ModeLabel extends StatelessWidget {
  const _ModeLabel(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: colors.accent),
        const SizedBox(width: 8),
        Flexible(
          child: Text(label, style: TextStyle(fontSize: 13, color: colors.ink)),
        ),
      ],
    );
  }
}

final String? _barFontFamily = GoogleFonts.aBeeZee().fontFamily;

class DownloadedOnlyBar extends StatelessWidget {
  const DownloadedOnlyBar({
    super.key,
    required this.downloadedOnly,
    required this.l10n,
  });

  final bool downloadedOnly;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnimatedContainer(
        height: downloadedOnly
            ? isMobile
                  ? MediaQuery.paddingOf(context).top * 2
                  : 50
            : 0,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 150),
        color: context.secondaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                l10n.downloaded_only,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: _barFontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IncognitoModeBar extends StatelessWidget {
  const IncognitoModeBar({
    super.key,
    required this.incognitoMode,
    required this.l10n,
  });

  final bool incognitoMode;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnimatedContainer(
        height: incognitoMode
            ? isMobile
                  ? MediaQuery.paddingOf(context).top * 2
                  : 50
            : 0,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 150),
        color: context.primaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                l10n.incognito_mode,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: _barFontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
