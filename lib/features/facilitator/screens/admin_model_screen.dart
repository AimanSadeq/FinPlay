import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../app/i18n/app_strings.dart';

/// Facilitator model editor — edits assumptions, scenarios, baseline and
/// branding behind a password gate. Mirrors the website's /admin/model page.
class AdminModelScreen extends ConsumerStatefulWidget {
  const AdminModelScreen({super.key});

  @override
  ConsumerState<AdminModelScreen> createState() => _AdminModelScreenState();
}

class _AdminModelScreenState extends ConsumerState<AdminModelScreen> {
  final _passwordController = TextEditingController();
  String? _password; // unlocked password
  int _tab = 0;

  bool _loading = false;
  String? _status;
  bool _statusError = false;

  // Loaded data
  List<Map<String, dynamic>> _assumptions = [];
  List<Map<String, dynamic>> _baseline = [];
  List<Map<String, dynamic>> _scenarios = [];
  Map<String, String> _branding = {
    'titleEn': '',
    'titleAr': '',
    'clientName': ''
  };

  // Edits keyed by a synthetic id
  final Map<String, num> _assumptionEdits = {};
  final Map<String, num> _baselineEdits = {};

  static const _tabs = ['Assumptions', 'Scenarios', 'Baseline', 'Branding', 'Shocks'];

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Options _authOptions() =>
      Options(headers: {'x-facilitator-password': _password});

  Dio get _dio => ref.read(apiClientProvider).dio;

  Future<void> _unlock() async {
    final pw = _passwordController.text.trim();
    if (pw.isEmpty) return;
    setState(() {
      _password = pw;
      _loading = true;
      _status = null;
    });
    await _loadActiveTab();
  }

  Future<void> _loadActiveTab() async {
    setState(() {
      _loading = true;
      _status = null;
    });
    try {
      switch (_tab) {
        case 0:
          final r = await _dio.get(ApiEndpoints.modelAssumptions,
              options: _authOptions());
          _assumptions = _asList(r.data, 'assumptions');
          break;
        case 1:
          final r = await _dio.get(ApiEndpoints.modelScenarios,
              options: _authOptions());
          _scenarios = _asList(r.data, 'scenarios');
          break;
        case 2:
          final r = await _dio.get(ApiEndpoints.modelBaseline,
              options: _authOptions());
          _baseline = _asList(r.data, 'baseline');
          break;
        case 3:
          final r = await _dio.get(ApiEndpoints.modelBranding,
              options: _authOptions());
          final b = (r.data is Map ? r.data['branding'] : null) as Map?;
          if (b != null) {
            _branding = {
              'titleEn': '${b['titleEn'] ?? ''}',
              'titleAr': '${b['titleAr'] ?? ''}',
              'clientName': '${b['clientName'] ?? ''}',
            };
          }
          break;
      }
      if (mounted) setState(() => _loading = false);
    } on DioException catch (e) {
      if (!mounted) return;
      final s = ref.read(stringsProvider);
      final code = e.response?.statusCode;
      setState(() {
        _loading = false;
        _statusError = true;
        _status = code == 401 || code == 403
            ? s.tr('Incorrect facilitator password.', 'كلمة مرور الميسّر غير صحيحة.')
            : s.tr('Could not reach the model server. Editing is offline-only here.',
                'تعذّر الوصول إلى خادم النموذج. التحرير متاح دون اتصال فقط هنا.');
      });
    } catch (_) {
      if (mounted) {
        final s = ref.read(stringsProvider);
        setState(() {
          _loading = false;
          _statusError = true;
          _status = s.tr('Could not load model data.', 'تعذّر تحميل بيانات النموذج.');
        });
      }
    }
  }

  List<Map<String, dynamic>> _asList(dynamic data, String key) {
    if (data is Map && data[key] is List) {
      return (data[key] as List)
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return [];
  }

  Future<void> _save() async {
    setState(() {
      _loading = true;
      _status = null;
    });
    try {
      dynamic body;
      String path;
      switch (_tab) {
        case 0:
          path = ApiEndpoints.modelAssumptions;
          body = {
            'updates': _assumptionEdits.entries.map((e) {
              final parts = e.key.split('|');
              return {
                'round': int.tryParse(parts[0]) ?? 1,
                'paramKey': parts.length > 1 ? parts[1] : '',
                'value': e.value,
              };
            }).toList(),
          };
          break;
        case 2:
          path = ApiEndpoints.modelBaseline;
          body = {
            'updates': _baselineEdits.entries
                .map((e) => {'cell': e.key, 'value': e.value})
                .toList(),
          };
          break;
        case 3:
          path = ApiEndpoints.modelBranding;
          body = _branding;
          break;
        default:
          setState(() {
            _loading = false;
            _status = ref.read(stringsProvider).tr(
                'Scenario editing is read-only in this build.',
                'تحرير السيناريوهات للقراءة فقط في هذه النسخة.');
          });
          return;
      }
      final r = await _dio.post(path, data: body, options: _authOptions());
      final applied = (r.data is Map ? r.data['applied'] : null) ?? 0;
      if (mounted) {
        final s = ref.read(stringsProvider);
        setState(() {
          _loading = false;
          _statusError = false;
          _status = s.tr('✅ Saved — $applied value(s) updated',
              '✅ تم الحفظ — تم تحديث $applied قيمة');
          _assumptionEdits.clear();
          _baselineEdits.clear();
        });
      }
    } catch (_) {
      if (mounted) {
        final s = ref.read(stringsProvider);
        setState(() {
          _loading = false;
          _statusError = true;
          _status = s.tr('Save failed — the model server is not reachable.',
              'فشل الحفظ — خادم النموذج غير متاح.');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: _password == null ? _buildGate() : _buildEditor(),
        ),
      ),
    );
  }

  Widget _buildGate() {
    final s = ref.watch(stringsProvider);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.admin_panel_settings_rounded,
                  size: 40, color: AppColors.primaryLight),
              const SizedBox(height: 12),
              Text(s.tr('Model Editor', 'محرّر النموذج'),
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(s.tr('Facilitator password required', 'كلمة مرور الميسّر مطلوبة'),
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textTertiary(context))),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                onSubmitted: (_) => _unlock(),
                decoration: InputDecoration(
                  labelText: s.tr('Password', 'كلمة المرور'),
                  prefixIcon: const Icon(Icons.lock_rounded, size: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              GradientButton(
                text: s.tr('Unlock', 'فتح'),
                icon: Icons.lock_open_rounded,
                width: double.infinity,
                onPressed: _unlock,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(s.tr('Cancel', 'إلغاء')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditor() {
    final s = ref.watch(stringsProvider);
    final tabLabels = [
      s.tr('Assumptions', 'الافتراضات'),
      s.tr('Scenarios', 'السيناريوهات'),
      s.tr('Baseline', 'الأساس'),
      s.tr('Branding', 'الهوية'),
      s.tr('Shocks', 'الصدمات'),
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => context.pop()),
              const Spacer(),
              Text(s.tr('Model Editor', 'محرّر النموذج'),
                  style: Theme.of(context).textTheme.headlineMedium),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Tabs
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _tabs.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final active = i == _tab;
              return GestureDetector(
                onTap: () {
                  setState(() => _tab = i);
                  _loadActiveTab();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primaryLight.withValues(alpha: 0.15)
                        : AppColors.cardColor(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: active
                            ? AppColors.primaryLight.withValues(alpha: 0.5)
                            : AppColors.borderColor(context)),
                  ),
                  child: Text(tabLabels[i],
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: active
                              ? AppColors.primaryLight
                              : AppColors.textSecondary(context))),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        if (_status != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (_statusError
                        ? AppColors.dangerLight
                        : AppColors.secondaryLight)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(_status!,
                  style: TextStyle(
                      fontSize: 12.5,
                      color: _statusError
                          ? AppColors.dangerLight
                          : AppColors.secondaryLight)),
            ),
          ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _buildTabBody(),
        ),
        // Save bar (hidden for read-only tabs: Scenarios, Shocks)
        if (_tab != 1 && _tab != 4)
          Padding(
            padding: const EdgeInsets.all(16),
            child: GradientButton(
              text: s.tr('Save Changes', 'حفظ التغييرات'),
              icon: Icons.save_rounded,
              width: double.infinity,
              isLoading: _loading,
              onPressed: _save,
            ),
          ),
      ],
    );
  }

  Widget _buildTabBody() {
    switch (_tab) {
      case 0:
        return _numericList(_assumptions, _assumptionEdits, keyBuilder: (m) {
          return '${m['round'] ?? 1}|${m['paramKey'] ?? ''}';
        }, labelBuilder: (m) {
          return '${m['label'] ?? m['paramKey'] ?? '—'}  (R${m['round'] ?? '?'})';
        });
      case 1:
        return _scenarioList();
      case 2:
        return _numericList(_baseline, _baselineEdits,
            keyBuilder: (m) => '${m['cell'] ?? ''}',
            labelBuilder: (m) =>
                '${m['label'] ?? m['cell'] ?? '—'}  (${m['cell'] ?? ''})');
      case 3:
        return _brandingForm();
      case 4:
        return _shocksInfo();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _shocksInfo() {
    final s = ref.watch(stringsProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.flash_on_rounded, color: AppColors.dangerLight, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(s.tr('Market Shocks', 'صدمات السوق'),
                    style: Theme.of(context).textTheme.titleMedium)),
              ]),
              const SizedBox(height: 8),
              Text(
                s.tr(
                  'Market shocks are managed live from the Facilitator Panel → Shocks tab. There you can trigger predefined shocks, build custom shocks, review active shocks, and clear them.',
                  'تُدار صدمات السوق مباشرة من لوحة الميسّر ← تبويب الصدمات. هناك يمكنك تفعيل الصدمات المعرّفة مسبقًا، وإنشاء صدمات مخصّصة، ومراجعة الصدمات النشطة، ومسحها.',
                ),
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary(context), height: 1.5),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/facilitator'),
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: Text(s.tr('Open Facilitator Panel', 'فتح لوحة الميسّر')),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _numericList(
    List<Map<String, dynamic>> rows,
    Map<String, num> edits, {
    required String Function(Map<String, dynamic>) keyBuilder,
    required String Function(Map<String, dynamic>) labelBuilder,
  }) {
    if (rows.isEmpty) {
      return _emptyState(ref.read(stringsProvider)
          .tr('No data loaded for this section.', 'لم يتم تحميل بيانات لهذا القسم.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: rows.length,
      itemBuilder: (context, i) {
        final m = rows[i];
        final id = keyBuilder(m);
        final current = edits[id] ?? (m['value'] as num? ?? 0);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(labelBuilder(m),
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: '$current',
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.jetBrainsMono(fontSize: 13),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: (v) {
                    final num? parsed = num.tryParse(v);
                    if (parsed != null) edits[id] = parsed;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _scenarioList() {
    if (_scenarios.isEmpty) {
      return _emptyState(ref.read(stringsProvider)
          .tr('No scenarios loaded for this section.', 'لم يتم تحميل سيناريوهات لهذا القسم.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: _scenarios.length,
      itemBuilder: (context, i) {
        final m = _scenarios[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${m['module'] ?? ''} · R${m['round'] ?? ''} · #${m['scenarioId'] ?? ''}',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary(context))),
                const SizedBox(height: 4),
                Text('${m['title'] ?? '—'}',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                if (m['type'] != null)
                  Text('${ref.read(stringsProvider).tr('Type: ', 'النوع: ')}${m['type']}',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary(context))),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _brandingForm() {
    final s = ref.watch(stringsProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        _brandingField(s.tr('Course Title (EN)', 'عنوان الدورة (إنجليزي)'), 'titleEn'),
        const SizedBox(height: 14),
        _brandingField(s.tr('Course Title (AR)', 'عنوان الدورة (عربي)'), 'titleAr'),
        const SizedBox(height: 14),
        _brandingField(s.tr('Client Name', 'اسم العميل'), 'clientName'),
      ],
    );
  }

  Widget _brandingField(String label, String key) {
    return TextFormField(
      initialValue: _branding[key],
      onChanged: (v) => _branding[key] = v,
      decoration: InputDecoration(
        labelText: label,
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _emptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 36, color: AppColors.textTertiary(context)),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textTertiary(context))),
          ],
        ),
      ),
    ).animate().fadeIn();
  }
}
