// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: experimental_member_use

part of 'translation_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTranslationRecordCollection on Isar {
  IsarCollection<TranslationRecord> get translationRecords => this.collection();
}

const TranslationRecordSchema = CollectionSchema(
  name: r'TranslationRecord',
  id: -641002333582827518,
  properties: {
    r'accessedAt': PropertySchema(
      id: 0,
      name: r'accessedAt',
      type: IsarType.long,
    ),
    r'cancelIntent': PropertySchema(
      id: 1,
      name: r'cancelIntent',
      type: IsarType.bool,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.long,
    ),
    r'deliveryRevision': PropertySchema(
      id: 3,
      name: r'deliveryRevision',
      type: IsarType.long,
    ),
    r'descriptorJson': PropertySchema(
      id: 4,
      name: r'descriptorJson',
      type: IsarType.string,
    ),
    r'errorCode': PropertySchema(
      id: 5,
      name: r'errorCode',
      type: IsarType.string,
    ),
    r'height': PropertySchema(id: 6, name: r'height', type: IsarType.long),
    r'inputBytes': PropertySchema(
      id: 7,
      name: r'inputBytes',
      type: IsarType.long,
    ),
    r'inputMime': PropertySchema(
      id: 8,
      name: r'inputMime',
      type: IsarType.string,
    ),
    r'inputPath': PropertySchema(
      id: 9,
      name: r'inputPath',
      type: IsarType.string,
    ),
    r'inputSha': PropertySchema(
      id: 10,
      name: r'inputSha',
      type: IsarType.string,
    ),
    r'language': PropertySchema(
      id: 11,
      name: r'language',
      type: IsarType.string,
    ),
    r'locatorSignature': PropertySchema(
      id: 12,
      name: r'locatorSignature',
      type: IsarType.string,
    ),
    r'original': PropertySchema(id: 13, name: r'original', type: IsarType.bool),
    r'pageKey': PropertySchema(id: 14, name: r'pageKey', type: IsarType.string),
    r'phase': PropertySchema(id: 15, name: r'phase', type: IsarType.string),
    r'published': PropertySchema(
      id: 16,
      name: r'published',
      type: IsarType.bool,
    ),
    r'remoteState': PropertySchema(
      id: 17,
      name: r'remoteState',
      type: IsarType.string,
    ),
    r'resultBytes': PropertySchema(
      id: 18,
      name: r'resultBytes',
      type: IsarType.long,
    ),
    r'resultFormat': PropertySchema(
      id: 19,
      name: r'resultFormat',
      type: IsarType.string,
    ),
    r'resultPath': PropertySchema(
      id: 20,
      name: r'resultPath',
      type: IsarType.string,
    ),
    r'resultSha': PropertySchema(
      id: 21,
      name: r'resultSha',
      type: IsarType.string,
    ),
    r'scope': PropertySchema(id: 22, name: r'scope', type: IsarType.string),
    r'snapshotJson': PropertySchema(
      id: 23,
      name: r'snapshotJson',
      type: IsarType.string,
    ),
    r'sourceHeight': PropertySchema(
      id: 24,
      name: r'sourceHeight',
      type: IsarType.long,
    ),
    r'sourceSha': PropertySchema(
      id: 25,
      name: r'sourceSha',
      type: IsarType.string,
    ),
    r'sourceWidth': PropertySchema(
      id: 26,
      name: r'sourceWidth',
      type: IsarType.long,
    ),
    r'uuid': PropertySchema(id: 27, name: r'uuid', type: IsarType.string),
    r'width': PropertySchema(id: 28, name: r'width', type: IsarType.long),
  },

  estimateSize: _translationRecordEstimateSize,
  serialize: _translationRecordSerialize,
  deserialize: _translationRecordDeserialize,
  deserializeProp: _translationRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'scope': IndexSchema(
      id: 152078781581678656,
      name: r'scope',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'scope',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'pageKey': IndexSchema(
      id: -4704772844707937300,
      name: r'pageKey',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'pageKey',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'phase': IndexSchema(
      id: -467877781735009358,
      name: r'phase',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'phase',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _translationRecordGetId,
  getLinks: _translationRecordGetLinks,
  attach: _translationRecordAttach,
  version: '3.3.2',
);

int _translationRecordEstimateSize(
  TranslationRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.descriptorJson.length * 3;
  {
    final value = object.errorCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.inputMime.length * 3;
  bytesCount += 3 + object.inputPath.length * 3;
  bytesCount += 3 + object.inputSha.length * 3;
  bytesCount += 3 + object.language.length * 3;
  bytesCount += 3 + object.locatorSignature.length * 3;
  bytesCount += 3 + object.pageKey.length * 3;
  bytesCount += 3 + object.phase.length * 3;
  bytesCount += 3 + object.remoteState.length * 3;
  bytesCount += 3 + object.resultFormat.length * 3;
  {
    final value = object.resultPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.resultSha;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.scope.length * 3;
  {
    final value = object.snapshotJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sourceSha.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _translationRecordSerialize(
  TranslationRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.accessedAt);
  writer.writeBool(offsets[1], object.cancelIntent);
  writer.writeLong(offsets[2], object.createdAt);
  writer.writeLong(offsets[3], object.deliveryRevision);
  writer.writeString(offsets[4], object.descriptorJson);
  writer.writeString(offsets[5], object.errorCode);
  writer.writeLong(offsets[6], object.height);
  writer.writeLong(offsets[7], object.inputBytes);
  writer.writeString(offsets[8], object.inputMime);
  writer.writeString(offsets[9], object.inputPath);
  writer.writeString(offsets[10], object.inputSha);
  writer.writeString(offsets[11], object.language);
  writer.writeString(offsets[12], object.locatorSignature);
  writer.writeBool(offsets[13], object.original);
  writer.writeString(offsets[14], object.pageKey);
  writer.writeString(offsets[15], object.phase);
  writer.writeBool(offsets[16], object.published);
  writer.writeString(offsets[17], object.remoteState);
  writer.writeLong(offsets[18], object.resultBytes);
  writer.writeString(offsets[19], object.resultFormat);
  writer.writeString(offsets[20], object.resultPath);
  writer.writeString(offsets[21], object.resultSha);
  writer.writeString(offsets[22], object.scope);
  writer.writeString(offsets[23], object.snapshotJson);
  writer.writeLong(offsets[24], object.sourceHeight);
  writer.writeString(offsets[25], object.sourceSha);
  writer.writeLong(offsets[26], object.sourceWidth);
  writer.writeString(offsets[27], object.uuid);
  writer.writeLong(offsets[28], object.width);
}

TranslationRecord _translationRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TranslationRecord();
  object.accessedAt = reader.readLong(offsets[0]);
  object.cancelIntent = reader.readBool(offsets[1]);
  object.createdAt = reader.readLong(offsets[2]);
  object.deliveryRevision = reader.readLong(offsets[3]);
  object.descriptorJson = reader.readString(offsets[4]);
  object.errorCode = reader.readStringOrNull(offsets[5]);
  object.height = reader.readLong(offsets[6]);
  object.id = id;
  object.inputBytes = reader.readLong(offsets[7]);
  object.inputMime = reader.readString(offsets[8]);
  object.inputPath = reader.readString(offsets[9]);
  object.inputSha = reader.readString(offsets[10]);
  object.language = reader.readString(offsets[11]);
  object.locatorSignature = reader.readString(offsets[12]);
  object.original = reader.readBool(offsets[13]);
  object.pageKey = reader.readString(offsets[14]);
  object.phase = reader.readString(offsets[15]);
  object.published = reader.readBool(offsets[16]);
  object.remoteState = reader.readString(offsets[17]);
  object.resultBytes = reader.readLong(offsets[18]);
  object.resultFormat = reader.readString(offsets[19]);
  object.resultPath = reader.readStringOrNull(offsets[20]);
  object.resultSha = reader.readStringOrNull(offsets[21]);
  object.scope = reader.readString(offsets[22]);
  object.snapshotJson = reader.readStringOrNull(offsets[23]);
  object.sourceHeight = reader.readLong(offsets[24]);
  object.sourceSha = reader.readString(offsets[25]);
  object.sourceWidth = reader.readLong(offsets[26]);
  object.uuid = reader.readString(offsets[27]);
  object.width = reader.readLong(offsets[28]);
  return object;
}

P _translationRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readLong(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readString(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readLong(offset)) as P;
    case 25:
      return (reader.readString(offset)) as P;
    case 26:
      return (reader.readLong(offset)) as P;
    case 27:
      return (reader.readString(offset)) as P;
    case 28:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _translationRecordGetId(TranslationRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _translationRecordGetLinks(
  TranslationRecord object,
) {
  return [];
}

void _translationRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  TranslationRecord object,
) {
  object.id = id;
}

extension TranslationRecordByIndex on IsarCollection<TranslationRecord> {
  Future<TranslationRecord?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  TranslationRecord? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<TranslationRecord?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<TranslationRecord?> getAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uuid', values);
  }

  Future<int> deleteAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uuid', values);
  }

  int deleteAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uuid', values);
  }

  Future<Id> putByUuid(TranslationRecord object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(TranslationRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<TranslationRecord> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(
    List<TranslationRecord> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension TranslationRecordQueryWhereSort
    on QueryBuilder<TranslationRecord, TranslationRecord, QWhere> {
  QueryBuilder<TranslationRecord, TranslationRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TranslationRecordQueryWhere
    on QueryBuilder<TranslationRecord, TranslationRecord, QWhereClause> {
  QueryBuilder<TranslationRecord, TranslationRecord, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterWhereClause>
  uuidEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'uuid', value: [uuid]),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterWhereClause>
  uuidNotEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [],
                upper: [uuid],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [uuid],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [uuid],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [],
                upper: [uuid],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterWhereClause>
  scopeEqualTo(String scope) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'scope', value: [scope]),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterWhereClause>
  scopeNotEqualTo(String scope) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scope',
                lower: [],
                upper: [scope],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scope',
                lower: [scope],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scope',
                lower: [scope],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'scope',
                lower: [],
                upper: [scope],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterWhereClause>
  pageKeyEqualTo(String pageKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'pageKey', value: [pageKey]),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterWhereClause>
  pageKeyNotEqualTo(String pageKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'pageKey',
                lower: [],
                upper: [pageKey],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'pageKey',
                lower: [pageKey],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'pageKey',
                lower: [pageKey],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'pageKey',
                lower: [],
                upper: [pageKey],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterWhereClause>
  phaseEqualTo(String phase) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'phase', value: [phase]),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterWhereClause>
  phaseNotEqualTo(String phase) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'phase',
                lower: [],
                upper: [phase],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'phase',
                lower: [phase],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'phase',
                lower: [phase],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'phase',
                lower: [],
                upper: [phase],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension TranslationRecordQueryFilter
    on QueryBuilder<TranslationRecord, TranslationRecord, QFilterCondition> {
  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  accessedAtEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accessedAt', value: value),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  accessedAtGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accessedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  accessedAtLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accessedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  accessedAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accessedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  cancelIntentEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cancelIntent', value: value),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  createdAtEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  createdAtGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  createdAtLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  createdAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  deliveryRevisionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deliveryRevision', value: value),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  deliveryRevisionGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'deliveryRevision',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  deliveryRevisionLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'deliveryRevision',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  deliveryRevisionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'deliveryRevision',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  descriptorJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'descriptorJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  descriptorJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'descriptorJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  descriptorJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'descriptorJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  descriptorJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'descriptorJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  descriptorJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'descriptorJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  descriptorJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'descriptorJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  descriptorJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'descriptorJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  descriptorJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'descriptorJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  descriptorJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'descriptorJson', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  descriptorJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'descriptorJson', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  errorCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'errorCode'),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  errorCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'errorCode'),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  errorCodeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'errorCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  errorCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'errorCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  errorCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'errorCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  errorCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'errorCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  errorCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'errorCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  errorCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'errorCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  errorCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'errorCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  errorCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'errorCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  errorCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'errorCode', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  errorCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'errorCode', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  heightEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'height', value: value),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  heightGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'height',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  heightLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'height',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  heightBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'height',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputBytesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'inputBytes', value: value),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputBytesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'inputBytes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputBytesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'inputBytes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'inputBytes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputMimeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'inputMime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputMimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'inputMime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputMimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'inputMime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputMimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'inputMime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputMimeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'inputMime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputMimeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'inputMime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputMimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'inputMime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputMimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'inputMime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputMimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'inputMime', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputMimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'inputMime', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputPathEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'inputPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'inputPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'inputPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'inputPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'inputPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'inputPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'inputPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'inputPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'inputPath', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'inputPath', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputShaEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'inputSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputShaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'inputSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputShaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'inputSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputShaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'inputSha',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputShaStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'inputSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputShaEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'inputSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputShaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'inputSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputShaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'inputSha',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputShaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'inputSha', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  inputShaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'inputSha', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  languageEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'language',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  languageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'language',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  languageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'language',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  languageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'language',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  languageStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'language',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  languageEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'language',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  languageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'language',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  languageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'language',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  languageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'language', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  languageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'language', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  locatorSignatureEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'locatorSignature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  locatorSignatureGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'locatorSignature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  locatorSignatureLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'locatorSignature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  locatorSignatureBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'locatorSignature',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  locatorSignatureStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'locatorSignature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  locatorSignatureEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'locatorSignature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  locatorSignatureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'locatorSignature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  locatorSignatureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'locatorSignature',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  locatorSignatureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'locatorSignature', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  locatorSignatureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'locatorSignature', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  originalEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'original', value: value),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  pageKeyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'pageKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  pageKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pageKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  pageKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pageKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  pageKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pageKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  pageKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'pageKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  pageKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'pageKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  pageKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'pageKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  pageKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'pageKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  pageKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pageKey', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  pageKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'pageKey', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  phaseEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'phase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  phaseGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'phase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  phaseLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'phase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  phaseBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'phase',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  phaseStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'phase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  phaseEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'phase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  phaseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'phase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  phaseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'phase',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  phaseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phase', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  phaseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'phase', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  publishedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'published', value: value),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  remoteStateEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'remoteState',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  remoteStateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'remoteState',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  remoteStateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'remoteState',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  remoteStateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'remoteState',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  remoteStateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'remoteState',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  remoteStateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'remoteState',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  remoteStateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'remoteState',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  remoteStateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'remoteState',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  remoteStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'remoteState', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  remoteStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'remoteState', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultBytesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'resultBytes', value: value),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultBytesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'resultBytes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultBytesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'resultBytes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'resultBytes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultFormatEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'resultFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultFormatGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'resultFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultFormatLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'resultFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultFormatBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'resultFormat',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultFormatStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'resultFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultFormatEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'resultFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultFormatContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'resultFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultFormatMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'resultFormat',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultFormatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'resultFormat', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultFormatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'resultFormat', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'resultPath'),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'resultPath'),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'resultPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'resultPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'resultPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'resultPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'resultPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'resultPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'resultPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'resultPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'resultPath', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'resultPath', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultShaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'resultSha'),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultShaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'resultSha'),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultShaEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'resultSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultShaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'resultSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultShaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'resultSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultShaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'resultSha',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultShaStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'resultSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultShaEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'resultSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultShaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'resultSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultShaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'resultSha',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultShaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'resultSha', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  resultShaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'resultSha', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  scopeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'scope',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  scopeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'scope',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  scopeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'scope',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  scopeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'scope',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  scopeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'scope',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  scopeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'scope',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  scopeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'scope',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  scopeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'scope',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  scopeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scope', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  scopeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'scope', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  snapshotJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'snapshotJson'),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  snapshotJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'snapshotJson'),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  snapshotJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'snapshotJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  snapshotJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'snapshotJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  snapshotJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'snapshotJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  snapshotJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'snapshotJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  snapshotJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'snapshotJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  snapshotJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'snapshotJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  snapshotJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'snapshotJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  snapshotJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'snapshotJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  snapshotJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'snapshotJson', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  snapshotJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'snapshotJson', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceHeightEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceHeight', value: value),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceHeightGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceHeight',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceHeightLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceHeight',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceHeightBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceHeight',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceShaEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sourceSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceShaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceShaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceShaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceSha',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceShaStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sourceSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceShaEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sourceSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceShaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sourceSha',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceShaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sourceSha',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceShaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceSha', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceShaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sourceSha', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceWidthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceWidth', value: value),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceWidthGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceWidth',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceWidthLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceWidth',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  sourceWidthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceWidth',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  uuidEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'uuid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  uuidStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  uuidEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  uuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'uuid',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  widthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'width', value: value),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  widthGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'width',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  widthLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'width',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterFilterCondition>
  widthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'width',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TranslationRecordQueryObject
    on QueryBuilder<TranslationRecord, TranslationRecord, QFilterCondition> {}

extension TranslationRecordQueryLinks
    on QueryBuilder<TranslationRecord, TranslationRecord, QFilterCondition> {}

extension TranslationRecordQuerySortBy
    on QueryBuilder<TranslationRecord, TranslationRecord, QSortBy> {
  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByAccessedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessedAt', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByAccessedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessedAt', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByCancelIntent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelIntent', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByCancelIntentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelIntent', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByDeliveryRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryRevision', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByDeliveryRevisionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryRevision', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByDescriptorJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptorJson', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByDescriptorJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptorJson', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByErrorCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorCode', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByErrorCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorCode', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByInputBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputBytes', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByInputBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputBytes', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByInputMime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMime', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByInputMimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMime', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByInputPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputPath', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByInputPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputPath', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByInputSha() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputSha', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByInputShaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputSha', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'language', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'language', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByLocatorSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locatorSignature', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByLocatorSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locatorSignature', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByOriginal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'original', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByOriginalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'original', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByPageKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageKey', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByPageKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageKey', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByPhaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByPublished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'published', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByPublishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'published', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByRemoteState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteState', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByRemoteStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteState', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByResultBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultBytes', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByResultBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultBytes', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByResultFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultFormat', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByResultFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultFormat', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByResultPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultPath', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByResultPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultPath', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByResultSha() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultSha', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByResultShaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultSha', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByScope() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scope', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByScopeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scope', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortBySnapshotJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotJson', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortBySnapshotJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotJson', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortBySourceHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceHeight', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortBySourceHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceHeight', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortBySourceSha() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceSha', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortBySourceShaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceSha', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortBySourceWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWidth', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortBySourceWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWidth', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  sortByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension TranslationRecordQuerySortThenBy
    on QueryBuilder<TranslationRecord, TranslationRecord, QSortThenBy> {
  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByAccessedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessedAt', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByAccessedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessedAt', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByCancelIntent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelIntent', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByCancelIntentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelIntent', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByDeliveryRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryRevision', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByDeliveryRevisionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryRevision', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByDescriptorJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptorJson', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByDescriptorJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptorJson', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByErrorCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorCode', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByErrorCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorCode', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByInputBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputBytes', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByInputBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputBytes', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByInputMime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMime', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByInputMimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMime', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByInputPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputPath', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByInputPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputPath', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByInputSha() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputSha', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByInputShaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputSha', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'language', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'language', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByLocatorSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locatorSignature', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByLocatorSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locatorSignature', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByOriginal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'original', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByOriginalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'original', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByPageKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageKey', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByPageKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageKey', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByPhaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByPublished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'published', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByPublishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'published', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByRemoteState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteState', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByRemoteStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteState', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByResultBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultBytes', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByResultBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultBytes', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByResultFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultFormat', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByResultFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultFormat', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByResultPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultPath', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByResultPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultPath', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByResultSha() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultSha', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByResultShaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultSha', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByScope() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scope', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByScopeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scope', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenBySnapshotJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotJson', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenBySnapshotJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotJson', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenBySourceHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceHeight', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenBySourceHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceHeight', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenBySourceSha() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceSha', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenBySourceShaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceSha', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenBySourceWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWidth', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenBySourceWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWidth', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QAfterSortBy>
  thenByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension TranslationRecordQueryWhereDistinct
    on QueryBuilder<TranslationRecord, TranslationRecord, QDistinct> {
  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByAccessedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accessedAt');
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByCancelIntent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cancelIntent');
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByDeliveryRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deliveryRevision');
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByDescriptorJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'descriptorJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByErrorCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'errorCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'height');
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByInputBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inputBytes');
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByInputMime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inputMime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByInputPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inputPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByInputSha({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inputSha', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByLanguage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'language', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByLocatorSignature({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'locatorSignature',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByOriginal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'original');
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByPageKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pageKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByPhase({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phase', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByPublished() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'published');
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByRemoteState({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteState', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByResultBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resultBytes');
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByResultFormat({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resultFormat', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByResultPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resultPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByResultSha({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resultSha', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByScope({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scope', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctBySnapshotJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snapshotJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctBySourceHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceHeight');
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctBySourceSha({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceSha', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctBySourceWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceWidth');
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct> distinctByUuid({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationRecord, TranslationRecord, QDistinct>
  distinctByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'width');
    });
  }
}

extension TranslationRecordQueryProperty
    on QueryBuilder<TranslationRecord, TranslationRecord, QQueryProperty> {
  QueryBuilder<TranslationRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TranslationRecord, int, QQueryOperations> accessedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accessedAt');
    });
  }

  QueryBuilder<TranslationRecord, bool, QQueryOperations>
  cancelIntentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cancelIntent');
    });
  }

  QueryBuilder<TranslationRecord, int, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<TranslationRecord, int, QQueryOperations>
  deliveryRevisionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deliveryRevision');
    });
  }

  QueryBuilder<TranslationRecord, String, QQueryOperations>
  descriptorJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'descriptorJson');
    });
  }

  QueryBuilder<TranslationRecord, String?, QQueryOperations>
  errorCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'errorCode');
    });
  }

  QueryBuilder<TranslationRecord, int, QQueryOperations> heightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'height');
    });
  }

  QueryBuilder<TranslationRecord, int, QQueryOperations> inputBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inputBytes');
    });
  }

  QueryBuilder<TranslationRecord, String, QQueryOperations>
  inputMimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inputMime');
    });
  }

  QueryBuilder<TranslationRecord, String, QQueryOperations>
  inputPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inputPath');
    });
  }

  QueryBuilder<TranslationRecord, String, QQueryOperations> inputShaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inputSha');
    });
  }

  QueryBuilder<TranslationRecord, String, QQueryOperations> languageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'language');
    });
  }

  QueryBuilder<TranslationRecord, String, QQueryOperations>
  locatorSignatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locatorSignature');
    });
  }

  QueryBuilder<TranslationRecord, bool, QQueryOperations> originalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'original');
    });
  }

  QueryBuilder<TranslationRecord, String, QQueryOperations> pageKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pageKey');
    });
  }

  QueryBuilder<TranslationRecord, String, QQueryOperations> phaseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phase');
    });
  }

  QueryBuilder<TranslationRecord, bool, QQueryOperations> publishedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'published');
    });
  }

  QueryBuilder<TranslationRecord, String, QQueryOperations>
  remoteStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteState');
    });
  }

  QueryBuilder<TranslationRecord, int, QQueryOperations> resultBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resultBytes');
    });
  }

  QueryBuilder<TranslationRecord, String, QQueryOperations>
  resultFormatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resultFormat');
    });
  }

  QueryBuilder<TranslationRecord, String?, QQueryOperations>
  resultPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resultPath');
    });
  }

  QueryBuilder<TranslationRecord, String?, QQueryOperations>
  resultShaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resultSha');
    });
  }

  QueryBuilder<TranslationRecord, String, QQueryOperations> scopeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scope');
    });
  }

  QueryBuilder<TranslationRecord, String?, QQueryOperations>
  snapshotJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snapshotJson');
    });
  }

  QueryBuilder<TranslationRecord, int, QQueryOperations>
  sourceHeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceHeight');
    });
  }

  QueryBuilder<TranslationRecord, String, QQueryOperations>
  sourceShaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceSha');
    });
  }

  QueryBuilder<TranslationRecord, int, QQueryOperations> sourceWidthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceWidth');
    });
  }

  QueryBuilder<TranslationRecord, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<TranslationRecord, int, QQueryOperations> widthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'width');
    });
  }
}
