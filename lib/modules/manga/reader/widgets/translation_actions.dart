import 'package:flutter/material.dart';

import 'dart:async';

import 'package:mangayomi/utils/language.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/nodelane/translation/translation_provider.dart';
import 'package:mangayomi/modules/nodelane/translation/translation_types.dart';

import '../providers/reader_translation_provider.dart';
import '../providers/reader_translation_window.dart';
import '../u_chap_data_preload.dart';

class TranslationActions extends ConsumerStatefulWidget {
  const TranslationActions({super.key, required this.data});
  final UChapDataPreload data;
  @override
  ConsumerState<TranslationActions> createState() => _TranslationActionsState();
}

class _TranslationActionsState extends ConsumerState<TranslationActions> {
  String? error;
  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() async {
      if (!mounted) return;
      final service = ref.read(translationProvider);
      if (service.scope != null) {
        try {
          await service.capabilities();
        } catch (_) {
          /* Cached reading remains available offline. */
        }
      }
    });
  }

  Future<void> perform(Future<void> Function() action) async {
    setState(() => error = null);
    try {
      await action();
    } catch (e) {
      if (mounted) {
        setState(() => error = translationErrorMessage(translationError(e)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(translationProvider);
    final window = ref.watch(readerTranslationWindowProvider);
    final key = readerTranslationKey(widget.data);
    final records = service
        .forPage(key)
        .where((r) => r.locatorSignature == readerLocatorSignature(widget.data))
        .toList();
    final latest = records.firstOrNull;
    final busy =
        service.preparing(key) || (latest != null && service.busy(latest.id));
    final status =
        error ??
        (latest?.errorCode != null
            ? translationErrorMessage(latest!.errorCode)
            : switch (latest?.phase) {
                'uploading' => '上传中',
                'queued' => '排队中',
                'running' => '翻译中',
                'composing' => '保存译图中',
                'downloading' => '读取结果中',
                'ready' => latest!.original ? '原图无可见变化' : '译图已保存',
                'failed' => '翻译失败',
                'needs_attention' => '结果待核实',
                'cancelling' => '取消待确认',
                'syncing' => '同步中',
                'evicted' => '译图缓存待恢复',
                _ => busy ? '准备送译图片…' : '官方常规翻译',
              });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.translate, size: 20),
              const SizedBox(width: 8),
              const Expanded(child: Text('NodeLane 翻译')),
            ],
          ),
          Text(status, style: Theme.of(context).textTheme.bodySmall),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: const Text('阅读时自动翻译'),
            subtitle: Text(window.error ?? '当前页优先，最多预译后续 3 页'),
            value: window.enabled,
            onChanged: service.scope == null ? null : window.setEnabled,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              DropdownButton<String>(
                value: service.languages.contains(service.language)
                    ? service.language
                    : null,
                hint: const Text('选择目标语言'),
                items: service.languages
                    .map(
                      (language) => DropdownMenuItem(
                        value: language,
                        child: Text(switch (language) {
                          'zh-Hans' => '简体中文',
                          'zh-Hant' => '繁體中文',
                          _ => completeLanguageName(language),
                        }),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) service.setLanguage(v);
                },
              ),
              FilledButton.icon(
                onPressed: busy
                    ? null
                    : () => perform(() async {
                        await service.translate(
                          readerTranslationPage(widget.data, ref),
                        );
                      }),
                icon: const Icon(Icons.translate, size: 18),
                label: Text(latest == null ? '翻译此页' : '继续同步'),
              ),
              if (records.any((r) => r.published && !r.original))
                TextButton(
                  onPressed: () => service.toggleOriginal(key),
                  child: Text(service.showOriginal(key) ? '显示译图' : '显示原图'),
                ),
              if (latest != null &&
                  ['failed', 'succeeded'].contains(latest.remoteState))
                TextButton(
                  onPressed: busy
                      ? null
                      : () => perform(() => service.retry(latest.id)),
                  child: Text(latest.remoteState == 'failed' ? '重试翻译' : '重新翻译'),
                ),
              if (latest?.errorCode == 'LOCAL_INPUT_MISSING')
                TextButton(
                  onPressed: busy
                      ? null
                      : () => perform(() async {
                          await service.translate(
                            readerTranslationPage(widget.data, ref),
                            newAttempt: true,
                          );
                        }),
                  child: const Text('重新送译当前原图'),
                ),
              if (latest != null &&
                  [
                    'needs_input',
                    'queued',
                    'running',
                  ].contains(latest.remoteState))
                TextButton(
                  onPressed: () => perform(() => service.cancel(latest.id)),
                  child: const Text('取消任务'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
