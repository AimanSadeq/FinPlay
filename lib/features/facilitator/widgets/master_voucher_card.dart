import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/repositories/facilitator_repository.dart';
import '../../../shared/widgets/glass_card.dart';

/// Label for the master voucher's action button (website VouchersAdmin).
String masterVoucherActionLabel(AppStrings s, {required bool hasCode, required bool hasInput}) {
  if (hasInput) {
    return hasCode
        ? s.tr('Replace with custom code', 'استبدال برمز مخصّص')
        : s.tr('Set custom code', 'تعيين رمز مخصّص');
  }
  return hasCode
      ? s.tr('Rotate (generate new)', 'تدوير (إنشاء رمز جديد)')
      : s.tr('Generate master voucher', 'إنشاء القسيمة الرئيسية');
}

/// Master voucher (all-access): one standing secret code that opens both the self-paced
/// sign-up gate and the corporate workshop access-code gate without using up any voucher
/// slots (GET/POST /vouchers/master; website db0eb0e).
class MasterVoucherCard extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  const MasterVoucherCard({super.key, required this.repo});

  @override
  ConsumerState<MasterVoucherCard> createState() => _MasterVoucherCardState();
}

class _MasterVoucherCardState extends ConsumerState<MasterVoucherCard> {
  String? _code;
  bool _loading = true;
  bool _busy = false;
  String? _error;
  final _input = TextEditingController();

  @override
  void initState() {
    super.initState();
    _input.addListener(() => setState(() {}));
    _load();
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final code = await widget.repo.fetchMasterVoucher();
      if (mounted) setState(() { _code = code; _loading = false; });
    } catch (_) {
      // The website also renders the card without a code when the read fails.
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save({bool clear = false}) async {
    final s = ref.read(stringsProvider);
    setState(() { _busy = true; _error = null; });
    try {
      final code = await widget.repo.setMasterVoucher(code: clear ? null : _input.text, clear: clear);
      if (mounted) setState(() { _code = code; _input.clear(); });
    } catch (e) {
      if (mounted) {
        setState(() => _error = e is FacilitatorActionException
            ? e.message
            : s.tr('Could not update the master voucher.', 'تعذّر تحديث القسيمة الرئيسية.'));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final typed = _input.text.trim();
    final tooShort = typed.isNotEmpty && typed.length < 6;
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.key_rounded, color: AppColors.accentLight, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(s.tr('Master voucher (all-access)', 'القسيمة الرئيسية (وصول كامل)'),
                style: Theme.of(context).textTheme.titleMedium),
          ),
        ]),
        const SizedBox(height: 4),
        Text(
          s.tr(
            'One standing secret code that opens both the self-paced sign-up gate and the corporate workshop access-code gate, without using up any voucher slots. Share it only with people who should have full access; rotate or clear it any time.',
            'رمز سرّي دائم واحد يفتح بوابة التسجيل في التعلّم الذاتي وبوابة رمز الدخول لورش الشركات معًا، دون استهلاك أي من استخدامات القسائم. شاركه فقط مع من يجب أن يحصل على وصول كامل، ويمكنك تدويره أو إزالته في أي وقت.',
          ),
          style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
        ),
        const SizedBox(height: 10),
        if (_loading)
          const LinearProgressIndicator(minHeight: 2)
        else if (_code != null)
          Wrap(spacing: 8, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
            SelectableText(_code!,
                style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.accentLight)),
            OutlinedButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: _code!));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(s.tr('Copied', 'تم النسخ'))));
                }
              },
              icon: const Icon(Icons.copy_rounded, size: 14),
              label: Text(s.tr('Copy', 'نسخ'), style: const TextStyle(fontSize: 12)),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.dangerLight),
              onPressed: _busy ? null : () => _save(clear: true),
              icon: const Icon(Icons.delete_outline_rounded, size: 14),
              label: Text(s.tr('Clear', 'إزالة'), style: const TextStyle(fontSize: 12)),
            ),
          ])
        else
          Text(s.tr('No master voucher is set.', 'لا توجد قسيمة رئيسية.'),
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.accentLight)),
        const SizedBox(height: 10),
        TextField(
          controller: _input,
          autocorrect: false,
          maxLength: 64,
          style: GoogleFonts.jetBrainsMono(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            hintText: s.tr('Custom code (optional, min 6 chars)', 'رمز مخصّص (اختياري، 6 أحرف على الأقل)'),
            errorText: tooShort ? s.tr('At least 6 characters', '6 أحرف على الأقل') : null,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
            onPressed: (_busy || tooShort) ? null : () => _save(),
            icon: _busy
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.confirmation_number_rounded, size: 16),
            label: Text(masterVoucherActionLabel(s, hasCode: _code != null, hasInput: typed.isNotEmpty)),
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(_error!, style: const TextStyle(fontSize: 12, color: AppColors.dangerLight)),
          ),
      ]),
    );
  }
}
