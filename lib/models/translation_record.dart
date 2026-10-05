import 'package:isar_community/isar.dart';

part 'translation_record.g.dart';

/// Local only: excluded from library backup and upstream sync.
@collection
class TranslationRecord {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String uuid;
  @Index()
  late String scope;
  @Index()
  late String pageKey;
  late String locatorSignature;
  late String language;
  late String sourceSha;
  late String inputSha;
  late String inputPath;
  late String inputMime;
  late int inputBytes;
  late int width;
  late int height;
  late int sourceWidth;
  late int sourceHeight;
  late String descriptorJson;
  String resultFormat = 'overlay-v1';
  String remoteState = 'unsubmitted';
  String? snapshotJson;
  @Index()
  String phase = 'prepared';
  String? errorCode;
  String? resultPath;
  String? resultSha;
  int resultBytes = 0;
  bool original = false;
  bool published = false;
  bool cancelIntent = false;
  int deliveryRevision = 0;
  int createdAt = 0;
  int accessedAt = 0;
}
