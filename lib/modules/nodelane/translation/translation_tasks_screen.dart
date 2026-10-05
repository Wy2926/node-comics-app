import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'translation_provider.dart';
import 'translation_types.dart';

class TranslationTasksScreen extends ConsumerWidget {
  const TranslationTasksScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(translationProvider);
    final records = service.records;
    return Scaffold(
      appBar: AppBar(title: const Text('翻译任务')),
      body: records.isEmpty
          ? const Center(child: Text('阅读时长按图片，选择「翻译此页」'))
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final r = records[index];
                return ListTile(
                  leading: const Icon(Icons.translate),
                  title: Text(
                    '${r.language} · ${r.original
                        ? '原图无可见变化'
                        : r.published
                        ? '已完成'
                        : r.remoteState}',
                  ),
                  subtitle: Text(
                    r.errorCode == null
                        ? '${r.width} × ${r.height}'
                        : translationErrorMessage(r.errorCode),
                  ),
                  trailing: TextButton(
                    onPressed: () => service.resume(r.id),
                    child: const Text('继续同步'),
                  ),
                );
              },
            ),
    );
  }
}
