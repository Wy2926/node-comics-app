import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';

// Numeric keys support season grouping and cross-release progress matching.
// Catalog imports use full URLs; their persistence tests live with the importer.
void main() {
  final recognition = ChapterRecognition();

  String? identity(String show, String name, [String? scanlator]) =>
      recognition.chapterIdentityKey(show, name, scanlator);

  group('a season is part of a chapter identity', () {
    test('the same episode number in two seasons is two chapters', () {
      expect(
        identity('Clevatess', 'Staffel 1 Folge 1'),
        isNot(identity('Clevatess', 'Staffel 2 Folge 1')),
      );
    });

    test('a shorter second season survives the first', () {
      final keys = <String?>{
        for (var e = 1; e <= 12; e++)
          identity('Clevatess', 'Staffel 1 Folge $e'),
        for (var e = 1; e <= 8; e++)
          identity('Clevatess', 'Staffel 2 Folge $e'),
      };
      expect(keys, hasLength(20));
    });

    test('two full seasons of the same length both survive', () {
      final keys = <String?>{
        for (var e = 1; e <= 25; e++)
          identity('Code Geass', 'Season 1 Episode $e'),
        for (var e = 1; e <= 25; e++)
          identity('Code Geass', 'Season 2 Episode $e'),
      };
      expect(keys, hasLength(50));
    });
  });

  group('Spanish season and episode names', () {
    (int, double?) parsed(String name) =>
        recognition.rawSeasonAndNumber('Loki', name);

    test('"T" is a season and "Episodio" an episode', () {
      expect(parsed('T1 - Episodio 3'), (1, 3.0));
      expect(parsed('T2 - Episodio 6'), (2, 6.0));
    });

    test('two seasons of Loki keep all their episodes', () {
      final keys = <String?>{
        for (var e = 1; e <= 6; e++) identity('Loki', 'T1 - Episodio $e'),
        for (var e = 1; e <= 6; e++) identity('Loki', 'T2 - Episodio $e'),
      };
      expect(keys, hasLength(12));
    });

    test('words merely containing a "t" are not seasons', () {
      expect(parsed('Part 2'), (0, 2.0));
      expect(parsed('Chapter 12'), (0, 12.0));
    });
  });

  group('what the key refuses to answer', () {
    test('a name with no number is not an identity', () {
      expect(identity('Code Geass', 'Special'), isNull);
      expect(identity('Code Geass', 'Prologue'), isNull);
      expect(
        recognition.rawSeasonAndNumber('Code Geass', 'Special').$2,
        isNull,
      );
      expect(
        recognition.rawSeasonAndNumber('Code Geass', 'Prologue').$2,
        isNull,
      );
      expect(recognition.rawSeasonAndNumber('Code Geass', 'Chapter 0').$2, 0);
    });

    test('fractional numbers stay distinct despite sharing a sort bucket', () {
      final names = ['Chapter 12', 'Chapter 12.1', 'Chapter 12.5'];
      expect(
        names.map((name) => recognition.parseChapterNumber('One Piece', name)),
        [12, 12, 12],
      );
      expect(
        names.map(
          (name) => recognition.rawSeasonAndNumber('One Piece', name).$2,
        ),
        [12, 12.1, 12.5],
      );
      expect(
        names.map((name) => identity('One Piece', name)).toSet(),
        hasLength(3),
      );
    });

    test('the scanlator separates releases, and is optional', () {
      expect(
        identity('One Piece', 'Chapter 12', 'A'),
        isNot(identity('One Piece', 'Chapter 12', 'B')),
      );
      expect(
        identity('One Piece', 'Chapter 12'),
        identity('One Piece', 'Chapter 12', ''),
      );
    });
  });
}
