import 'package:mangayomi/l10n/generated/app_localizations.dart';

/// Display labels only. Never translate a plugin's keys, values or user input.
/// Whole-label matches keep site-specific names and explanations intact.
String sourceFilterLabel(AppLocalizations l10n, String original) {
  final label = original
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[\s_-]+'), ' ')
      .replaceFirst(RegExp(r'[:：]$'), '')
      .trim();
  final common = switch (label) {
    'sort' || 'sort by' || 'order by' || '排序' => l10n.sort,
    'status' || 'publication status' || '状态' => l10n.status,
    'type' || '类型' => l10n.type,
    'language' || 'languages' || '语言' => l10n.language,
    'default' || '默认' => l10n.default0,
    'any' || '不限' => l10n.bookshelf_filter_any,
    'include' || '包含' => l10n.bookshelf_filter_include,
    'exclude' || '排除' => l10n.bookshelf_filter_exclude,
    'ascending' || 'asc' || '升序' => l10n.bookshelf_sort_ascending,
    'descending' || 'desc' || '降序' => l10n.bookshelf_sort_descending,
    'completed' || 'complete' || '已完结' => l10n.completed,
    'ongoing' || '连载中' => l10n.ongoing,
    'hiatus' || 'on hiatus' || '暂停' => l10n.on_hiatus,
    'on hold' || '搁置' => l10n.on_hold,
    'canceled' || 'cancelled' || '已取消' => l10n.canceled,
    'unknown' || '未知' => l10n.unknown,
    'popular' || 'popularity' || 'most popular' || '热门' => l10n.popular,
    'latest' || 'latest updates' || 'last updated' || '最新' => l10n.latest,
    'alphabetical' || 'alphabetically' || 'a z' => l10n.alphabetically,
    _ => null,
  };
  if (common != null) return common;
  final term = switch (label) {
    'genre' || 'genres' || '题材' => 'genres',
    'author' || 'authors' || '作者' => 'author',
    'artist' || 'artists' || '画师' => 'artist',
    'title' || '标题' => 'title',
    'year' ||
    'release year' ||
    'year of release' ||
    'year of released' ||
    '年份' => 'year',
    'tag' || 'tags' || '标签' => 'tags',
    'format' || '形式' => 'format',
    'publisher' || '出版社' => 'publisher',
    'relevance' || '相关度' => 'relevance',
    'rating' || 'ratings' || '评分' => 'rating',
    'views' || 'most views' || 'most viewed' || '浏览量' => 'views',
    'trending' || '热门趋势' => 'trending',
    'new' || 'newest' || 'newly added' || '新上架' => 'new',
    'adult content' || '成人内容' => 'adult_content',
    'only' || '仅显示' => 'only',
    'random' || '随机' => 'random',
    'all' || '全部' => 'all',
    'none' || '无' => 'none',
    'sci fi' || 'science fiction' => 'science_fiction',
    'slice of life' => 'slice_of_life',
    'school life' => 'school_life',
    'martial arts' => 'martial_arts',
    'shonen' => 'shounen',
    'shojo' => 'shoujo',
    _ => label,
  };
  return _terms.contains(term) ? l10n.source_filter_term(term) : original;
}

const _terms = {
  'genres',
  'author',
  'artist',
  'title',
  'year',
  'tags',
  'format',
  'publisher',
  'relevance',
  'rating',
  'views',
  'trending',
  'new',
  'adult_content',
  'only',
  'random',
  'all',
  'none',
  'action',
  'adventure',
  'comedy',
  'drama',
  'fantasy',
  'romance',
  'science_fiction',
  'slice_of_life',
  'mystery',
  'horror',
  'psychological',
  'historical',
  'sports',
  'supernatural',
  'school_life',
  'tragedy',
  'shounen',
  'shoujo',
  'seinen',
  'josei',
  'isekai',
  'martial_arts',
  'mecha',
  'music',
  'doujinshi',
};
