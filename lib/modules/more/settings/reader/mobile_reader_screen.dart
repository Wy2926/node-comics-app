import 'package:flutter/material.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_settings_sheet.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class MobileReaderScreen extends StatelessWidget {
  const MobileReaderScreen({super.key});
  @override
  Widget build(BuildContext context) => NodeLaneSurface(
    child: Scaffold(
      appBar: nodeLaneAppBar(
        context,
        title: context.l10n.settings_manga_reader,
      ),
      body: const SafeArea(
        top: false,
        child: MobileSettingsList(
          key: PageStorageKey('mobile-comic-reader-settings'),
          padding: NodeLaneTokens.pagePadding,
          children: [ComicReaderSettingsContent()],
        ),
      ),
    ),
  );
}
