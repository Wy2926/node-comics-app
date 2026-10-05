import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/nodelane/nodelane_models.dart';
import 'package:mangayomi/modules/nodelane/nodelane_provider.dart';
import 'package:mangayomi/modules/nodelane/nodelane_theme.dart';

class NodeLaneAccountScreen extends ConsumerWidget {
  const NodeLaneAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(nodeLaneAuthProvider);
    return Theme(
      data: NodeLaneTheme.apply(Theme.of(context)),
      child: Builder(
        builder: (context) {
          final colors = Theme.of(context).colorScheme;
          final fonts = Theme.of(context).textTheme;
          final chinese = Localizations.localeOf(context).languageCode == 'zh';
          String text(String zh, String en) => chinese ? zh : en;
          return Scaffold(
            appBar: AppBar(title: Text(text('我的账户', 'My account'))),
            body: ListenableBuilder(
              listenable: service,
              builder: (context, _) {
                final state = service.state;
                final account = state.account;
                final ready = state.initialized && !state.busy;
                final mode = account?.entitlements.modes['classic'];
                final plan = account?.entitlements.plan;
                final member = plan != null && plan != 'free';
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 24, 32),
                      children: [
                        Container(
                          decoration: NodeLaneTheme.panel(
                            colors,
                            accented: true,
                          ),
                          child: ClipRRect(
                            borderRadius: NodeLaneTheme.panelRadius,
                            child: CustomPaint(
                              painter: _PaperDots(colors.primary),
                              child: Padding(
                                padding: const EdgeInsets.all(22),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'YOUR READING SPACE',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                        color: colors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Transform.rotate(
                                          angle: -0.07,
                                          child: Container(
                                            width: 46,
                                            height: 46,
                                            decoration:
                                                NodeLaneTheme.action(
                                                  colors,
                                                  enabled: true,
                                                ).copyWith(
                                                  color: colors.surface,
                                                  border: Border.all(
                                                    color: NodeLaneTheme.stroke(
                                                      colors,
                                                    ),
                                                    width: 2,
                                                  ),
                                                ),
                                            alignment: Alignment.center,
                                            child: account == null
                                                ? Icon(
                                                    Icons.person_outline,
                                                    color: colors.primary,
                                                  )
                                                : Text(
                                                    account
                                                        .user
                                                        .name
                                                        .characters
                                                        .first
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: colors.primary,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                account?.user.name ??
                                                    text(
                                                      '登录 NodeLane',
                                                      'Sign in to NodeLane',
                                                    ),
                                                style: fonts.headlineSmall,
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 9,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: colors.surface,
                                                  border: Border.all(
                                                    color: NodeLaneTheme.stroke(
                                                      colors,
                                                    ),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                                child: Text(
                                                  account == null
                                                      ? text(
                                                          '漫画阅读通行证',
                                                          'Your reading passport',
                                                        )
                                                      : member
                                                      ? '${plan.toUpperCase()} ${text('会员', 'member')}'
                                                      : text(
                                                          '普通用户',
                                                          'Free account',
                                                        ),
                                                  style: fonts.bodySmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      text(
                                        '使用现有账号查看会员与翻译额度。',
                                        'View your membership and translation quota with your existing account.',
                                      ),
                                      style: TextStyle(
                                        color: colors.onSurfaceVariant,
                                        fontSize: 14,
                                        height: 1.6,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 3,
                                      child: !state.initialized || state.busy
                                          ? const LinearProgressIndicator()
                                          : Divider(
                                              height: 3,
                                              color: colors.primary.withValues(
                                                alpha: 0.35,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (state.error case final error?) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: colors.errorContainer,
                              border: Border(
                                left: BorderSide(color: colors.error, width: 3),
                              ),
                              borderRadius: NodeLaneTheme.controlRadius,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _errorMessage(error, chinese),
                                  style: TextStyle(color: colors.error),
                                ),
                                if (account != null)
                                  Text(
                                    text(
                                      '当前显示上次保存的账号资料，可稍后刷新。',
                                      'Showing saved account details. Refresh when your connection recovers.',
                                    ),
                                    style: fonts.bodySmall,
                                  ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 28),
                        if (account != null) ...[
                          if (mode != null)
                            Container(
                              decoration: NodeLaneTheme.panel(colors).copyWith(
                                borderRadius: NodeLaneTheme.cardRadius,
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.brightness == Brightness.dark
                                        ? const Color(0xff080f1a)
                                        : colors.onSurface,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.translate,
                                        color: colors.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 9),
                                      Expanded(
                                        child: Text(
                                          text('常规翻译', 'Classic translation'),
                                          style: TextStyle(
                                            color: colors.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.end,
                                    spacing: 8,
                                    children: [
                                      Text(
                                        mode.unlimited
                                            ? text('不限量', 'Unlimited')
                                            : mode.available?.toString() ?? '—',
                                        style: TextStyle(
                                          fontSize: 32,
                                          height: 1.2,
                                          fontWeight: FontWeight.w800,
                                          fontFeatures: const [
                                            FontFeature.tabularFigures(),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        text('可用额度', 'available'),
                                        style: fonts.bodySmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    !mode.allowed
                                        ? text(
                                            '当前账号暂不可使用常规翻译',
                                            'Translation is currently unavailable for this account',
                                          )
                                        : text(
                                            '已使用 ${mode.used ?? '—'} · 预留 ${mode.reserved ?? '—'}',
                                            'Used ${mode.used ?? '—'} · Reserved ${mode.reserved ?? '—'}',
                                          ),
                                    style: fonts.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          if (account.entitlements.plusExpiresAt
                              case final expiry?)
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                '${text('会员到期', 'Membership expires')}: ${MaterialLocalizations.of(context).formatMediumDate(expiry.toLocal())}',
                                style: fonts.bodySmall,
                              ),
                            ),
                          const SizedBox(height: 28),
                          DecoratedBox(
                            decoration: NodeLaneTheme.action(
                              colors,
                              enabled: ready,
                            ),
                            child: FilledButton.icon(
                              onPressed: ready
                                  ? () => _run(service.reloadAccount)
                                  : null,
                              icon: const Icon(Icons.refresh),
                              label: Text(text('刷新账号资料', 'Refresh account')),
                            ),
                          ),
                          const SizedBox(height: 14),
                          OutlinedButton(
                            onPressed: state.initialized
                                ? () => _run(service.signOut)
                                : null,
                            child: Text(text('退出登录', 'Sign out')),
                          ),
                          TextButton(
                            onPressed: ready
                                ? () => _run(
                                    () => service.signIn(selectAccount: true),
                                  )
                                : null,
                            child: Text(text('切换账号', 'Switch account')),
                          ),
                        ] else ...[
                          DecoratedBox(
                            decoration: NodeLaneTheme.action(
                              colors,
                              enabled: ready && service.config.canSignIn,
                            ),
                            child: FilledButton.icon(
                              onPressed: ready && service.config.canSignIn
                                  ? () => _run(service.signIn)
                                  : null,
                              icon: const Icon(Icons.login),
                              label: Text(
                                text('登录 NodeLane', 'Sign in to NodeLane'),
                              ),
                            ),
                          ),
                          if (!service.config.canSignIn) ...[
                            const SizedBox(height: 16),
                            Text(
                              text(
                                '此开发版本尚未配置移动端登录，请联系开发者。',
                                'Mobile sign-in has not been configured in this development build.',
                              ),
                              style: fonts.bodySmall,
                            ),
                          ],
                          if (state.error?.code == 'STORAGE_FAILED')
                            TextButton(
                              onPressed: ready
                                  ? () => _run(service.signOut)
                                  : null,
                              child: Text(
                                text('重试清除登录记录', 'Retry clearing sign-in'),
                              ),
                            ),
                        ],
                        const SizedBox(height: 24),
                        Text(
                          text(
                            '书架、阅读进度和图片保存在本机。',
                            'Your library, reading progress and images stay on this device.',
                          ),
                          textAlign: TextAlign.center,
                          style: fonts.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _errorMessage(NodeLaneException error, bool chinese) {
    if (chinese) return error.message;
    return switch (error.code) {
      'CONNECTION_FAILED' =>
        'Unable to connect. Check your connection and retry.',
      'LOGIN_CANCELLED' => 'Sign-in was cancelled. You can try again.',
      'LOGIN_REQUIRED' ||
      'SESSION_INVALID' ||
      'IDENTITY_CHANGED' => 'Your session has expired. Please sign in again.',
      'FORBIDDEN' => 'This account does not have access to this operation.',
      'RATE_LIMITED' => 'Too many requests. Please try again later.',
      'REQUEST_FAILED' || 'IDENTITY_FAILED' =>
        'The service is temporarily unavailable. Please try again later.',
      'CLIENT_NOT_CONFIGURED' =>
        'Mobile sign-in has not been configured in this build.',
      'STORAGE_FAILED' =>
        'Unable to save or clear your sign-in securely. Please retry.',
      _ => 'Unable to complete the account connection. Please retry.',
    };
  }

  Future<void> _run(Future<void> Function() operation) async {
    try {
      await operation();
    } on NodeLaneException {
      // The service publishes safe errors for this page to display.
    }
  }
}

class _PaperDots extends CustomPainter {
  const _PaperDots(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final ink = Paint()..color = color.withValues(alpha: 0.18);
    for (double y = 7; y < size.height; y += 7) {
      for (double x = 7; x < size.width; x += 7) {
        canvas.drawCircle(Offset(x, y), 0.7, ink);
      }
    }
  }

  @override
  bool shouldRepaint(_PaperDots oldDelegate) => oldDelegate.color != color;
}
