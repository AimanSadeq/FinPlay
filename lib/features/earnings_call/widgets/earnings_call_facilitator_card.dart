import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/repositories/earnings_call_repository.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/glass_card.dart';
import '../earnings_call_admin_api.dart';

/// Facilitator control for the Earnings Call (website parity with
/// components/facilitator/EarningsCallPanel.tsx, minus the projector-only parts).
///
/// Covered here: the stage machine (off → prep → live with the prep countdown),
/// generating the AI analyst questions per team and releasing them, the analyst
/// persona library (add / remove), rendering the lip-synced analyst videos with their
/// per-question status, the peer rating summary, and the facilitator rubric. Only the
/// projector Broadcast View itself stays on the website.
class EarningsCallFacilitatorCard extends ConsumerStatefulWidget {
  const EarningsCallFacilitatorCard({super.key});

  @override
  ConsumerState<EarningsCallFacilitatorCard> createState() =>
      _EarningsCallFacilitatorCardState();
}

class _EarningsCallFacilitatorCardState
    extends ConsumerState<EarningsCallFacilitatorCard> {
  String _stage = 'off';
  int _prepMinutes = 30;
  bool _loading = true;
  bool _busy = false;
  bool _expanded = false;

  /// teamId -> its question set { id, status, questions }
  final Map<String, Map<String, dynamic>> _sets = {};
  List<Map<String, dynamic>> _summary = const [];
  List<Map<String, dynamic>> _personas = const [];
  String? _renderingFor;
  Timer? _poll;

  EarningsCallAdminApi get _admin => EarningsCallAdminApi(ref.read(apiClientProvider));

  EarningsCallRepository get _repo => ref.read(earningsCallRepositoryProvider);

  @override
  void initState() {
    super.initState();
    _load();
    // Website refetch: render status every 20 s while the team list is open.
    _poll = Timer.periodic(const Duration(seconds: 20), (_) {
      if (_expanded && mounted) _loadSets();
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final state = await _repo.status();
      if (!mounted) return;
      setState(() {
        _stage = state['stage']?.toString() ?? 'off';
        _prepMinutes = (state['prepMinutes'] as num?)?.toInt() ?? 30;
        _loading = false;
      });
      await _loadSets();
      await _loadSummary();
      await _loadPersonas();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadPersonas() async {
    try {
      final rows = await _admin.personas();
      if (mounted) setState(() => _personas = rows);
    } catch (_) {}
  }

  Future<void> _loadSets() async {
    try {
      // /videos/status returns the same sets as /questions plus each clip's render
      // status, and reading it advances pending render jobs (website parity).
      List<Map<String, dynamic>> rows;
      try {
        rows = await _admin.videoStatus();
      } catch (_) {
        rows = await _repo.allQuestions();
      }
      if (!mounted) return;
      setState(() {
        _sets
          ..clear()
          ..addEntries(rows
              .where((r) => r['teamId'] != null)
              .map((r) => MapEntry(r['teamId'].toString(), r)));
      });
    } catch (_) {
      // Facilitator password may not be set yet — the list stays empty.
    }
  }

  Future<void> _loadSummary() async {
    try {
      final summary = await _repo.feedbackSummary();
      if (mounted) setState(() => _summary = summary);
    } catch (_) {
      // Optional context.
    }
  }

  Future<void> _setStage(String stage) async {
    final prev = _stage;
    setState(() {
      _stage = stage;
      _busy = true;
    });
    try {
      await _repo.setStage(stage: stage, prepMinutes: _prepMinutes);
      await _load();
    } catch (_) {
      if (mounted) setState(() => _stage = prev);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _generate(String teamId) async {
    setState(() => _busy = true);
    final s = ref.read(stringsProvider);
    try {
      final res = await _admin.generateQuestions(teamId);
      if (res['success'] != true) throw Exception(res['error'] ?? 'Failed');
      await _loadSets();
      _toast(s.tr('Draft questions generated for $teamId',
          'تم إنشاء مسودة الأسئلة لـ $teamId'));
    } catch (e) {
      _toast(e.toString().replaceFirst('Exception: ', ''), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _release(String teamId, bool released) async {
    final set = _sets[teamId];
    if (set == null) return;
    setState(() => _busy = true);
    try {
      await _repo.releaseQuestions(set['id'].toString(), released: released);
      await _loadSets();
    } catch (e) {
      _toast(e.toString().replaceFirst('Exception: ', ''), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _renderVideos(String teamId) async {
    final s = ref.read(stringsProvider);
    setState(() => _renderingFor = teamId);
    try {
      await _admin.renderVideos(teamId);
      await _loadSets();
      _toast(s.tr('Rendering videos for $teamId - clips take 1-3 minutes; status updates below.',
          'جارٍ إنتاج فيديوهات $teamId - يستغرق كل مقطع 1-3 دقائق؛ وتظهر الحالة أدناه.'));
    } catch (e) {
      _toast('${s.tr('Video generation failed', 'تعذّر إنتاج الفيديو')}: ${e.toString().replaceFirst('Exception: ', '')}',
          error: true);
    } finally {
      if (mounted) setState(() => _renderingFor = null);
    }
  }

  Future<void> _deletePersona(Map<String, dynamic> p) async {
    setState(() => _busy = true);
    try {
      await _admin.deletePersona(p['id'].toString());
      await _loadPersonas();
    } catch (e) {
      _toast(e.toString().replaceFirst('Exception: ', ''), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _addPersona() async {
    final s = ref.read(stringsProvider);
    final name = TextEditingController();
    final title = TextEditingController();
    final avatarId = TextEditingController();
    final heygenVoice = TextEditingController();
    final photoUrl = TextEditingController();
    var provider = 'heygen';
    var voice = earningsCallVoices.first.$1;
    String? error;
    var saving = false;
    final added = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) {
          Future<void> save() async {
            if (name.text.trim().isEmpty || title.text.trim().isEmpty || photoUrl.text.trim().isEmpty) {
              setLocal(() => error = s.tr('Name, title, and a photo are required.', 'الاسم والمسمّى والصورة مطلوبة.'));
              return;
            }
            if (provider == 'heygen' && (avatarId.text.trim().isEmpty || heygenVoice.text.trim().isEmpty)) {
              setLocal(() => error = s.tr('HeyGen personas need the avatar ID and voice ID from HeyGen studio.',
                  'شخصيات HeyGen تحتاج معرّف الصورة الرمزية ومعرّف الصوت من استوديو HeyGen.'));
              return;
            }
            setLocal(() { saving = true; error = null; });
            try {
              final photo = await _admin.photoFromUrl(photoUrl.text.trim());
              await _admin.addPersona(
                name: name.text.trim(),
                title: title.text.trim(),
                provider: provider,
                heygenAvatarId: provider == 'heygen' ? avatarId.text.trim() : null,
                voiceId: provider == 'heygen' ? heygenVoice.text.trim() : voice,
                photoDataUrl: photo,
              );
              if (ctx.mounted) Navigator.pop(ctx, true);
            } catch (e) {
              setLocal(() { saving = false; error = e.toString().replaceFirst('Exception: ', ''); });
            }
          }

          return AlertDialog(
            title: Text(s.tr('Add analyst', 'إضافة محلّل')),
            content: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: name, decoration: InputDecoration(isDense: true, labelText: s.tr('Name', 'الاسم'))),
                TextField(
                    controller: title,
                    decoration: InputDecoration(isDense: true, labelText: s.tr('Title (e.g. Senior Analyst, HSBC)', 'المسمّى (مثال: محلّل أول، HSBC)'))),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'heygen', label: Text(s.tr('HeyGen avatar', 'صورة HeyGen'), style: const TextStyle(fontSize: 12))),
                    ButtonSegment(value: 'did', label: Text(s.tr('Animated photo', 'صورة متحرّكة'), style: const TextStyle(fontSize: 12))),
                  ],
                  selected: {provider},
                  showSelectedIcon: false,
                  onSelectionChanged: (v) => setLocal(() => provider = v.first),
                ),
                if (provider == 'heygen') ...[
                  TextField(controller: avatarId, decoration: InputDecoration(isDense: true, labelText: s.tr('HeyGen avatar ID', 'معرّف الصورة الرمزية في HeyGen'))),
                  TextField(controller: heygenVoice, decoration: InputDecoration(isDense: true, labelText: s.tr('HeyGen voice ID', 'معرّف الصوت في HeyGen'))),
                ] else
                  DropdownButtonFormField<String>(
                    initialValue: voice,
                    isExpanded: true,
                    decoration: InputDecoration(isDense: true, labelText: s.tr('Voice', 'الصوت')),
                    items: [for (final v in earningsCallVoices) DropdownMenuItem(value: v.$1, child: Text(v.$2))],
                    onChanged: (v) => setLocal(() => voice = v ?? voice),
                  ),
                TextField(
                  controller: photoUrl,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: s.tr('Photo link (image URL, max 2 MB)', 'رابط الصورة (عنوان صورة، 2 ميغابايت كحد أقصى)'),
                    helperText: s.tr('The app downloads the image and uploads it as the analyst photo.',
                        'ينزّل التطبيق الصورة ويرفعها كصورة للمحلّل.'),
                    helperMaxLines: 2,
                  ),
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(error!, style: const TextStyle(color: AppColors.danger, fontSize: 12)),
                  ),
              ]),
            ),
            actions: [
              TextButton(onPressed: saving ? null : () => Navigator.pop(ctx, false), child: Text(s.tr('Cancel', 'إلغاء'))),
              FilledButton(
                onPressed: saving ? null : save,
                child: Text(saving ? s.tr('Saving…', 'جارٍ الحفظ…') : s.tr('Add Analyst', 'إضافة المحلّل')),
              ),
            ],
          );
        },
      ),
    );
    for (final c in [name, title, avatarId, heygenVoice, photoUrl]) {
      c.dispose();
    }
    if (added == true) {
      _toast(s.tr('Analyst added', 'تمت إضافة المحلّل'));
      await _loadPersonas();
    }
  }

  Widget _personaAvatar(Map<String, dynamic> p) {
    final url = p['photoDataUrl']?.toString() ?? '';
    final comma = url.indexOf(',');
    if (url.startsWith('data:image') && comma > 0) {
      try {
        return CircleAvatar(radius: 16, backgroundImage: MemoryImage(base64Decode(url.substring(comma + 1))));
      } catch (_) {}
    }
    return const CircleAvatar(radius: 16, child: Icon(Icons.person_rounded, size: 16));
  }

  void _toast(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? AppColors.danger : AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.podcasts_rounded,
                  color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.tr('Earnings Call', 'مكالمة الأرباح'),
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    s.tr('Post-Round-2 analyst event',
                        'حدث المحلل بعد السنة الثانية'),
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textTertiary(context)),
                  ),
                ],
              ),
            ),
            if (_loading)
              const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
            else
              IconButton(
                icon: Icon(_expanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded),
                onPressed: () => setState(() => _expanded = !_expanded),
              ),
          ]),
          if (!_loading) ...[
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                    value: 'off',
                    label: Text(s.tr('Off', 'إيقاف'),
                        style: const TextStyle(fontSize: 12))),
                ButtonSegment(
                    value: 'prep',
                    label: Text(s.tr('Prep', 'تحضير'),
                        style: const TextStyle(fontSize: 12))),
                ButtonSegment(
                    value: 'live',
                    label: Text(s.tr('Live', 'مباشر'),
                        style: const TextStyle(fontSize: 12))),
              ],
              selected: {_stage},
              onSelectionChanged: _busy ? null : (sel) => _setStage(sel.first),
              showSelectedIcon: false,
            ),
            const SizedBox(height: 6),
            Text(
              switch (_stage) {
                'prep' => s.tr(
                    'Teams see the playbook, their numbers and a countdown.',
                    'ترى الفرق الدليل وأرقامها والعد التنازلي.'),
                'live' => s.tr(
                    'Released questions are visible; teams rate each other.',
                    'الأسئلة المُفرج عنها ظاهرة؛ وتقيّم الفرق بعضها.'),
                _ => s.tr('The call is dormant for participants.',
                    'المكالمة غير مفعّلة للمشاركين.'),
              },
              style:
                  TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
            ),
            // Prep length only matters when entering prep — it starts the countdown.
            const SizedBox(height: 10),
            Row(
              children: [
                Text(s.tr('Prep minutes', 'دقائق التحضير'),
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textTertiary(context))),
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: _prepMinutes <= 5
                      ? null
                      : () => setState(() => _prepMinutes -= 5),
                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                ),
                Text('$_prepMinutes',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: _prepMinutes >= 180
                      ? null
                      : () => setState(() => _prepMinutes += 5),
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                ),
              ],
            ),
          ],
          if (_expanded && !_loading) ...[
            const Divider(height: 22),
            Row(children: [
              Expanded(
                child: Text(
                  s.tr('Analyst panel (personas for the video questions)', 'لجنة المحلّلين (شخصيات أسئلة الفيديو)'),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textTertiary(context)),
                ),
              ),
              TextButton.icon(
                onPressed: _busy ? null : _addPersona,
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
                label: Text(s.tr('Add', 'إضافة'), style: const TextStyle(fontSize: 12)),
              ),
            ]),
            if (_personas.isEmpty)
              Text(s.tr('No analysts yet - add one to render video questions.', 'لا يوجد محلّلون بعد - أضف واحدًا لإنتاج أسئلة الفيديو.'),
                  style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)))
            else
              Wrap(spacing: 6, runSpacing: 6, children: [
                for (final p in _personas)
                  InputChip(
                    avatar: _personaAvatar(p),
                    label: Text('${p['name']} · ${p['title']}', style: const TextStyle(fontSize: 11)),
                    onDeleted: _busy ? null : () => _deletePersona(p),
                    deleteButtonTooltipMessage: s.tr('Remove ${p['name']}', 'إزالة ${p['name']}'),
                  ),
              ]),
            const Divider(height: 22),
            Text(
              s.tr('Analyst questions per team', 'أسئلة المحلل لكل فريق'),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary(context)),
            ),
            const SizedBox(height: 4),
            ...EarningsCallRepository.teams.map(_teamRow),
            if (_summary.isNotEmpty) ...[
              const Divider(height: 22),
              Text(
                s.tr('Peer ratings (average)', 'تقييمات الفرق (المتوسط)'),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary(context)),
              ),
              const SizedBox(height: 4),
              ..._summary.map((row) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(row['teamId']?.toString() ?? '',
                              style: const TextStyle(fontSize: 13)),
                        ),
                        Text(
                          '${row['overall'] ?? '-'} / 5  ·  ${row['ratings'] ?? 0}',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textTertiary(context)),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ],
      ),
    );
  }

  String _videoLabel(AppStrings s, ({int done, int processing, int failed}) v) {
    final parts = [
      if (v.done > 0) s.tr('${v.done} video ready', '${v.done} فيديو جاهز'),
      if (v.processing > 0) s.tr('${v.processing} rendering…', '${v.processing} قيد الإنتاج…'),
      if (v.failed > 0) s.tr('${v.failed} video failed', '${v.failed} فيديو أخفق'),
    ];
    return parts.isEmpty ? '' : ' · ${parts.join(' · ')}';
  }

  Widget _teamRow(String teamId) {
    final s = ref.read(stringsProvider);
    final set = _sets[teamId];
    final released = set?['status']?.toString() == 'released';
    final count = (set?['questions'] as List?)?.length ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(teamId, style: const TextStyle(fontSize: 13)),
                Text(
                  (set == null
                          ? s.tr('No questions yet', 'لا توجد أسئلة بعد')
                          : released
                              ? s.tr('$count released', 'تم الإفراج عن $count')
                              : s.tr('$count draft', '$count مسودة')) +
                      (set == null ? '' : _videoLabel(s, videoProgress(set))),
                  style: TextStyle(
                      fontSize: 11, color: AppColors.textTertiary(context)),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _busy ? null : () => _generate(teamId),
            child: Text(
              set == null
                  ? s.tr('Generate', 'إنشاء')
                  : s.tr('Regenerate', 'إعادة إنشاء'),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          if (set != null)
            TextButton(
              onPressed: _busy ? null : () => _release(teamId, !released),
              child: Text(
                released ? s.tr('Recall', 'سحب') : s.tr('Release', 'إفراج'),
                style: TextStyle(
                    fontSize: 12,
                    color: released ? AppColors.danger : AppColors.secondary),
              ),
            ),
          if (set != null && _personas.isNotEmpty)
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: s.tr('Render lip-synced analyst videos (run during Prep; ~1-3 min per clip)',
                  'إنتاج فيديوهات المحلّلين (شغّلها أثناء التحضير؛ نحو 1-3 دقائق لكل مقطع)'),
              icon: _renderingFor == teamId
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.smart_display_rounded, size: 18),
              onPressed: (_busy || _renderingFor != null) ? null : () => _renderVideos(teamId),
            ),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: s.tr('Score this team', 'قيّم هذا الفريق'),
            icon: const Icon(Icons.rule_rounded, size: 18),
            onPressed: _busy ? null : () => _openRubric(teamId),
          ),
        ],
      ),
    );
  }

  /// The facilitator rubric — the human evaluation of record for live answers.
  Future<void> _openRubric(String teamId) async {
    final s = ref.read(stringsProvider);
    var explainsWhy = 3;
    var usesNumbers = 3;
    var guidance = 3;
    final comment = TextEditingController();

    final save = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) {
          Widget row(String label, int value, ValueChanged<int> onPick) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (i) {
                          final v = i + 1;
                          return IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints:
                                const BoxConstraints(minWidth: 28, minHeight: 28),
                            onPressed: () => setLocal(() => onPick(v)),
                            icon: Icon(
                              value >= v
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              size: 20,
                              color: value >= v
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFFD1D5DB),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              );

          return AlertDialog(
            title: Text('${s.tr('Rubric', 'معايير التقييم')} — $teamId'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  row(s.tr('Explains why', 'يشرح السبب'), explainsWhy,
                      (v) => explainsWhy = v),
                  row(s.tr('Uses numbers', 'يستخدم الأرقام'), usesNumbers,
                      (v) => usesNumbers = v),
                  row(s.tr('Forward guidance', 'التوجيهات المستقبلية'), guidance,
                      (v) => guidance = v),
                  TextField(
                    controller: comment,
                    maxLength: 500,
                    maxLines: 2,
                    decoration: InputDecoration(
                      counterText: '',
                      isDense: true,
                      hintText: s.tr('Comment (optional)', 'ملاحظة (اختياري)'),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(s.tr('Cancel', 'إلغاء')),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(s.tr('Save', 'حفظ')),
              ),
            ],
          );
        },
      ),
    );

    if (save != true) return;
    final error = await _repo.saveFacilitatorScore(
      teamId: teamId,
      explainsWhy: explainsWhy,
      usesNumbers: usesNumbers,
      guidance: guidance,
      comment: comment.text.trim(),
    );
    _toast(
      error ?? s.tr('Score saved for $teamId', 'تم حفظ التقييم لـ $teamId'),
      error: error != null,
    );
  }
}
