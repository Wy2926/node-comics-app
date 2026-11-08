import 'dart:ui';

import 'package:mangayomi/l10n/languages.dart';

/// NodeLane's product target languages, shared by every language picker.
const translationLanguageNames = nodeLaneLanguageNames;

String translationLanguageForLocales(Iterable<Locale> locales) =>
    nodeLaneLanguageForLocales(locales);
