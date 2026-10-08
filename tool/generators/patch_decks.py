import re,sys
D=sys.argv[1]
ROOT='/Users/asaadalsharif/Desktop/VIFM Git/FinPlay/lib/features/education/screens/'

def cls_code(cls, prefix_doc):
    return f'''/// One Learn slide, ported verbatim (EN + AR) from the website's
/// {prefix_doc}. [id] is the website section id: it is what
/// the resume position stores, so it must stay identical to the web.
class {cls} {{
  final String id;
  final String number;
  final String title;
  final String titleAr;
  final List<String> content;
  final List<String> contentAr;
  final List<String> keyPoints;
  final List<String> keyPointsAr;
  final String? highlightType;
  final String? highlight;
  final String? highlightAr;
  final String? examplesTitle;
  final String? examplesTitleAr;
  final List<String> examples;
  final List<String> examplesAr;

  const {cls}({{
    required this.id,
    required this.number,
    required this.title,
    required this.titleAr,
    required this.content,
    required this.contentAr,
    this.keyPoints = const [],
    this.keyPointsAr = const [],
    this.highlightType,
    this.highlight,
    this.highlightAr,
    this.examplesTitle,
    this.examplesTitleAr,
    this.examples = const [],
    this.examplesAr = const [],
  }});

  static bool _has(String? v) => v != null && v.trim().isNotEmpty;
  static bool _hasAll(List<String> v) => v.isNotEmpty && v.every(_has);

  // Arabic when the UI is Arabic and a translation exists, else English.
  String titleFor(bool ar) => ar && _has(titleAr) ? titleAr : title;
  List<String> contentFor(bool ar) => ar && _hasAll(contentAr) ? contentAr : content;
  List<String> keyPointsFor(bool ar) => ar && _hasAll(keyPointsAr) ? keyPointsAr : keyPoints;
  String? highlightFor(bool ar) => ar && _has(highlightAr) ? highlightAr : highlight;
  String? examplesTitleFor(bool ar) => ar && _has(examplesTitleAr) ? examplesTitleAr : examplesTitle;
  List<String> examplesFor(bool ar) => ar && _hasAll(examplesAr) ? examplesAr : examples;
}}
'''

def card_fn(cls, fn):
    return f'''/// Renders one deck slide: number + title, paragraphs, key points, highlight
/// and examples. Scrolls inside the page so long slides never overflow.
Widget {fn}(BuildContext context, {{
  required {cls} slide,
  required int index,
  required int total,
  required bool ar,
  required IconData icon,
  required Color color,
}}) {{
  final dir = ar ? TextDirection.rtl : TextDirection.ltr;
  final align = ar ? TextAlign.right : TextAlign.left;
  final keyPoints = slide.keyPointsFor(ar);
  final highlight = slide.highlightFor(ar);
  final examples = slide.examplesFor(ar);
  final hlIcon = switch (slide.highlightType) {{
    'formula' => Icons.functions_rounded,
    'warning' => Icons.warning_amber_rounded,
    'tip' => Icons.lightbulb_rounded,
    _ => Icons.info_outline_rounded,
  }};
  return GlassCard(
    borderColor: color.withValues(alpha: 0.3),
    padding: const EdgeInsets.all(20),
    child: Directionality(
      textDirection: dir,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: 0.15),
                        ),
                        child: Icon(icon, color: color, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slide.number,
                              textDirection: TextDirection.ltr,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              slide.titleFor(ar),
                              textAlign: align,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...slide.contentFor(ar).map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          p,
                          textAlign: align,
                          style: TextStyle(
                            fontSize: 14.5,
                            height: 1.6,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      )),
                  if (keyPoints.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: color.withValues(alpha: 0.08),
                        border: Border.all(color: color.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle_outline_rounded, size: 16, color: color),
                              const SizedBox(width: 6),
                              Text(
                                ar ? 'النقاط الرئيسية' : 'Key Points',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...keyPoints.map((k) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('•  ', style: TextStyle(color: color, height: 1.5)),
                                    Expanded(
                                      child: Text(
                                        k,
                                        textAlign: align,
                                        style: TextStyle(
                                          fontSize: 13,
                                          height: 1.5,
                                          color: AppColors.textPrimary(context),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                  if (examples.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      slide.examplesTitleFor(ar) ?? (ar ? 'أمثلة' : 'Examples'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...examples.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('•  $e',
                              textAlign: align,
                              style: TextStyle(
                                  fontSize: 13, height: 1.5, color: AppColors.textSecondary(context))),
                        )),
                  ],
                  if (highlight != null && highlight.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.accentLight.withValues(alpha: 0.08),
                        border: Border.all(color: AppColors.accentLight.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(hlIcon, size: 18, color: AppColors.accentLight),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              highlight,
                              textAlign: align,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                fontWeight: slide.highlightType == 'formula'
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (index + 1) / total,
              minHeight: 4,
              backgroundColor: AppColors.borderColor(context),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    ),
  );
}}
'''

BE_STYLE = '''/// Icon + accent color per slide (by website section id; unknown ids cycle).
(IconData, Color) _beSlideStyle(String id, int index) {
  const styles = <String, (IconData, Color)>{
    'section-be-overview': (Icons.balance_rounded, AppColors.primaryLight),
    'section-be-1': (Icons.help_outline_rounded, AppColors.primaryLight),
    'section-be-2': (Icons.lock_rounded, Color(0xFFEF4444)),
    'section-be-3': (Icons.show_chart_rounded, Color(0xFFF59E0B)),
    'section-be-4': (Icons.pie_chart_rounded, AppColors.secondaryLight),
    'section-be-5': (Icons.calculate_rounded, Color(0xFF8B5CF6)),
    'section-be-6': (Icons.insert_chart_rounded, Color(0xFF06B6D4)),
    'section-be-7': (Icons.shield_rounded, AppColors.secondaryLight),
    'section-be-8': (Icons.category_rounded, Color(0xFFEC4899)),
    'section-be-9': (Icons.tune_rounded, Color(0xFFF59E0B)),
    'section-be-assumptions': (Icons.speed_rounded, Color(0xFFEF4444)),
    'section-be-cvp-assumptions': (Icons.rule_rounded, Color(0xFF8B5CF6)),
    'section-be-10': (Icons.emoji_events_rounded, Color(0xFFD97706)),
    'section-be-frameworks': (Icons.public_rounded, AppColors.primaryLight),
    'section-be-framework-bodies': (Icons.school_rounded, Color(0xFF06B6D4)),
  };
  const cycle = [AppColors.primaryLight, AppColors.secondaryLight, Color(0xFFF59E0B), Color(0xFF8B5CF6)];
  return styles[id] ?? (Icons.menu_book_rounded, cycle[index % cycle.length]);
}
'''
CB_STYLE = '''/// Icon + accent color per slide (by website section id; unknown ids cycle).
(IconData, Color) _cbSlideStyle(String id, int index) {
  const styles = <String, (IconData, Color)>{
    'section-cb-overview': (Icons.account_balance_rounded, AppColors.primaryLight),
    'section-cb-1': (Icons.business_center_rounded, AppColors.primaryLight),
    'section-cb-2': (Icons.schedule_rounded, Color(0xFF8B5CF6)),
    'section-cb-3': (Icons.trending_up_rounded, Color(0xFF06B6D4)),
    'section-cb-4': (Icons.attach_money_rounded, AppColors.secondaryLight),
    'section-cb-5': (Icons.percent_rounded, Color(0xFFF59E0B)),
    'section-cb-6': (Icons.timer_rounded, Color(0xFFEF4444)),
    'section-cb-arr': (Icons.bar_chart_rounded, Color(0xFFEC4899)),
    'section-cb-7': (Icons.analytics_rounded, Color(0xFF8B5CF6)),
    'section-cb-8': (Icons.filter_alt_rounded, Color(0xFF06B6D4)),
    'section-cb-9': (Icons.checklist_rounded, AppColors.secondaryLight),
    'section-cb-10': (Icons.lightbulb_rounded, AppColors.accentLight),
    'section-cb-frameworks': (Icons.public_rounded, AppColors.primaryLight),
    'section-cb-framework-bodies': (Icons.school_rounded, Color(0xFF06B6D4)),
  };
  const cycle = [AppColors.primaryLight, AppColors.secondaryLight, Color(0xFFF59E0B), Color(0xFF8B5CF6)];
  return styles[id] ?? (Icons.menu_book_rounded, cycle[index % cycle.length]);
}
'''

IMPORTS = "import '../../../core/services/learn_resume.dart';\n"

def cut_block(s, start_marker, end_regex_from):
    pass

# ---------- Break-even ----------
p=ROOT+'break_even_screen.dart'
s=open(p).read()
be=open(D+'/be.dart').read()
# class
a=s.index('class _LearnSlide {'); b=s.index('}\n',s.index('  });',a))+2
s=s[:a]+cls_code('BreakEvenSlide','break-even-slides-content.ts (BE.1-BE.15)')+s[b:]
# slides list
a=s.index('List<_LearnSlide> _buildSlides(AppStrings s)')
b=s.index('\n];\n',a)+4
s=s[:a]+'// Ported from the website by a generator (tool/generators/gen_decks.ts + patch_decks.py); do not hand-edit.\n'+be+'\n'+BE_STYLE+'\n'+card_fn('BreakEvenSlide','_buildBeSlideCard')+s[b:]
s=s.replace("import '../../../app/i18n/app_strings.dart';\n","import '../../../app/i18n/app_strings.dart';\n"+IMPORTS,1)
# controller
s=s.replace('  final PageController _pageController = PageController();',
 '  PageController _pageController = PageController();\n  // Resume at the last slide viewed (website a2da32f, key \'break-even\').\n  final LearnResumeRecorder _resume =\n      LearnResumeRecorder(LearnResumeStore.breakEvenKey);',1)
s=s.replace('''    _loadScenarios();
  }
''','''    _loadScenarios();
    _restoreSlide();
  }

  /// Reopen the deck at the slide the learner last had on screen.
  Future<void> _restoreSlide() async {
    final saved = await _resume.restore(ref);
    if (!mounted) return;
    final i = LearnResumeStore.indexIn(
        breakEvenSlides.map((sl) => sl.id).toList(), saved);
    if (i != _currentSlide) {
      setState(() {
        _currentSlide = i;
        if (_pageController.hasClients) {
          _pageController.jumpToPage(i);
        } else {
          _pageController.dispose();
          _pageController = PageController(initialPage: i);
        }
      });
    }
    _resume.record(ref, breakEvenSlides[i].id);
  }

  void _onSlideChanged(int i) {
    setState(() => _currentSlide = i);
    _resume.record(ref, breakEvenSlides[i].id);
  }
''',1)
s=s.replace('''    _pageController.dispose();
    super.dispose();''','''    _pageController.dispose();
    _resume.dispose();
    super.dispose();''',1)
s=s.replace('''    final slides = _buildSlides(s);''','''    const slides = breakEvenSlides;''',1)
s=s.replace('''            onPageChanged: (i) => setState(() => _currentSlide = i),
            itemBuilder: (context, i) => _buildSlideCard(slides[i], i),''','''            onPageChanged: _onSlideChanged,
            itemBuilder: (context, i) {
              final st = _beSlideStyle(slides[i].id, i);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: _buildBeSlideCard(context,
                        slide: slides[i],
                        index: i,
                        total: slides.length,
                        ar: s.ar,
                        icon: st.$1,
                        color: st.$2)
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: 0.05),
              );
            },''',1)
s=s.replace('''                                ? slides[_currentSlide].color''','''                                ? _beSlideStyle(slides[_currentSlide].id, _currentSlide).$2''',1)
# remove old _buildSlideCard method
a=s.index('  Widget _buildSlideCard(_LearnSlide slide, int index) {')
b=s.index('  // CALCULATOR TAB')
b=s.rindex('  // ────',0,b)
s=s[:a]+s[b:]
open(p,'w').write(s)

# ---------- Capital budgeting ----------
p=ROOT+'capital_budgeting_screen.dart'
s=open(p).read()
cb=open(D+'/cb.dart').read()
a=s.index('class _SlideData {'); b=s.index('}\n',s.index('  });',a))+2
s=s[:a]+cls_code('CapitalBudgetingSlide','capital-budgeting-slides-content.ts (CB.1-CB.14)')+s[b:]
a=s.index('List<_SlideData> _buildSlides(AppStrings s)')
b=s.index('\n];\n',a)+4
s=s[:a]+'// Ported from the website by a generator (tool/generators/gen_decks.ts + patch_decks.py); do not hand-edit.\n'+cb+'\n'+CB_STYLE+'\n'+card_fn('CapitalBudgetingSlide','_buildCbSlideCard')+s[b:]
s=s.replace("import '../../../app/i18n/app_strings.dart';\n","import '../../../app/i18n/app_strings.dart';\n"+IMPORTS,1)
s=s.replace('''  final PageController _slideController = PageController();
  int _currentSlide = 0;
''','''  PageController _slideController = PageController();
  int _currentSlide = 0;
  // Resume at the last slide viewed (website a2da32f, key 'capital-budgeting').
  final LearnResumeRecorder _resume =
      LearnResumeRecorder(LearnResumeStore.capitalBudgetingKey);

  @override
  void initState() {
    super.initState();
    _restoreSlide();
  }

  /// Reopen the deck at the slide the learner last had on screen.
  Future<void> _restoreSlide() async {
    final saved = await _resume.restore(ref);
    if (!mounted) return;
    final i = LearnResumeStore.indexIn(
        capitalBudgetingSlides.map((sl) => sl.id).toList(), saved);
    if (i != _currentSlide) {
      setState(() {
        _currentSlide = i;
        if (_slideController.hasClients) {
          _slideController.jumpToPage(i);
        } else {
          _slideController.dispose();
          _slideController = PageController(initialPage: i);
        }
      });
    }
    _resume.record(ref, capitalBudgetingSlides[i].id);
  }

  void _onSlideChanged(int i) {
    setState(() => _currentSlide = i);
    _resume.record(ref, capitalBudgetingSlides[i].id);
  }
''',1)
s=s.replace('''    _slideController.dispose();
    super.dispose();''','''    _slideController.dispose();
    _resume.dispose();
    super.dispose();''',1)
s=s.replace('''    final slides = _buildSlides(s);''','''    const slides = capitalBudgetingSlides;''',1)
s=s.replace('''            onPageChanged: (i) => setState(() => _currentSlide = i),
            itemBuilder: (context, index) {
              final slide = slides[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _LearnSlideCard(slide: slide, index: index, total: slides.length),
              );''','''            onPageChanged: _onSlideChanged,
            itemBuilder: (context, index) {
              final st = _cbSlideStyle(slides[index].id, index);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildCbSlideCard(context,
                    slide: slides[index],
                    index: index,
                    total: slides.length,
                    ar: s.ar,
                    icon: st.$1,
                    color: st.$2),
              );''',1)
s=s.replace('''                      ? slides[_currentSlide].color''','''                      ? _cbSlideStyle(slides[_currentSlide].id, _currentSlide).$2''',1)
a=s.index('class _LearnSlideCard extends StatelessWidget {')
b=s.index('// ── Navigation Arrow ──')
s=s[:a]+s[b:]
open(p,'w').write(s)
print('ok')
