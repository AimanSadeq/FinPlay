import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../providers/repository_providers.dart';

/// AI audio-narration player for a single Learn slide (website parity:
/// SlideNarration.tsx). Lazily generates the clip on first Play via
/// POST /narration/prepare, then streams /narration/audio with just_audio.
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
  static const _speeds = [1.0, 1.25, 1.5];
  int _speedIdx = 0;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _ensurePrepared() async {
    if (_prepared) return;
    setState(() { _loading = true; _error = false; });
    try {
      final api = ref.read(apiClientProvider);
      final res = await api.post(ApiEndpoints.narrationPrepare, data: {
        'moduleId': widget.moduleId.toString(),
        'sectionId': widget.sectionId,
        'language': widget.language,
        'text': widget.text,
      });
      final audioUrl = res['audioUrl'] as String?;
      if (audioUrl == null) throw Exception('no audio');
      // audioUrl is rooted at /api; prepend the origin (baseUrl minus /api).
      final base = api.baseUrl;
      final origin = base.endsWith('/api') ? base.substring(0, base.length - 4) : base;
      await _player.setUrl('$origin$audioUrl');
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
      if (dur != null && _player.position >= dur) {
        await _player.seek(Duration.zero);
      }
      await _player.play();
    }
    if (mounted) setState(() {});
  }

  void _cycleSpeed() {
    setState(() => _speedIdx = (_speedIdx + 1) % _speeds.length);
    _player.setSpeed(_speeds[_speedIdx]);
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
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
          : Row(
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
                  child: StreamBuilder<Duration>(
                    stream: _player.positionStream,
                    builder: (context, snap) {
                      final pos = snap.data ?? Duration.zero;
                      final dur = _player.duration ?? Duration.zero;
                      final maxMs = dur.inMilliseconds == 0 ? 1.0 : dur.inMilliseconds.toDouble();
                      final val = pos.inMilliseconds.clamp(0, maxMs.toInt()).toDouble();
                      return Column(
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
                                Text(s.tr('AI narration', 'تعليق صوتي بالذكاء الاصطناعي'),
                                    style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context))),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: _cycleSpeed,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(40, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                  ),
                  child: Text('${_speeds[_speedIdx]}×',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.purple)),
                ),
              ],
            ),
    );
  }
}
