import 'package:flutter/material.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/widgets/nodelane_pane_layout.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/support_requests.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/device_description.dart';

bool _showing = false;

Future<void> showSupportRequest(
  BuildContext context,
  SupportRequestKind kind, {
  String? website,
}) async {
  if (_showing) return;
  _showing = true;
  FocusScope.of(context).unfocus();
  try {
    await pushBrowsePage<void>(
      context,
      SupportRequestPage(kind: kind, website: website),
    );
  } finally {
    _showing = false;
  }
}

class SupportRequestPage extends StatefulWidget {
  const SupportRequestPage({
    super.key,
    required this.kind,
    this.website,
    this.requests,
    this.editingSession,
  });
  final SupportRequestKind kind;
  final String? website;
  final SupportRequests? requests;

  /// Unsubmitted text lives only as long as the source directory that opened it.
  final PageStorageBucket? editingSession;

  @override
  State<SupportRequestPage> createState() => _SupportRequestPageState();
}

class _SupportRequestPageState extends State<SupportRequestPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _url = TextEditingController();
  final _comment = TextEditingController();
  final _contact = TextEditingController();
  late final _requests = widget.requests ?? SupportRequests();
  SupportRequestDraft? _draft;
  bool _loading = true, _loadFailed = false, _busy = false;
  String? _error;
  String _version = '';
  bool get _website => widget.kind == SupportRequestKind.website;

  @override
  void initState() {
    super.initState();
    final edits = widget.editingSession?.readState(
      context,
      identifier: widget.kind,
    ) as (String, String, String, String)?;
    if (edits == null) {
      _prefill();
    } else {
      _name.text = edits.$1;
      _url.text = edits.$2;
      _comment.text = edits.$3;
      _contact.text = edits.$4;
    }
    _load();
  }

  void _prefill() {
    _url.text = supportWebsiteUrl(widget.website ?? '') ?? '';
    _name.text = Uri.tryParse(_url.text)?.host ?? '';
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadFailed = false;
    });
    try {
      final draft = await _requests.load(widget.kind);
      final version = _website ? '' : await appVersionDescription();
      if (!mounted) return;
      _version = version;
      _draft = draft;
      if (draft != null) {
        _name.text = draft.siteName;
        _url.text = draft.url;
        _comment.text = draft.comment;
        _contact.text = draft.contact;
      }
    } catch (_) {
      if (mounted) _loadFailed = true;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    if (_busy || _loading || _loadFailed) return;
    if (_draft == null && !_form.currentState!.validate()) return;
    final l = context.l10n;
    setState(() {
      _busy = true;
      _error = null;
    });
    _draft ??= SupportRequestDraft(
      kind: widget.kind,
      siteName: _website ? _name.text.trim() : '',
      url: _website ? supportWebsiteUrl(_url.text)! : '',
      comment: _comment.text.trim(),
      contact: _contact.text.trim(),
      appVersion: _version,
    );
    try {
      final received = await _requests.submit(_draft!);
      if (mounted) setState(() => _draft = received);
    } on SupportRequestRejected catch (failure) {
      if (!mounted) return;
      try {
        await _requests.clear(widget.kind);
        if (mounted) {
          setState(() {
            _draft = null;
            _error = failure.status == 429
                ? l.feedback_limited
                : l.feedback_failed;
          });
        }
      } catch (_) {
        if (mounted) setState(() => _error = l.feedback_unknown);
      }
    } catch (_) {
      if (mounted) setState(() => _error = l.feedback_unknown);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _another() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await _requests.clear(widget.kind);
      if (!mounted) return;
      setState(() {
        _draft = null;
        _error = null;
        _comment.clear();
        _contact.clear();
        _prefill();
      });
    } catch (_) {
      if (mounted) setState(() => _error = context.l10n.feedback_load_failed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    if (!_loading && !_loadFailed) {
      widget.editingSession?.writeState(
        context,
        _draft == null
            ? (_name.text, _url.text, _comment.text, _contact.text)
            : null,
        identifier: widget.kind,
      );
    }
    _requests.close();
    for (final controller in [_name, _url, _comment, _contact]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _validate(String? value, int max, {bool required = false}) {
    final text = (value ?? '').trim();
    if (required && text.isEmpty) return context.l10n.category_name_required;
    if (text.runes.length > max) return context.l10n.feedback_limit(max);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final received = _draft?.receipt;
    final locked = _busy || _draft != null;
    return MobileBrowsePage.form(
      title: _website ? l.feedback_source : l.feedback_app,
      bottomAction: _loading || _loadFailed
          ? null
          : received != null
          ? NodeLaneSecondaryButton(
              onPressed: _busy ? null : _another,
              child: Text(l.feedback_another),
            )
          : FilledButton.icon(
              onPressed: _busy ? null : _submit,
              icon: Icon(
                _draft == null
                    ? (_website
                          ? NodeLaneIcons.of(context).web
                          : NodeLaneIcons.of(context).chat)
                    : NodeLaneIcons.of(context).refresh,
              ),
              label: Text(
                _busy
                    ? l.translation_submitting
                    : _draft == null
                    ? (_website ? l.feedback_submit_source : l.feedback_submit)
                    : l.feedback_retry,
              ),
            ),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: NodeLaneTokens.pagePadding,
        children: [
          if (_loading)
            const NodeLaneEmptyState.loading()
          else if (_loadFailed)
            NodeLaneNotice(
              message: l.feedback_load_failed,
              kind: NodeLaneNoticeKind.error,
              actionLabel: l.retry,
              onAction: _load,
            )
          else if (received != null) ...[
            NodeLaneNotice(
              message: l.feedback_received,
              kind: NodeLaneNoticeKind.success,
            ),
            const SizedBox(height: NodeLaneTokens.space12),
            SelectableText(received, style: NodeLaneTokens.of(context).caption),
          ] else ...[
            Text(
              _website ? l.feedback_source_hint : l.feedback_app_hint,
              style: NodeLaneTokens.of(context).readerSecondary,
            ),
            const SizedBox(height: NodeLaneTokens.space16),
            Form(
              key: _form,
              autovalidateMode: AutovalidateMode.onUserInteractionIfError,
              child: Column(
                children: [
                  if (_website) ...[
                    NodeLaneToolbarPair(
                      alignment: WrapCrossAlignment.start,
                      first: NodeLaneTextField(
                        controller: _name,
                        label: l.feedback_site_name,
                        textInputAction: TextInputAction.next,
                        enabled: !locked,
                        validator: (v) => _validate(v, 100, required: true),
                      ),
                      second: NodeLaneTextField(
                        controller: _url,
                        label: l.url,
                        hint: 'https://example.com/',
                        keyboardType: TextInputType.url,
                        autocorrect: false,
                        enableSuggestions: false,
                        enabled: !locked,
                        validator: (v) => supportWebsiteUrl(v ?? '') == null
                            ? l.invalid_url_format
                            : _validate(supportWebsiteUrl(v!)!, 2048),
                      ),
                    ),
                    const SizedBox(height: NodeLaneTokens.space16),
                  ],
                  NodeLaneTextField(
                    controller: _comment,
                    label: _website
                        ? l.feedback_optional_comment
                        : l.feedback_comment,
                    minLines: _website ? 2 : 4,
                    maxLines: 8,
                    keyboardType: TextInputType.multiline,
                    enabled: !locked,
                    validator: (v) => _validate(
                      v,
                      1000 -
                          (_website
                              ? 0
                              : supportAppCommentPrefix.length +
                                    _version.length +
                                    (_version.isEmpty ? 0 : 1)),
                      required: !_website,
                    ),
                  ),
                  const SizedBox(height: NodeLaneTokens.space16),
                  NodeLaneTextField(
                    controller: _contact,
                    label: l.feedback_contact,
                    enabled: !locked,
                    validator: (v) => _validate(v, 200),
                  ),
                ],
              ),
            ),
            if (_draft != null && !_busy && _error == null) ...[
              const SizedBox(height: NodeLaneTokens.space16),
              NodeLaneNotice(message: l.feedback_unknown),
            ],
          ],
          if (_error != null) ...[
            const SizedBox(height: NodeLaneTokens.space16),
            NodeLaneNotice(message: _error!, kind: NodeLaneNoticeKind.error),
          ],
        ],
      ),
    );
  }
}
