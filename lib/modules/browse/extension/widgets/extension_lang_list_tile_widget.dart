import 'package:flutter/material.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';

class ExtensionLangListTileWidget extends StatelessWidget {
  final String lang;
  final bool value;
  final Function(bool) onChanged;
  const ExtensionLangListTileWidget({
    super.key,
    required this.lang,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile && !isTv) {
      return MobileBrowseGroup(
        child: SwitchListTile.adaptive(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          title: Text(completeLanguageName(lang.toLowerCase())),
          value: value,
          onChanged: onChanged,
        ),
      );
    }
    return ListTile(
      onTap: () {
        onChanged(!value);
      },
      title: Text(completeLanguageName(lang.toLowerCase())),
      trailing: Switch(
        value: value,
        onChanged: (value) {
          onChanged(value);
        },
      ),
    );
  }
}
