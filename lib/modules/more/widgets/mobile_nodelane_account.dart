import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Application account entry. The existing service owns the native session
/// and notifies reader/browser runtimes when the account changes.
class MobileNodeLaneAccount extends ConsumerStatefulWidget {
  const MobileNodeLaneAccount({super.key});

  @override
  ConsumerState<MobileNodeLaneAccount> createState() =>
      _MobileNodeLaneAccountState();
}

class _MobileNodeLaneAccountState extends ConsumerState<MobileNodeLaneAccount> {
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
      error = '暂时无法读取账号，请重新启动应用后再试。';
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
    String activity,
  ) async {
    if (_disabled) return;
    setState(() => _activity = activity);
    await operation();
    if (!mounted) return;
    setState(() => _activity = null);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: service,
    builder: (context, _) {
      final colors = NodeLaneTokens.of(context);
      final accountName = service.accountName.trim();
      final status = _initializing
          ? '正在读取账号…'
          : service.busy
          ? _activity ?? '正在处理…'
          : null;
      final error = _initializationError ?? service.error;
      return MobileSettingsGroup(
        title: '软件账号',
        children: [
          Padding(
            padding: const EdgeInsets.all(NodeLaneTokens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AccountHeading(
                  title: service.loggedIn
                      ? accountName.isEmpty
                            ? 'NodeLane 账号'
                            : accountName
                      : 'NodeLane',
                  subtitle: service.loggedIn
                      ? '已登录 NodeLane'
                      : '登录 NodeLane，使用漫画翻译服务。',
                ),
                const SizedBox(height: NodeLaneTokens.space20),
                if (service.loggedIn)
                  OutlinedButton(
                    onPressed: _disabled
                        ? null
                        : () => _perform(service.logout, '正在退出登录…'),
                    child: const Text('退出登录'),
                  )
                else ...[
                  FilledButton(
                    onPressed: _disabled
                        ? null
                        : () => _perform(service.login, '正在登录…'),
                    child: const Text('前往登录'),
                  ),
                  const SizedBox(height: NodeLaneTokens.space12),
                  Text(
                    '通过系统浏览器登录，完成后返回应用。',
                    textAlign: TextAlign.center,
                    style: colors.caption,
                  ),
                ],
                if (status != null || error != null) ...[
                  const SizedBox(height: NodeLaneTokens.space16),
                  Semantics(
                    liveRegion: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (status != null) ...[
                          LinearProgressIndicator(semanticsLabel: status),
                          const SizedBox(height: NodeLaneTokens.space12),
                          Text(status, style: TextStyle(color: colors.muted)),
                        ],
                        if (error != null) ...[
                          if (status != null)
                            const SizedBox(height: NodeLaneTokens.space12),
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
                ],
              ],
            ),
          ),
        ],
      );
    },
  );
}

class _AccountHeading extends StatelessWidget {
  const _AccountHeading({required this.title, required this.subtitle});
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final icon = Container(
      width: NodeLaneTokens.avatarSize,
      height: NodeLaneTokens.avatarSize,
      decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle),
      child: Icon(
        NodeLaneIcons.of(context).account,
        color: colors.onAccent,
        size: 38,
      ),
    );
    final identity = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: colors.title),
        const SizedBox(height: 6),
        Text(subtitle, style: colors.secondary),
      ],
    );
    if (MediaQuery.textScalerOf(context).scale(20) > 28) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          const SizedBox(height: NodeLaneTokens.space12),
          identity,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        const SizedBox(width: 12),
        Expanded(child: identity),
      ],
    );
  }
}
