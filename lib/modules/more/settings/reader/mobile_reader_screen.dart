import 'package:flutter/material.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_settings.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class MobileReaderScreen extends StatelessWidget {
  const MobileReaderScreen({super.key});
  @override
  Widget build(BuildContext context) => MobileBrowsePage(
    title: context.l10n.settings_manga_reader,
    body: const MobileSettingsList(
      key: PageStorageKey('mobile-comic-reader-settings'),
      children: [ComicReaderSettingsContent()],
    ),
  );
}
