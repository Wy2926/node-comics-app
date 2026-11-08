import 'dart:convert';

enum ComicReadingMode { paged, scroll }

enum ComicPageTurn { left, right, up }

enum ComicPageFit { contain, width, height }

enum ComicPageLayout { automatic, single, double }

enum ComicWidePage { intact, split, rotate }

enum ComicContentWidth { full, comfortable, narrow }

enum ComicCanvas { system, black, gray, paper }

T _enum<T extends Enum>(List<T> values, Object? name, T fallback) =>
    values.firstWhere((value) => value.name == name, orElse: () => fallback);

class ComicReaderDefaults {
  const ComicReaderDefaults({
    this.mode = ComicReadingMode.scroll,
    this.turn = ComicPageTurn.left,
    this.fit = ComicPageFit.contain,
    this.layout = ComicPageLayout.automatic,
  });
  final ComicReadingMode mode;
  final ComicPageTurn turn;
  final ComicPageFit fit;
  final ComicPageLayout layout;
  ComicReaderDefaults copyWith({
    ComicReadingMode? mode,
    ComicPageTurn? turn,
    ComicPageFit? fit,
    ComicPageLayout? layout,
  }) => ComicReaderDefaults(
    mode: mode ?? this.mode,
    turn: turn ?? this.turn,
    fit: fit ?? this.fit,
    layout: layout ?? this.layout,
  );
  factory ComicReaderDefaults.fromJson(Map<String, dynamic> json) =>
      ComicReaderDefaults(
        mode: _enum(
          ComicReadingMode.values,
          json['mode'],
          ComicReadingMode.scroll,
        ),
        turn: _enum(ComicPageTurn.values, json['turn'], ComicPageTurn.left),
        fit: _enum(ComicPageFit.values, json['fit'], ComicPageFit.contain),
        layout: _enum(
          ComicPageLayout.values,
          json['layout'],
          ComicPageLayout.automatic,
        ),
      );
  Map<String, dynamic> toJson() => {
    'mode': mode.name,
    'turn': turn.name,
    'fit': fit.name,
    'layout': layout.name,
  };
}

/// Only explicitly chosen book values are stored. Reading a book never freezes
/// the defaults; later default changes still reach untouched fields.
class ComicBookSettings {
  const ComicBookSettings({
    this.mode,
    this.turn,
    this.fit,
    this.layout,
    this.crop,
    this.widePage,
    this.singleCover,
    this.invert,
    this.brightness,
    this.contrast,
    this.width,
    this.gap,
  });
  final ComicReadingMode? mode;
  final ComicPageTurn? turn;
  final ComicPageFit? fit;
  final ComicPageLayout? layout;
  final bool? crop;
  final ComicWidePage? widePage;
  final bool? singleCover;
  final bool? invert;
  final double? brightness;
  final double? contrast;
  final ComicContentWidth? width;
  final bool? gap;
  ComicBookSettings copyWith({
    ComicReadingMode? mode,
    ComicPageTurn? turn,
    ComicPageFit? fit,
    ComicPageLayout? layout,
    bool? crop,
    ComicWidePage? widePage,
    bool? singleCover,
    bool? invert,
    double? brightness,
    double? contrast,
    ComicContentWidth? width,
    bool? gap,
  }) => ComicBookSettings(
    mode: mode ?? this.mode,
    turn: turn ?? this.turn,
    fit: fit ?? this.fit,
    layout: layout ?? this.layout,
    crop: crop ?? this.crop,
    widePage: widePage ?? this.widePage,
    singleCover: singleCover ?? this.singleCover,
    invert: invert ?? this.invert,
    brightness: brightness ?? this.brightness,
    contrast: contrast ?? this.contrast,
    width: width ?? this.width,
    gap: gap ?? this.gap,
  );
  ComicReadingProfile resolve(ComicReaderDefaults defaults) =>
      ComicReadingProfile(
        mode: mode ?? defaults.mode,
        turn: turn ?? defaults.turn,
        fit: fit ?? defaults.fit,
        layout: layout ?? defaults.layout,
        crop: crop ?? false,
        widePage: widePage ?? ComicWidePage.intact,
        singleCover: singleCover ?? true,
        invert: invert ?? false,
        brightness: (brightness ?? 0).clamp(-0.5, 0.5),
        contrast: (contrast ?? 1).clamp(0.5, 1.5),
        width: width ?? ComicContentWidth.full,
        gap: gap ?? false,
      );
  factory ComicBookSettings.fromJson(
    Map<String, dynamic> json,
  ) => ComicBookSettings(
    mode: json['mode'] == null
        ? null
        : _enum(ComicReadingMode.values, json['mode'], ComicReadingMode.scroll),
    turn: json['turn'] == null
        ? null
        : _enum(ComicPageTurn.values, json['turn'], ComicPageTurn.left),
    fit: json['fit'] == null
        ? null
        : _enum(ComicPageFit.values, json['fit'], ComicPageFit.contain),
    layout: json['layout'] == null
        ? null
        : _enum(
            ComicPageLayout.values,
            json['layout'],
            ComicPageLayout.automatic,
          ),
    crop: json['crop'] as bool?,
    widePage: json['widePage'] == null
        ? null
        : _enum(ComicWidePage.values, json['widePage'], ComicWidePage.intact),
    singleCover: json['singleCover'] as bool?,
    invert: json['invert'] as bool?,
    brightness: (json['brightness'] as num?)?.toDouble(),
    contrast: (json['contrast'] as num?)?.toDouble(),
    width: json['width'] == null
        ? null
        : _enum(
            ComicContentWidth.values,
            json['width'],
            ComicContentWidth.full,
          ),
    gap: json['gap'] as bool?,
  );
  Map<String, dynamic> toJson() => {
    if (mode != null) 'mode': mode!.name,
    if (turn != null) 'turn': turn!.name,
    if (fit != null) 'fit': fit!.name,
    if (layout != null) 'layout': layout!.name,
    if (crop != null) 'crop': crop,
    if (widePage != null) 'widePage': widePage!.name,
    if (singleCover != null) 'singleCover': singleCover,
    if (invert != null) 'invert': invert,
    if (brightness != null) 'brightness': brightness,
    if (contrast != null) 'contrast': contrast,
    if (width != null) 'width': width!.name,
    if (gap != null) 'gap': gap,
  };
}

class ComicReadingProfile {
  const ComicReadingProfile({
    required this.mode,
    required this.turn,
    required this.fit,
    required this.layout,
    required this.crop,
    required this.widePage,
    required this.singleCover,
    required this.invert,
    required this.brightness,
    required this.contrast,
    required this.width,
    required this.gap,
  });
  final ComicReadingMode mode;
  final ComicPageTurn turn;
  final ComicPageFit fit;
  final ComicPageLayout layout;
  final bool crop;
  final ComicWidePage widePage;
  final bool singleCover;
  final bool invert;
  final double brightness;
  final double contrast;
  final ComicContentWidth width;
  final bool gap;

  /// Only geometry requires preserving a viewport anchor. Hidden options do
  /// not relayout the current mode; colors and session controls never do.
  Object geometryKey(double availableWidth) => (
    mode,
    mode == ComicReadingMode.paged ? turn : null,
    mode == ComicReadingMode.paged ? fit : null,
    doublePage(availableWidth),
    crop,
    mode == ComicReadingMode.paged && !doublePage(availableWidth)
        ? widePage
        : null,
    doublePage(availableWidth) ? singleCover : null,
    mode == ComicReadingMode.scroll ? width : null,
    mode == ComicReadingMode.scroll ? gap : null,
  );

  /// Apply image effects immediately while a geometry update waits for a drag
  /// or an earlier anchor restoration to finish.
  ComicReadingProfile withEffects(ComicReadingProfile latest) =>
      ComicReadingProfile(
        mode: mode,
        turn: turn,
        fit: fit,
        layout: layout,
        crop: crop,
        widePage: widePage,
        singleCover: singleCover,
        width: width,
        gap: gap,
        invert: latest.invert,
        brightness: latest.brightness,
        contrast: latest.contrast,
      );
  bool doublePage(double availableWidth) =>
      mode == ComicReadingMode.paged &&
      turn != ComicPageTurn.up &&
      (layout == ComicPageLayout.double ||
          (layout == ComicPageLayout.automatic && availableWidth >= 648));
  double get widthFactor => switch (width) {
    ComicContentWidth.full => 1,
    ComicContentWidth.comfortable => .92,
    ComicContentWidth.narrow => .84,
  };
  bool splitPages(double availableWidth) =>
      mode == ComicReadingMode.paged &&
      !doublePage(availableWidth) &&
      widePage == ComicWidePage.split;
}

class ComicReaderHabits {
  const ComicReaderHabits({
    this.canvas = ComicCanvas.system,
    this.pageNumber = true,
    this.keepAwake = true,
    this.tapToTurn = true,
  });
  final ComicCanvas canvas;
  final bool pageNumber;
  final bool keepAwake;
  final bool tapToTurn;
  ComicReaderHabits copyWith({
    ComicCanvas? canvas,
    bool? pageNumber,
    bool? keepAwake,
    bool? tapToTurn,
  }) => ComicReaderHabits(
    canvas: canvas ?? this.canvas,
    pageNumber: pageNumber ?? this.pageNumber,
    keepAwake: keepAwake ?? this.keepAwake,
    tapToTurn: tapToTurn ?? this.tapToTurn,
  );
  factory ComicReaderHabits.fromJson(Map<String, dynamic> json) =>
      ComicReaderHabits(
        canvas: _enum(ComicCanvas.values, json['canvas'], ComicCanvas.system),
        pageNumber: json['pageNumber'] as bool? ?? true,
        keepAwake: json['keepAwake'] as bool? ?? true,
        tapToTurn: json['tapToTurn'] as bool? ?? true,
      );
  Map<String, dynamic> toJson() => {
    'canvas': canvas.name,
    'pageNumber': pageNumber,
    'keepAwake': keepAwake,
    'tapToTurn': tapToTurn,
  };
}

class ComicReaderPreferences {
  const ComicReaderPreferences({
    this.defaults = const ComicReaderDefaults(),
    this.habits = const ComicReaderHabits(),
    this.books = const {},
    this.scrollSpeed = 40,
  });
  final ComicReaderDefaults defaults;
  final ComicReaderHabits habits;
  final Map<String, ComicBookSettings> books;
  final double scrollSpeed;
  ComicBookSettings book(int id) => books['$id'] ?? const ComicBookSettings();
  ComicReadingProfile resolve(int id) => book(id).resolve(defaults);
  ComicReaderPreferences copyWith({
    ComicReaderDefaults? defaults,
    ComicReaderHabits? habits,
    Map<String, ComicBookSettings>? books,
    double? scrollSpeed,
  }) => ComicReaderPreferences(
    defaults: defaults ?? this.defaults,
    habits: habits ?? this.habits,
    books: Map.unmodifiable(books ?? this.books),
    scrollSpeed: scrollSpeed ?? this.scrollSpeed,
  );
  ComicReaderPreferences updateBook(
    int id,
    ComicBookSettings Function(ComicBookSettings) update,
  ) => copyWith(books: {...books, '$id': update(book(id))});
  ComicReaderPreferences resetBook(int id) =>
      copyWith(books: {...books}..remove('$id'));
  factory ComicReaderPreferences.decode(String? value) {
    if (value == null || value.isEmpty) return const ComicReaderPreferences();
    final json = jsonDecode(value) as Map<String, dynamic>;
    return ComicReaderPreferences(
      defaults: ComicReaderDefaults.fromJson(
        json['defaults'] as Map<String, dynamic>,
      ),
      habits: ComicReaderHabits.fromJson(
        json['habits'] as Map<String, dynamic>,
      ),
      books: Map.unmodifiable(
        (json['books'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            ComicBookSettings.fromJson(value as Map<String, dynamic>),
          ),
        ),
      ),
      scrollSpeed: (json['scrollSpeed'] as num).toDouble().clamp(10, 100),
    );
  }
  String encode() => jsonEncode({
    'defaults': defaults.toJson(),
    'habits': habits.toJson(),
    'books': books.map((key, value) => MapEntry(key, value.toJson())),
    'scrollSpeed': scrollSpeed,
  });
}
