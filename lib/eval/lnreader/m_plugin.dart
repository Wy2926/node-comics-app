import 'package:mangayomi/utils/nodelane_brand.dart';

class ChapterItem {
  String name;
  String path;
  String? releaseTime;
  int? chapterNumber;
  String? page;
  String? scanlator;

  ChapterItem({
    required this.name,
    required this.path,
    this.releaseTime,
    this.chapterNumber,
    this.page,
    this.scanlator,
  });

  factory ChapterItem.fromJson(Map<String, dynamic> json) {
    return ChapterItem(
      name: json['name'],
      path: json['path'],
      releaseTime: json['releaseTime'],
      chapterNumber: json['chapterNumber'] != null
          ? (json['chapterNumber'] as num?)?.toInt() ??
                int.tryParse(json['chapterNumber'].toString())
          : null,
      page: json['page'],
      scanlator: json['scanlator'] is List
          ? (json['scanlator'] as List).join(', ')
          : json['scanlator']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'releaseTime': releaseTime,
      'chapterNumber': chapterNumber,
      'page': page,
      'scanlator': scanlator,
    };
  }
}

class NovelItem {
  String name;
  String path;
  String? cover;

  NovelItem({required this.name, required this.path, this.cover});

  factory NovelItem.fromJson(Map<String, dynamic> json) {
    return NovelItem(
      name: json['name'],
      path: json['path'],
      cover: json['cover'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'path': path, 'cover': cover};
  }
}

class SourceNovel extends NovelItem {
  String? genres;
  String? summary;
  String? author;
  String? artist;
  String? status;
  double? rating;
  List<ChapterItem>? chapters;
  int? totalPages;

  SourceNovel({
    required super.name,
    required super.path,
    super.cover,
    this.genres,
    this.summary,
    this.author,
    this.artist,
    this.status,
    this.rating,
    this.chapters,
    this.totalPages,
  });

  factory SourceNovel.fromJson(Map<String, dynamic> json) {
    if (json['path'] == null) {
      // Missing paths are source failures; direct readers to its maintainer.
      throw Exception(
        'The source returned a novel with no path, so '
        '${NodeLaneBrand.displayName} cannot open it. Contact the source maintainer'
        '${json['name'] is String ? ' (while reading "${json['name']}")' : ''}.',
      );
    }
    return SourceNovel(
      name: json['name'] ?? '',
      path: json['path'],
      cover: json['cover'],
      genres: json['genres'],
      summary: json['summary'],
      author: json['author'],
      artist: json['artist'],
      status: json['status'],
      rating: json['rating'] is double
          ? json['rating']
          : json['rating']?.toDouble(),
      chapters: (json['chapters'] as List<dynamic>?)
          ?.map((item) => ChapterItem.fromJson(item))
          .toList(),
      totalPages: json['totalPages'] is int
          ? json['totalPages'] as int
          : int.tryParse(json['totalPages']?.toString() ?? ''),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'cover': cover,
      'genres': genres,
      'summary': summary,
      'author': author,
      'artist': artist,
      'status': status,
      'rating': rating,
      'chapters': chapters?.map((item) => item.toJson()).toList(),
      'totalPages': totalPages,
    };
  }
}

class SourcePage {
  List<ChapterItem> chapters;

  SourcePage({required this.chapters});

  factory SourcePage.fromJson(Map<String, dynamic> json) {
    return SourcePage(
      chapters:
          (json['chapters'] as List<dynamic>?)
              ?.map((item) => ChapterItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'chapters': chapters.map((item) => item.toJson()).toList()};
  }
}
