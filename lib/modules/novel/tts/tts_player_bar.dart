import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/tts/novel_tts_service.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

import 'mobile_tts_player_controls.dart';

class TtsPlayerBar extends ConsumerStatefulWidget {
  final String htmlContent;
  final VoidCallback onClose;
  final void Function(int paragraphIndex)? onParagraphChanged;
  final bool mobile;

  const TtsPlayerBar({
    super.key,
    required this.htmlContent,
    required this.onClose,
    this.onParagraphChanged,
    this.mobile = false,
  });

  @override
  ConsumerState<TtsPlayerBar> createState() => _TtsPlayerBarState();
}

class _TtsPlayerBarState extends ConsumerState<TtsPlayerBar> {
  final _tts = NovelTtsService.instance;
  TtsState _state = TtsState.stopped;
  int _currentIndex = 0;
  int _totalParagraphs = 0;
  bool _failed = false, _pending = false, _closed = false;
  int _command = 0;
  StreamSubscription<TtsState>? _stateSub;
  StreamSubscription<int>? _indexSub;

  @override
  void initState() {
    super.initState();
    _stateSub = _tts.stateStream.listen((s) {
      if (mounted) {
        setState(() {
          _state = s;
          _pending = false;
        });
        if (s == TtsState.stopped) {
          _close();
        }
      }
    });
    _indexSub = _tts.paragraphIndexStream.listen((i) {
      if (mounted) {
        setState(() {
          _currentIndex = i;
          _pending = false;
        });
        widget.onParagraphChanged?.call(i);
      }
    });
    _initAndPlay();
  }

  Future<void> _initAndPlay() async {
    final speed = ref.read(ttsSpeechRateStateProvider);
    final pitch = ref.read(ttsPitchStateProvider);
    final language = ref.read(ttsLanguageStateProvider);

    try {
      await _tts.setSpeed(speed);
      if (!mounted || _closed) return;
      await _tts.setPitch(pitch);
      if (!mounted || _closed) return;
      if (language != null) {
        await _tts.setLanguage(language);
        if (!mounted || _closed) return;
      }

      final paragraphs = _tts.extractParagraphs(widget.htmlContent);
      setState(() => _totalParagraphs = paragraphs.length);
      await _tts.speak(widget.htmlContent);
    } catch (_) {
      if (mounted && !_closed) setState(() => _failed = true);
    }
  }

  void _close() {
    if (!mounted || _closed) return;
    _closed = true;
    widget.onClose();
  }

  Future<void> _invoke(Future<void> Function() action) async {
    if (_pending || _closed || _failed) return;
    final command = ++_command;
    setState(() => _pending = true);
    try {
      // Speech futures can last until the utterance ends. Streamed state or
      // paragraph changes make controls available as soon as the action applies.
      await action();
    } catch (_) {
      if (mounted && command == _command && !_closed) {
        setState(() => _failed = true);
      }
    } finally {
      if (mounted && command == _command && !_closed) {
        setState(() => _pending = false);
      }
    }
  }

  Future<void> _stopAndClose() async {
    try {
      await _tts.stop();
    } finally {
      _close();
    }
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _indexSub?.cancel();
    unawaited(_tts.stop().catchError((Object _) {}));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mobile) {
      return MobileTtsPlayerControls(
        state: _state,
        index: _currentIndex,
        total: _totalParagraphs,
        failed: _failed,
        busy: _pending,
        onPrevious: () => _invoke(_tts.skipPrevious),
        onNext: () => _invoke(_tts.skipNext),
        onPlayPause: () =>
            _invoke(_state == TtsState.playing ? _tts.pause : _tts.resume),
        onStop: () => unawaited(_stopAndClose().catchError((Object _) {})),
      );
    }
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          if (_totalParagraphs > 0)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: LinearProgressIndicator(
                value: _totalParagraphs > 0
                    ? (_currentIndex + 1) / _totalParagraphs
                    : 0,
                minHeight: 3,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // TTS icon
                Icon(
                  Icons.record_voice_over,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),

                // Progress text
                Expanded(
                  child: Text(
                    _totalParagraphs > 0
                        ? context.l10n.tts_paragraph_progress(
                            '${_currentIndex + 1}',
                            '$_totalParagraphs',
                          )
                        : context.l10n.tts,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Skip previous
                IconButton(
                  onPressed: () => _tts.skipPrevious(),
                  icon: const Icon(Icons.skip_previous_rounded),
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  tooltip: context.l10n.tts_previous,
                ),

                // Play/Pause
                IconButton(
                  onPressed: () {
                    if (_state == TtsState.playing) {
                      _tts.pause();
                    } else if (_state == TtsState.paused) {
                      _tts.resume();
                    }
                  },
                  icon: Icon(
                    _state == TtsState.playing
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                  iconSize: 28,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  color: theme.colorScheme.primary,
                  tooltip: _state == TtsState.playing
                      ? context.l10n.tts_pause
                      : context.l10n.tts_play,
                ),

                // Skip next
                IconButton(
                  onPressed: () => _tts.skipNext(),
                  icon: const Icon(Icons.skip_next_rounded),
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  tooltip: context.l10n.tts_next,
                ),

                // Stop
                IconButton(
                  onPressed: () async {
                    await _tts.stop();
                    widget.onClose();
                  },
                  icon: const Icon(Icons.stop_rounded),
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  tooltip: context.l10n.tts_stop,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
