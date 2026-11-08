import 'package:flutter/material.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_settings_sheet.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class MobileReaderScreen extends StatelessWidget {
  const MobileReaderScreen({super.key});
  @override
  Widget build(BuildContext context) => NodeLaneSurface(
    child: Scaffold(
      appBar: nodeLaneAppBar(context, title: context.l10n.comic_defaults_title),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: NodeLaneTokens.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.comic_defaults_hint,
                style: NodeLaneTokens.of(context).readerSecondary,
              ),
              const SizedBox(height: NodeLaneTokens.space16),
              const ComicReaderSettingsContent(),
            ],
          ),
        ),
      ),
    ),
  );
}
