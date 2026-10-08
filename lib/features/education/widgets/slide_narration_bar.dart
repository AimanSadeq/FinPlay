import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_endpoints.dart';
import '../../facilitator/api_once.dart';
import '../../../providers/repository_providers.dart';

/// One caption sentence and where it ends, as a fraction (0..1] of the clip.
class CaptionCue {
  final String text;
  final double end;
  const CaptionCue(this.text, this.end);
}

/// Website parity: captionTimeline() in client/src/lib/narration-captions.ts.
///
/// Splits a narration script into caption sentences, each with the share of the clip
/// it occupies. The TTS gives no word timings, so time is apportioned by length plus
/// a small allowance (8) for the pause after each sentence.
List<CaptionCue> captionTimeline(String script) {
  final sentences = script
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .split(RegExp(r'(?<=[.!?؟])\s+'))
      .where((s) => s.isNotEmpty)
      .toList();
  final weights = [for (final s in sentences) s.length + 8];
  final sum = weights.fold<int>(0, (a, b) => a + b);
  final total = sum == 0 ? 1 : sum;
  var acc = 0;
  return [
    for (var i = 0; i < sentences.length; i++) CaptionCue(sentences[i], (acc += weights[i]) / total),
  ];
}

/// The sentence being heard at [fraction] (position / duration) of the clip.
String? captionAt(List<CaptionCue> timeline, double fraction) {
  if (timeline.isEmpty) return null;
  for (final c in timeline) {
    if (fraction <= c.end) return c.text;
  }
  return timeline.last.text;
}

/// Speed and captions are user preferences, not per-slide settings (website 1a090d3):
/// persisted, and shared by every mounted player so 1.5× on one slide is still 1.5×
/// on the next, and in the next session. Same storage keys as the website.
class NarrationPrefs {
  static const speeds = [1.0, 1.25, 1.5];
  static const rateKey = 'narrationRate';
  static const captionsKey = 'narrationCaptions';

  static final ValueNotifier<double> rate = ValueNotifier(1.0);

  /// On by default (website: anything but a stored '0').
  static final ValueNotifier<bool> captions = ValueNotifier(true);

  static Future<void>? _loading;

  static Future<void> ensureLoaded() => _loading ??= _load();

  static Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final r = prefs.getDouble(rateKey);
      if (r != null && speeds.contains(r)) rate.value = r;
      captions.value = prefs.getString(captionsKey) != '0';
    } catch (_) {/* defaults stand */}
  }

  static Future<void> setRate(double next) async {
    if (!speeds.contains(next)) return;
    rate.value = next;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(rateKey, next);
    } catch (_) {/* preference just won't persist */}
  }

  static Future<void> setCaptions(bool on) async {
    captions.value = on;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(captionsKey, on ? '1' : '0');
    } catch (_) {/* preference just won't persist */}
  }

  @visibleForTesting
  static void resetForTest() {
    _loading = null;
    rate.value = 1.0;
    captions.value = true;
  }
}

/// AI audio-narration player for a single Learn slide (website parity:
/// SlideNarration.tsx). Lazily generates the clip on first Play via
/// POST /narration/prepare (which also returns the narration `script`), then
/// streams /narration/audio with just_audio. With captions on (CC), the sentence
/// being spoken is shown under the controls: the narration is an AI-written
/// explanation, not a reading of the slide, so its words are nowhere else on screen.
///
/// Give this a ValueKey tied to the slide so navigating to another slide
/// recreates it — disposing the old player and auto-stopping playback.
class SlideNarrationBar extends ConsumerStatefulWidget {
  final int moduleId;
  final String sectionId;
  final String text;
  final String language;

  const SlideNarrationBar({
    super.key,
    required this.moduleId,
    required this.sectionId,
    required this.text,
    this.language = 'en',
  });

  @override
  ConsumerState<SlideNarrationBar> createState() => _SlideNarrationBarState();
}

class _SlideNarrationBarState extends ConsumerState<SlideNarrationBar> {
  final AudioPlayer _player = AudioPlayer();
  bool _prepared = false;
  bool _loading = false;
  bool _error = false;
  List<CaptionCue> _timeline = const [];
  StreamSubscription<PlayerState>? _stateSub;

  @override
  void initState() {
    super.initState();
    NarrationPrefs.rate.addListener(_onRate);
    NarrationPrefs.captions.addListener(_onPrefsChanged);
    NarrationPrefs.ensureLoaded().then((_) => _onRate());
    // Rebuild on play/pause/complete so the icon and the caption follow the audio.
    _stateSub = _player.playerStateStream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    NarrationPrefs.rate.removeListener(_onRate);
    NarrationPrefs.captions.removeListener(_onPrefsChanged);
    _stateSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  void _onRate() {
    _player.setSpeed(NarrationPrefs.rate.value);
    if (mounted) setState(() {});
  }

  void _onPrefsChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _ensurePrepared() async {
    if (_prepared) return;
    setState(() { _loading = true; _error = false; });
    try {
      final api = ref.read(apiClientProvider);
      // Never auto-retried: a first prepare generates a paid clip, and a retry after a 5xx
      // or a slow response would pay for it again.
      final res = await api.postOnce(ApiEndpoints.narrationPrepare, data: {
        'moduleId': widget.moduleId.toString(),
        'sectionId': widget.sectionId,
        'language': widget.language,
        'text': widget.text,
      });
      final audioUrl = res['audioUrl'] as String?;
      if (audioUrl == null) throw Exception('no audio');
      final script = res['script'];
      _timeline = captionTimeline(script is String ? script : '');
      // audioUrl is rooted at /api; prepend the origin (baseUrl minus /api).
      final base = api.baseUrl;
      final origin = base.endsWith('/api') ? base.substring(0, base.length - 4) : base;
      await _player.setUrl('$origin$audioUrl');
      await _player.setSpeed(NarrationPrefs.rate.value);
      _prepared = true;
      if (mounted) setState(() => _loading = false);
    } catch (_) {
      if (mounted) setState(() { _loading = false; _error = true; });
    }
  }

  Future<void> _toggle() async {
    if (!_prepared) {
      await _ensurePrepared();
      if (!_prepared) return;
    }
    if (_player.playing) {
      await _player.pause();
    } else {
      // Restart if we reached the end.
      final dur = _player.duration;
      if (_player.processingState == ProcessingState.completed ||
          (dur != null && _player.position >= dur)) {
        await _player.seek(Duration.zero);
      }
      // play() completes only when playback stops, so don't await it.
      unawaited(_player.play());
    }
    if (mounted) setState(() {});
  }

  void _cycleSpeed() {
    const speeds = NarrationPrefs.speeds;
    final i = speeds.indexOf(NarrationPrefs.rate.value);
    NarrationPrefs.setRate(speeds[(i + 1) % speeds.length]);
  }

  /// Website rule: shown while the clip plays, or paused part way through; cleared
  /// when it ends or rewinds, and whenever captions are off.
  String? _captionFor(Duration pos) {
    if (!NarrationPrefs.captions.value || !_prepared || _timeline.isEmpty) return null;
    final dur = _player.duration;
    if (dur == null || dur == Duration.zero) return null;
    if (_player.processingState == ProcessingState.completed) return null;
    final paused = !_player.playing;
    if (paused && pos == Duration.zero) return null;
    return captionAt(_timeline, pos.inMilliseconds / dur.inMilliseconds);
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final captionsOn = NarrationPrefs.captions.value;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.purple.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.purple.withValues(alpha: 0.18)),
      ),
      child: _error
          ? Row(
              children: [
                Icon(Icons.volume_off_rounded, size: 18, color: AppColors.textTertiary(context)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s.tr('Narration unavailable', 'التعليق الصوتي غير متاح'),
                    style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                  ),
                ),
                TextButton(
                  onPressed: () { _prepared = false; _toggle(); },
                  child: Text(s.tr('Retry', 'إعادة')),
                ),
              ],
            )
          : StreamBuilder<Duration>(
              stream: _player.positionStream,
              builder: (context, snap) {
                final pos = snap.data ?? Duration.zero;
                final dur = _player.duration ?? Duration.zero;
                final maxMs = dur.inMilliseconds == 0 ? 1.0 : dur.inMilliseconds.toDouble();
                final val = pos.inMilliseconds.clamp(0, maxMs.toInt()).toDouble();
                final caption = _captionFor(pos);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: _loading ? null : _toggle,
                          icon: _loading
                              ? const SizedBox(
                                  width: 18, height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.purple))
                              : Icon(_player.playing ? Icons.pause_circle_rounded : Icons.play_circle_rounded,
                                  color: AppColors.purple, size: 30),
                          tooltip: s.tr('Listen', 'استمع'),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 3,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                                  activeTrackColor: AppColors.purple,
                                ),
                                child: Slider(
                                  value: val,
                                  max: maxMs,
                                  onChanged: dur == Duration.zero
                                      ? null
                                      : (v) => _player.seek(Duration(milliseconds: v.round())),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${_fmt(pos)} / ${_fmt(dur)}',
                                        style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context))),
                                    Flexible(
                                      child: Text(s.tr('AI narration', 'تعليق صوتي بالذكاء الاصطناعي'),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context))),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tooltip(
                          message: s.tr('Playback speed', 'سرعة التشغيل'),
                          child: TextButton(
                            onPressed: _cycleSpeed,
                            style: TextButton.styleFrom(
                              minimumSize: const Size(40, 32),
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                            ),
                            child: Text('${NarrationPrefs.rate.value}×',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.purple)),
                          ),
                        ),
                        Tooltip(
                          message: captionsOn
                              ? s.tr('Hide the words being spoken', 'إخفاء النص المنطوق')
                              : s.tr('Show the words being spoken', 'إظهار النص المنطوق'),
                          child: Semantics(
                            button: true,
                            toggled: captionsOn,
                            label: s.tr('Captions', 'الترجمة النصية'),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(4),
                              onTap: () => NarrationPrefs.setCaptions(!captionsOn),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: captionsOn ? AppColors.purple : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: captionsOn ? AppColors.purple : AppColors.purple.withValues(alpha: 0.45)),
                                ),
                                child: Text('CC',
                                    style: TextStyle(
                                      fontSize: 10,
                                      height: 1.1,
                                      fontWeight: FontWeight.w800,
                                      color: captionsOn ? Colors.white : AppColors.purple,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (caption != null)
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.78),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          caption,
                          textAlign: TextAlign.center,
                          textDirection: widget.language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                          style: const TextStyle(color: Colors.white, fontSize: 13.5, height: 1.4),
                        ),
                      ),
                  ],
                );
              },
            ),
    );
  }
}
