// Explicit integration runner. App's default test suite has no sibling dependency.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/models/source.dart';

void main() {
  final root = Platform.environment['NODELANE_PLUGIN_BUILD'];
  final fixtures = Platform.environment['NODELANE_PLUGIN_FIXTURES'];
  if (root == null || fixtures == null) {
    throw StateError(
      'Run the selected plugin repository test:app command with an explicit App path',
    );
  }
  final catalog = (jsonDecode(
    File('$root/index.json').readAsStringSync(),
  ) as List).cast<Map<String, dynamic>>();
  final contracts = (jsonDecode(
    File('$fixtures/contracts.json').readAsStringSync(),
  ) as List).cast<Map<String, dynamic>>();
  for (final contract in contracts) {
    test('${contract['slug']}: ${contract['name']}', () async {
      final entry = catalog.singleWhere(
        (e) => e['nodelane']['slug'] == contract['slug'],
      );
      final source = Source.fromJson(entry)
        ..sourceCode = File('$root/${entry['sourceCodeUrl']}')
            .readAsStringSync();
      final service = JsExtensionService(source);
      addTearDown(service.dispose);
      service.getHeaders(); // Initializes the real App runtime and bridge.
      final responses = (contract['responses'] as List)
          .cast<Map<String, dynamic>>();
      final requests = <Uri>[];
      var cursor = 0;
      service.runtime.onMessage('plugin_contract_http', (dynamic args) async {
        requests.add(Uri.parse(args[0]));
        if (cursor >= responses.length) {
          throw StateError('Unexpected network request');
        }
        final response = responses[cursor++];
        return jsonEncode({
          'statusCode': response['statusCode'] ?? 200,
          'headers': response['headers'] ?? {},
          'body': response['bodyFile'] != null
              ? File('$fixtures/${response['bodyFile']}').readAsStringSync()
              : response['jsonBody'] != null
              ? jsonEncode(response['jsonBody'])
              : response['body'] ?? '',
        });
      });
      service.runtime.evaluate('''
extention.client.get = async (url, headers) => JSON.parse(await sendMessage("plugin_contract_http",JSON.stringify([url,headers])));
extention.client.post = async (url, headers, body) => JSON.parse(await sendMessage("plugin_contract_http",JSON.stringify([url,headers,body])));
${contract['setup'] ?? ''}
''');
      final args = contract['args'] as List;
      Future<Map<String, dynamic>> run() async {
        switch (contract['method']) {
          case 'filters':
            final filters = service.getFilterList().filters;
            return {
              'count': filters.length,
              'types': filters.map((filter) => filter.type).toList(),
              'options': filters
                  .map(
                    (filter) => switch (filter) {
                      SelectFilter(:final values) => values.length,
                      SortFilter(:final values) => values.length,
                      GroupFilter(:final state) => state.length,
                      _ => 0,
                    },
                  )
                  .toList(),
              'preferences': service.getSourcePreferences().length,
            };
          case 'search':
            final result = await service.search(
              args[0],
              args[1],
              contract['nativeFilters'] == true
                  ? service.getFilterList().filters
                  : [],
            );
            return {
              'count': result.list.length,
              'name': result.list.firstOrNull?.name,
              'next': result.hasNextPage,
            };
          case 'popular':
            final result = await service.getPopular(args[0]);
            return {'count': result.list.length};
          case 'detail':
            final result = await service.getDetail(args[0]);
            return {
              'count': result.chapters?.length,
              'name': result.name,
              'author': result.author,
              'status': result.status?.name,
              'hasCover': result.imageUrl?.isNotEmpty ?? false,
              'uploadDates': result.chapters?.map((chapter) {
                final ms = int.tryParse(chapter.dateUpload ?? '');
                return ms == null
                    ? null
                    : DateTime.fromMillisecondsSinceEpoch(ms)
                          .toIso8601String()
                          .substring(0, 10);
              }).toList(),
            };
          case 'pages':
            final result = await service.getPageList(args[0]);
            return {
              'count': result.length,
              'urls': result.map((page) => page.url).toList(),
              'processing': result.firstOrNull?.imageProcessing
                  ?.toJson()['type'],
              'referer': result.firstOrNull?.headers?['Referer'],
            };
          default:
            throw StateError('Unknown contract method');
        }
      }

      if (contract['expectError'] != null) {
        await expectLater(
          run(),
          throwsA(
            predicate((e) => e.toString().contains(contract['expectError'])),
          ),
        );
      } else {
        final result = await run();
        for (final expected in (contract['expect'] as Map).entries) {
          if (expected.key == 'query') {
            for (final query in (expected.value as Map).entries) {
              expect(requests.single.queryParameters[query.key], query.value);
            }
          } else {
            expect(result[expected.key], expected.value);
          }
        }
      }
      expect(cursor, responses.length);
    });
  }
}
