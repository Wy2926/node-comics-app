import 'package:isar_community/isar.dart';
part 'translation_entry.g.dart';

/// Device-only receipts and metadata. Deliberately excluded from Settings,
/// library sync and portable backups. Credentials belong in secure storage.
@collection
class TranslationEntry {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String key;
  @Index()
  late String scope;
  late String kind;
  late String payload;
  late int updatedAt;
}
