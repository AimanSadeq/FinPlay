import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/locale_provider.dart';

/// Lightweight localization layer. Screens read `ref.watch(stringsProvider)`
/// and use the named getters; each returns Arabic or English based on the
/// current locale. RTL layout is handled automatically by MaterialApp's
/// `locale` + GlobalMaterialLocalizations, so only the text needs translating.
///
/// This is the foundation for full i18n — add keys here and reference them from
/// screens as they are localized.
class AppStrings {
  final bool ar;
  const AppStrings(this.ar);

  /// Public translate helper so per-feature string extensions (in separate
  /// files) can add localized getters without touching this file:
  ///   extension AuthStrings on AppStrings { String get signIn => tr('Sign In','تسجيل الدخول'); }
  String tr(String en, String arText) => ar ? arText : en;

  String _t(String en, String arText) => tr(en, arText);

  // ── Common ──
  String get appTagline => _t('Interactive Finance Simulation', 'محاكاة مالية تفاعلية');
  String get back => _t('Back', 'رجوع');
  String get next => _t('Next', 'التالي');
  String get learn => _t('Learn', 'تعلّم');
  String get start => _t('Start', 'ابدأ');
  String get login => _t('Sign In', 'تسجيل الدخول');
  String get logout => _t('Logout', 'تسجيل الخروج');
  String get loading => _t('Loading…', 'جارٍ التحميل…');

  // ── Mode selector / onboarding ──
  String get choosePath => _t('Choose Your Path', 'اختر مسارك');
  String get choosePathSubtitle =>
      _t('Swipe to explore your learning mode', 'اسحب لاستكشاف نمط التعلّم');
  String get selfPaced => _t('Self-Paced', 'التعلّم الذاتي');
  String get selfPacedTagline => _t('Your Journey, Your Speed', 'رحلتك، بسرعتك');
  String get corporate => _t('Corporate', 'الشركات');
  String get corporateTagline => _t('Team-based workshop', 'ورشة عمل جماعية');
  String get alwaysOpen => _t('ALWAYS OPEN', 'متاح دائمًا');
  String get startLearning => _t('Start Learning', 'ابدأ التعلّم');
  String get enterSimulation => _t('Enter Simulation', 'ادخل المحاكاة');
  String get personalAccountLogin => _t('Personal account login', 'تسجيل دخول حساب شخصي');
  String get learnAtOwnPace => _t('Learn at your own pace', 'تعلّم بالسرعة التي تناسبك');
  String get interactiveExercises => _t('Interactive exercises', 'تمارين تفاعلية');
  String get trackProgress => _t('Track your progress', 'تابع تقدّمك');

  // ── Workshop locked sheet ──
  String get workshopNotAvailable => _t('Workshop Not Available', 'الورشة غير متاحة');
  String get workshopLockedBody => _t(
        'Contact your facilitator to enable Corporate Mode and join a team workshop.',
        'تواصل مع الميسّر لتفعيل وضع الشركات والانضمام إلى ورشة جماعية.',
      );
  String get trySelfPacedInstead => _t('Try Self-Paced Instead', 'جرّب التعلّم الذاتي بدلاً من ذلك');
}

final stringsProvider = Provider<AppStrings>((ref) {
  return AppStrings(ref.watch(isArabicProvider));
});
