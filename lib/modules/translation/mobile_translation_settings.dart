import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'translation_language_picker.dart';

/// Mobile presentation of translation language and cache operations.
/// Credentials, persistence and runtime replacement stay in the service.
class MobileTranslationSettings extends ConsumerStatefulWidget {
  const MobileTranslationSettings({super.key});

  @override
  ConsumerState<MobileTranslationSettings> createState() =>
      _MobileTranslationSettingsState();
}

class _MobileTranslationSettingsState
    extends ConsumerState<MobileTranslationSettings> {
  late final service = ref.read(translationServiceProvider);
  bool _initializing = true;
  String? _initializationError;
  String? _activity;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    String? error;
    try {
      await service.initialize();
    } catch (_) {
      // Initialization is memoized by the service. Do not offer a retry that
      // would merely await the same failed Future or expose a storage error.
      error = '暂时无法读取翻译设置，请重新启动应用后再试。';
    }
    if (!mounted) return;
    setState(() {
      _initializing = false;
      _initializationError = error;
    });
  }

  bool get _disabled =>
      _initializing || _initializationError != null || service.busy;

  Future<void> _perform(
    Future<void> Function() operation,
    String activity, {
    String? success,
  }) async {
    if (_disabled) return;
    setState(() => _activity = activity);
    await operation();
    if (!mounted) return;
    setState(() => _activity = null);
    final message = service.error ?? success;
    if (message != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _chooseLanguage() async {
    if (_disabled) return;
    final language = await showTranslationLanguagePicker(
      context,
      service.language,
    );
    if (!mounted || language == null || language == service.language) return;
    await _perform(() => service.setLanguage(language), '正在保存目标语言…');
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: service,
    builder: (context, _) {
      final colors = NodeLaneTokens.of(context);
      final status = _initializing
          ? '正在读取翻译设置…'
          : service.busy
          ? _activity ?? '正在处理…'
          : null;
      final error = _initializationError ?? service.error;
      return NodeLaneSurface(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight:
                (MediaQuery.textScalerOf(context).scale(22) * 1.3 + 16).clamp(
                  kToolbarHeight,
                  double.infinity,
                ),
            title: const Text(
              '漫画翻译',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            bottom: status == null
                ? null
                : PreferredSize(
                    preferredSize: const Size.fromHeight(3),
                    child: LinearProgressIndicator(
                      minHeight: 3,
                      semanticsLabel: status,
                    ),
                  ),
          ),
          body: SafeArea(
            top: false,
            child: ListView(
              key: const PageStorageKey('mobile-translation-settings'),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: status != null || error != null ? 20 : 0,
                  ),
                  child: Semantics(
                    liveRegion: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (status != null) ...[
                          Text(status, style: TextStyle(color: colors.muted)),
                        ],
                        if (error != null) ...[
                          if (status != null) const SizedBox(height: 12),
                          Text(
                            error,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                MobileSettingsGroup(
                  key: const ValueKey('translation-language'),
                  title: '翻译',
                  children: [
                    ListTile(
                      enabled: !_disabled,
                      onTap: _disabled ? null : _chooseLanguage,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      leading: Icon(
                        Icons.translate_rounded,
                        color: colors.accent,
                      ),
                      title: const Text('目标语言'),
                      subtitle: Text(
                        translationLanguageNames[service.language] ??
                            service.language,
                        style: TextStyle(color: colors.muted),
                      ),
                      trailing: Icon(Icons.chevron_right, color: colors.muted),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        '在阅读器或网页工具栏开启翻译，随读随译；可随时切回原图。',
                        style: TextStyle(fontSize: 14, color: colors.muted),
                      ),
                    ),
                  ],
                ),
                MobileSettingsGroup(
                  key: const ValueKey('translation-cache'),
                  title: '本机缓存',
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '保留翻译记录，需要时重新读取译图。',
                            style: TextStyle(fontSize: 14, color: colors.muted),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: _disabled
                                ? null
                                : () => _perform(
                                    service.clearResults,
                                    '正在清理译图缓存…',
                                    success: '译图缓存已清理，翻译记录已保留',
                                  ),
                            child: const Text('清理译图缓存'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
