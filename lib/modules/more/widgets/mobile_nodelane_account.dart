import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/widgets/mobile_account_widgets.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/translation/channels/nodelane/account.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileNodeLaneAccountPage extends StatelessWidget {
  const MobileNodeLaneAccountPage({super.key});
  @override
  Widget build(BuildContext context) => const _AccountView(compact: false);
}

class MobileNodeLaneAccountSummary extends StatelessWidget {
  const MobileNodeLaneAccountSummary({super.key});
  @override
  Widget build(BuildContext context) => const _AccountView(compact: true);
}

/// Summary and detail use one session and one bounded account read. Navigation
/// never initializes another account store or changes the translation runtime.
class _AccountView extends ConsumerStatefulWidget {
  const _AccountView({required this.compact});
  final bool compact;
  @override
  ConsumerState<_AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends ConsumerState<_AccountView>
    with WidgetsBindingObserver {
  late final service = ref.read(translationServiceProvider);
  bool _initializing = true, _initFailed = false, _details = false;
  bool _websiteOpen = false, _confirming = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await service.initialize();
      if (!mounted) return;
      setState(() => _initializing = false);
      if (service.loggedIn && (!widget.compact || service.account == null)) {
        unawaited(service.refreshAccount());
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _initializing = false;
          _initFailed = true;
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_websiteOpen && state == AppLifecycleState.resumed) {
      _websiteOpen = false;
      unawaited(service.refreshAccount());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool get _disabled => _initializing || _initFailed || service.busy;

  Future<void> _website(bool free) async {
    if (_websiteOpen) return;
    _websiteOpen = true;
    try {
      // The website owns its own login and billing flow. Never pass app tokens.
      final opened = await launchUrl(
        Uri.https('comics.nodelane.net', free ? '/pricing/' : '/account/'),
        mode: LaunchMode.externalApplication,
      );
      if (!opened) throw StateError('Unavailable');
    } catch (_) {
      _websiteOpen = false;
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.failed)));
      }
    }
  }

  Future<void> _logout() async {
    if (_disabled || _confirming) return;
    _confirming = true;
    final confirmed = await showMobileSettingsConfirmation(
      context,
      title: context.l10n.nodelane_sign_out,
      message: context.l10n.nodelane_sign_out_confirm,
      confirmLabel: context.l10n.nodelane_sign_out,
    );
    _confirming = false;
    if (mounted && confirmed) {
      setState(() => _details = false);
      await service.logout();
    }
  }

  String _date(DateTime date, {bool time = false}) {
    final local = date.toLocal();
    final material = MaterialLocalizations.of(context);
    final dateText = DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(local);
    return '$dateText${time ? ' ${material.formatTimeOfDay(TimeOfDay.fromDateTime(local), alwaysUse24HourFormat: true)}' : ''}';
  }

  String _plan(NodeLaneAccount account) => account.isFree
      ? context.l10n.nodelane_account_free
      : account.planName ??
            account.plan ??
            context.l10n.nodelane_account_unknown;

  Widget _avatar({bool hero = false}) {
    final t = NodeLaneTokens.of(context);
    return Container(
      width: hero
          ? NodeLaneTokens.accountHeroAvatarSize
          : NodeLaneTokens.avatarSize,
      height: hero
          ? NodeLaneTokens.accountHeroAvatarSize
          : NodeLaneTokens.avatarSize,
      decoration: BoxDecoration(color: t.soft, shape: BoxShape.circle),
      child: Icon(
        NodeLaneIcons.of(context).accountOutline,
        size: hero
            ? NodeLaneTokens.accountHeroIconSize
            : NodeLaneTokens.accountAvatarIconSize,
        color: t.muted,
      ),
    );
  }

  Widget _identity({required bool compact}) {
    final l = context.l10n, t = NodeLaneTokens.of(context);
    final account = service.account;
    final name = account?.name.trim().isNotEmpty == true
        ? account!.name
        : service.accountName.trim();
    final subtitle = _initializing
        ? l.nodelane_account_reading
        : _initFailed
        ? l.nodelane_account_init_error
        : !service.loggedIn
        ? l.nodelane_account_intro
        : service.accountAuthRequired
        ? l.nodelane_account_auth_error
        : service.accountLoadFailed
        ? l.nodelane_account_refresh_error
        : account?.expiresAt != null
        ? '${l.nodelane_account_expiry} ${_date(account!.expiresAt!)}'
        : account != null
        ? _plan(account)
        : service.accountLoading
        ? l.nodelane_account_reading
        : l.nodelane_account_unknown;
    return Semantics(
      button: compact,
      child: NodeLaneGroupSurface(
        child: InkWell(
          onTap: compact
              ? () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const MobileNodeLaneAccountPage(),
                  ),
                )
              : null,
          child: Padding(
            padding: NodeLaneTokens.groupPadding,
            child: Row(
              children: [
                _avatar(),
                const SizedBox(width: NodeLaneTokens.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: NodeLaneTokens.space8,
                        runSpacing: NodeLaneTokens.space4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            !service.loggedIn
                                ? l.nodelane_sign_in
                                : name.isEmpty
                                ? l.nodelane_account
                                : name,
                            style: t.readerLabel.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (compact &&
                              account != null &&
                              account.plan != null)
                            NodeLaneCoverBadge(
                              _plan(account),
                              tone: NodeLaneBadgeTone.softAccent,
                            ),
                        ],
                      ),
                      const SizedBox(height: NodeLaneTokens.space4),
                      if (compact)
                        Text(subtitle, style: t.readerSecondary)
                      else if (service.accountId != null || account != null)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${l.nodelane_account_id}  ${account?.id ?? service.accountId}',
                                style: t.caption,
                              ),
                            ),
                            NodeLaneIconButton(
                              icon: NodeLaneIcons.of(context).copy,
                              tooltip: MaterialLocalizations.of(context)
                                  .copyButtonLabel,
                              style: NodeLaneIconButtonStyle.plain,
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(
                                    text: account?.id ?? service.accountId!,
                                  ),
                                );
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l.error_reports_copied),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                if (compact) ...[
                  const SizedBox(width: NodeLaneTokens.space12),
                  Icon(
                    NodeLaneIcons.of(context).forward,
                    size: NodeLaneTokens.smallIconSize,
                    color: t.muted,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signIn() {
    final l = context.l10n, t = NodeLaneTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: NodeLaneTokens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: _avatar(hero: true)),
          const SizedBox(height: NodeLaneTokens.space24),
          Text(
            l.nodelane_sign_in,
            textAlign: TextAlign.center,
            style: t.detailTitle,
          ),
          const SizedBox(height: NodeLaneTokens.space12),
          Text(
            l.nodelane_account_intro,
            textAlign: TextAlign.center,
            style: t.readerSecondary,
          ),
          const SizedBox(height: NodeLaneTokens.space24),
          FilledButton(
            onPressed: _disabled ? null : service.login,
            child: Text(l.nodelane_login_action),
          ),
          const SizedBox(height: NodeLaneTokens.space12),
          Text(
            l.nodelane_login_browser,
            textAlign: TextAlign.center,
            style: t.readerSecondary,
          ),
        ],
      ),
    );
  }

  Widget _subscription(NodeLaneAccount account) {
    final l = context.l10n;
    final expired = account.expiresAt?.isBefore(DateTime.now()) == true;
    return MobileSettingsGroup(
      title: l.nodelane_account_current,
      children: [
        NodeLaneRow(
          compact: true,
          prominent: true,
          title: _plan(account),
          subtitle: account.isFree ? l.nodelane_account_no_subscription : null,
          trailing: account.hasMembership
              ? NodeLaneCoverBadge(
                  expired
                      ? l.nodelane_account_expired
                      : l.nodelane_account_active,
                  tone: NodeLaneBadgeTone.softAccent,
                )
              : null,
        ),
        if (account.expiresAt != null)
          NodeLaneRow(
            compact: true,
            title: l.nodelane_account_expiry,
            value: _date(account.expiresAt!),
          ),
        if (account.hasMembership)
          NodeLaneRow(
            compact: true,
            title: l.nodelane_account_renewal,
            value: switch (account.renewal) {
              NodeLaneRenewal.automatic => l.nodelane_renewal_auto,
              NodeLaneRenewal.manual => l.nodelane_renewal_manual,
              NodeLaneRenewal.stopped => l.nodelane_renewal_stopped,
              NodeLaneRenewal.gift => l.nodelane_renewal_gift,
              NodeLaneRenewal.unknown => l.nodelane_quota_unknown,
            },
          ),
        if (account.renewal == NodeLaneRenewal.automatic &&
            account.nextBillingAt != null)
          NodeLaneRow(
            compact: true,
            title: l.nodelane_next_billing,
            value: _date(account.nextBillingAt!),
          ),
        if (account.billingUnavailable || account.renewalNeedsAttention)
          Padding(
            padding: NodeLaneTokens.groupPadding,
            child: Text(
              account.renewalNeedsAttention
                  ? l.nodelane_renewal_attention
                  : l.nodelane_billing_unavailable,
              style: NodeLaneTokens.of(context).readerSecondary,
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(NodeLaneTokens.space8),
          child: NodeLaneGroupSurface(
            selected: true,
            child: NodeLaneRow(
              compact: true,
              accented: true,
              title: account.isFree
                  ? l.nodelane_view_plans
                  : l.nodelane_manage_account,
              onTap: () => _website(account.isFree),
              trailing: Icon(
                NodeLaneIcons.of(context).external,
                size: NodeLaneTokens.smallIconSize,
                color: NodeLaneTokens.of(context).accent,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _available(NodeLaneQuota? quota, {bool notSubscribed = false}) {
    final l = context.l10n;
    if (quota == null) return l.nodelane_quota_unknown;
    if (quota.unlimited) return l.nodelane_quota_unlimited;
    if (notSubscribed && quota.granted == 0) {
      return l.nodelane_quota_not_subscribed;
    }
    return l.nodelane_quota_available(quota.available);
  }

  Widget _quotaDetail(
    String title,
    NodeLaneQuota? quota, {
    bool purchase = false,
  }) {
    final t = NodeLaneTokens.of(context), l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: NodeLaneTokens.space16),
      child: NodeLaneGroupSurface(
        child: Padding(
          padding: NodeLaneTokens.groupPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: t.readerLabel),
              const SizedBox(height: NodeLaneTokens.space8),
              Text(_available(quota), style: t.readerTitle),
              if (quota != null) ...[
                const SizedBox(height: NodeLaneTokens.space12),
                Wrap(
                  spacing: NodeLaneTokens.space24,
                  runSpacing: NodeLaneTokens.space8,
                  children: [
                    Text(
                      '${l.nodelane_quota_used} ${l.nodelane_quota_pages(quota.used)}',
                      style: t.readerSecondary,
                    ),
                    Text(
                      '${l.nodelane_quota_reserved} ${l.nodelane_quota_pages(quota.reserved)}',
                      style: t.readerSecondary,
                    ),
                  ],
                ),
                if (quota.resetsAt != null ||
                    quota.expiresAt != null ||
                    purchase) ...[
                  const SizedBox(height: NodeLaneTokens.space12),
                  Text(
                    quota.resetsAt != null
                        ? '${l.nodelane_quota_reset}  ${_date(quota.resetsAt!, time: true)}'
                        : quota.expiresAt != null
                        ? '${l.nodelane_quota_expiry}  ${_date(quota.expiresAt!, time: true)}'
                        : l.nodelane_quota_no_expiry,
                    style: t.readerSecondary,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _accountBody(NodeLaneAccount? account) {
    final l = context.l10n, t = NodeLaneTokens.of(context);
    return [
      _identity(compact: false),
      const SizedBox(height: NodeLaneTokens.space24),
      if (account != null && account.plan != null)
        _subscription(account)
      else
        NodeLaneRow.card(title: l.nodelane_account_unknown),
      if (account != null) ...[
        MobileSettingsGroup(
          title: l.nodelane_translation_quota,
          children: [
            NodeLaneRow(
              compact: true,
              title: l.nodelane_quota_free,
              value: _available(account.free),
            ),
            NodeLaneRow(
              compact: true,
              title: l.nodelane_quota_subscription,
              value: _available(
                account.subscription,
                notSubscribed: account.isFree,
              ),
            ),
            NodeLaneRow(
              compact: true,
              title: l.nodelane_quota_purchase,
              value: _available(account.purchase),
            ),
            Semantics(
              expanded: _details,
              child: NodeLaneRow(
                compact: true,
                title: _details
                    ? l.nodelane_quota_expanded
                    : l.nodelane_quota_details,
                onTap: () => setState(() => _details = !_details),
                trailing: Icon(
                  _details
                      ? NodeLaneIcons.of(context).up
                      : NodeLaneIcons.of(context).down,
                  size: NodeLaneTokens.smallIconSize,
                  color: t.muted,
                ),
              ),
            ),
          ],
        ),
        if (_details) ...[
          _quotaDetail(l.nodelane_quota_free, account.free),
          _quotaDetail(l.nodelane_quota_subscription, account.subscription),
          _quotaDetail(
            l.nodelane_quota_purchase,
            account.purchase,
            purchase: true,
          ),
          Text(l.nodelane_quota_reservation_note, style: t.caption),
          const SizedBox(height: NodeLaneTokens.space16),
        ],
        if (account.isFree) ...[
          Text(l.nodelane_quota_purchase_note, style: t.caption),
          const SizedBox(height: NodeLaneTokens.space8),
        ],
        Text(
          l.nodelane_account_updated(_date(account.updatedAt, time: true)),
          style: t.caption,
        ),
      ],
      const SizedBox(height: NodeLaneTokens.space24),
      NodeLaneGroupSurface(
        children: [
          NodeLaneRow(
            compact: true,
            title: l.nodelane_sign_out,
            destructive: true,
            enabled: !_disabled,
            onTap: _logout,
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: service,
    builder: (context, _) {
      if (widget.compact) return _identity(compact: true);
      final l = context.l10n, t = NodeLaneTokens.of(context);
      return NodeLaneSurface(
        child: PopScope(
          canPop: !service.busy,
          child: Scaffold(
            appBar: nodeLaneAppBar(
              context,
              title: l.nodelane_account,
              busy: _initializing || service.busy,
              actions: [
                if (service.loggedIn)
                  NodeLaneIconButton(
                    icon: NodeLaneIcons.of(context).refresh,
                    tooltip: l.refresh,
                    onPressed: _disabled || service.accountLoading
                        ? null
                        : service.refreshAccount,
                  ),
              ],
            ),
            body: SafeArea(
              top: false,
              child: ListView(
                padding: NodeLaneTokens.pagePadding,
                children: [
                  if (_initializing || service.accountLoading) ...[
                    Text(l.nodelane_account_reading, style: t.readerSecondary),
                    const SizedBox(height: NodeLaneTokens.space12),
                  ],
                  if (_initFailed ||
                      service.error != null ||
                      service.accountLoadFailed) ...[
                    Text(
                      _initFailed
                          ? l.nodelane_account_init_error
                          : service.accountAuthRequired
                          ? l.nodelane_account_auth_error
                          : service.accountLoadFailed
                          ? l.nodelane_account_refresh_error
                          : service.error!,
                      style: t.readerSecondary,
                    ),
                    if (service.accountAuthRequired)
                      TextButton(
                        onPressed: _disabled ? null : service.login,
                        child: Text(l.nodelane_login_action),
                      )
                    else if (service.accountLoadFailed)
                      TextButton(
                        onPressed: service.accountLoading
                            ? null
                            : service.refreshAccount,
                        child: Text(l.retry),
                      ),
                    const SizedBox(height: NodeLaneTokens.space16),
                  ],
                  if (service.loggedIn)
                    ..._accountBody(service.account)
                  else
                    _signIn(),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
