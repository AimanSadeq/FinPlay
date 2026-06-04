import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../data/scenario_educational_content.dart';

/// Full-screen educational content for a specific scenario.
/// Mirrors the website's ScenarioEducationModal with 6 collapsible sections.
class ScenarioEducationScreen extends ConsumerWidget {
  final String scenarioId;
  final String scenarioTitle;

  const ScenarioEducationScreen({
    super.key,
    required this.scenarioId,
    required this.scenarioTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final content = getScenarioContent(scenarioId, scenarioTitle);

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkSurface
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          scenarioTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: content == null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.school_outlined, size: 48, color: AppColors.textTertiary(context)),
                  const SizedBox(height: 12),
                  Text(
                    s.tr('No educational content available\nfor this scenario.',
                        'لا يوجد محتوى تعليمي متاح\nلهذا السيناريو.'),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                // 1. Core Framework
                _CollapsibleSection(
                  title: s.tr('1. Core Framework', '1. الإطار الأساسي'),
                  icon: Icons.menu_book_rounded,
                  initiallyExpanded: true,
                  child: _CoreFrameworkSection(data: content.coreFramework),
                ),
                const SizedBox(height: 8),

                // 2. Mechanics & Process
                _CollapsibleSection(
                  title: s.tr('2. Mechanics & Process', '2. الآلية والعملية'),
                  icon: Icons.settings_rounded,
                  child: _MechanicsProcessSection(data: content.mechanicsProcess),
                ),
                const SizedBox(height: 8),

                // 3. Financial Analysis
                _CollapsibleSection(
                  title: s.tr('3. Financial Analysis', '3. التحليل المالي'),
                  icon: Icons.calculate_rounded,
                  child: _FinancialAnalysisSection(data: content.financialAnalysis),
                ),
                const SizedBox(height: 8),

                // 4. Accounting Treatment
                _CollapsibleSection(
                  title: s.tr('4. Accounting Treatment', '4. المعالجة المحاسبية'),
                  icon: Icons.description_rounded,
                  child: _AccountingTreatmentSection(data: content.accountingTreatment),
                ),
                const SizedBox(height: 8),

                // 5. Strategic Considerations
                _CollapsibleSection(
                  title: s.tr('5. Strategic Considerations', '5. الاعتبارات الاستراتيجية'),
                  icon: Icons.gps_fixed_rounded,
                  child: _StrategicConsiderationsSection(data: content.strategicConsiderations),
                ),
                const SizedBox(height: 8),

                // 6. Practical Application
                _CollapsibleSection(
                  title: s.tr('6. Practical Application', '6. التطبيق العملي'),
                  icon: Icons.work_rounded,
                  child: _PracticalApplicationSection(data: content.practicalApplication),
                ),
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Collapsible Section
// ---------------------------------------------------------------------------

class _CollapsibleSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool initiallyExpanded;
  final Widget child;

  const _CollapsibleSection({
    required this.title,
    required this.icon,
    this.initiallyExpanded = false,
    required this.child,
  });

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppColors.borderColor(context).withValues(alpha: 0.2)
              : const Color(0xFFE2E8F0),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: _toggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface.withValues(alpha: 0.5)
                    : const Color(0xFFF8FAFC),
              ),
              child: Row(
                children: [
                  Icon(widget.icon, size: 18, color: AppColors.primaryLight),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: AppColors.textTertiary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section 1: Core Framework
// ---------------------------------------------------------------------------

class _CoreFrameworkSection extends ConsumerWidget {
  final CoreFramework data;
  const _CoreFrameworkSection({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _SectionTitle(s.tr('Definition & Overview', 'التعريف والنظرة العامة')),
        const SizedBox(height: 6),
        _BodyText(data.definitionOverview),
        const SizedBox(height: 14),

        _SectionTitle(s.tr('Key Characteristics', 'الخصائص الرئيسية')),
        const SizedBox(height: 6),
        ...data.keyCharacteristics.map((c) => _BulletItem(c)),

        const SizedBox(height: 14),
        // Advantages & Disadvantages side by side
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _ColoredBox(
                color: const Color(0xFFF0FDF4),
                darkColor: const Color(0xFF052E16),
                title: s.tr('Advantages', 'المزايا'),
                titleColor: const Color(0xFF15803D),
                items: data.advantages.take(5).toList(),
                bulletColor: const Color(0xFF16A34A),
                isCheck: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ColoredBox(
                color: const Color(0xFFFEF2F2),
                darkColor: const Color(0xFF450A0A),
                title: s.tr('Disadvantages', 'العيوب'),
                titleColor: const Color(0xFFDC2626),
                items: data.disadvantages.take(5).toList(),
                bulletColor: const Color(0xFFDC2626),
                isCheck: false,
              ),
            ),
          ],
        ),

        if (data.keyTerminology.isNotEmpty) ...[
          const SizedBox(height: 14),
          _SectionTitle(s.tr('Key Terminology', 'المصطلحات الرئيسية')),
          const SizedBox(height: 6),
          ...data.keyTerminology.take(6).map((t) => _TermItem(term: t.term, definition: t.definition)),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Section 2: Mechanics & Process
// ---------------------------------------------------------------------------

class _MechanicsProcessSection extends ConsumerWidget {
  final MechanicsProcess data;
  const _MechanicsProcessSection({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _SectionTitle(s.tr('How It Works', 'كيف تعمل')),
        const SizedBox(height: 6),
        _BodyText(data.howItWorks),
        const SizedBox(height: 14),

        _SectionTitle(s.tr('Step-by-Step Process', 'العملية خطوة بخطوة')),
        const SizedBox(height: 6),
        ...data.stepByStepProcess.take(10).indexed.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  child: Text(
                    '${e.$1 + 1}.',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryLight),
                  ),
                ),
                Expanded(
                  child: Text(
                    e.$2,
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context), height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(s.tr('Key Parties', 'الأطراف الرئيسية')),
                  const SizedBox(height: 6),
                  ...data.keyPartiesInvolved.take(6).map((p) => _BulletItem(p)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(s.tr('Documentation', 'الوثائق')),
                  const SizedBox(height: 6),
                  ...data.documentationRequired.take(6).map((d) => _BulletItem(d, icon: Icons.description_outlined)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Section 3: Financial Analysis
// ---------------------------------------------------------------------------

class _FinancialAnalysisSection extends ConsumerWidget {
  final FinancialAnalysis data;
  const _FinancialAnalysisSection({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _SectionTitle(s.tr('Valuation & Pricing', 'التقييم والتسعير')),
        const SizedBox(height: 6),
        _BodyText(data.valuationPricing),
        const SizedBox(height: 14),

        _SectionTitle(s.tr('Cost Calculation', 'حساب التكلفة')),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            data.costCalculation,
            style: const TextStyle(fontSize: 12, color: Color(0xFF1E40AF), height: 1.4),
          ),
        ),

        if (data.keyRatios.isNotEmpty) ...[
          const SizedBox(height: 14),
          _SectionTitle(s.tr('Key Ratios', 'النسب الرئيسية')),
          const SizedBox(height: 6),
          _RatiosTable(ratios: data.keyRatios.take(4).toList()),
        ],

        if (data.riskFactors.isNotEmpty) ...[
          const SizedBox(height: 14),
          _SectionTitle(s.tr('Risk Factors', 'عوامل المخاطر')),
          const SizedBox(height: 6),
          ...data.riskFactors.take(6).map(
            (r) => _BulletItem(r, icon: Icons.warning_amber_rounded, iconColor: Colors.orange),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Section 4: Accounting Treatment
// ---------------------------------------------------------------------------

class _AccountingTreatmentSection extends ConsumerWidget {
  final AccountingTreatment data;
  const _AccountingTreatmentSection({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _SectionTitle(s.tr('Recognition & Measurement', 'الإثبات والقياس')),
        const SizedBox(height: 6),
        _BodyText(data.recognitionMeasurement),

        if (data.journalEntries.isNotEmpty) ...[
          const SizedBox(height: 14),
          _SectionTitle(s.tr('Journal Entries', 'قيود اليومية')),
          const SizedBox(height: 6),
          _JournalEntriesTable(entries: data.journalEntries.take(4).toList()),
        ],

        const SizedBox(height: 14),
        _SectionTitle(s.tr('Financial Statement Impact', 'الأثر على القوائم المالية')),
        const SizedBox(height: 6),
        _StatementImpactCards(impact: data.financialStatementImpact),

        const SizedBox(height: 14),
        _SectionTitle(s.tr('IFRS vs. GAAP', 'المعايير الدولية مقابل المبادئ المحاسبية المقبولة')),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFEFCE8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Text(
            data.ifrsVsGaap,
            style: const TextStyle(fontSize: 12, color: Color(0xFF713F12), height: 1.4),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Section 5: Strategic Considerations
// ---------------------------------------------------------------------------

class _StrategicConsiderationsSection extends ConsumerWidget {
  final StrategicConsiderations data;
  const _StrategicConsiderationsSection({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _SectionTitle(s.tr('Decision Criteria', 'معايير القرار')),
        const SizedBox(height: 6),
        ...data.decisionCriteria.map((c) => _BulletItem(c)),

        const SizedBox(height: 14),
        _SectionTitle(s.tr('Comparison with Alternatives', 'المقارنة مع البدائل')),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _BodyText(data.comparisonWithAlternatives),
        ),

        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _ColoredBox(
                color: const Color(0xFFFEF2F2),
                darkColor: const Color(0xFF450A0A),
                title: s.tr('Common Mistakes', 'الأخطاء الشائعة'),
                titleColor: const Color(0xFFDC2626),
                items: data.commonMistakes.take(5).toList(),
                bulletColor: const Color(0xFFDC2626),
                isCheck: false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ColoredBox(
                color: const Color(0xFFF0FDF4),
                darkColor: const Color(0xFF052E16),
                title: s.tr('Best Practices', 'أفضل الممارسات'),
                titleColor: const Color(0xFF15803D),
                items: data.bestPractices.take(5).toList(),
                bulletColor: const Color(0xFF16A34A),
                isCheck: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Section 6: Practical Application
// ---------------------------------------------------------------------------

class _PracticalApplicationSection extends ConsumerWidget {
  final PracticalApplication data;
  const _PracticalApplicationSection({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _SectionTitle(s.tr('Real-World Example', 'مثال من الواقع')),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(8),
            border: const Border(left: BorderSide(color: Color(0xFF3B82F6), width: 3)),
          ),
          child: _BodyText(data.realWorldExample),
        ),

        const SizedBox(height: 14),
        _SectionTitle(s.tr('Calculation Example', 'مثال على الحساب')),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            data.calculationExample,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: AppColors.textSecondary(context),
              height: 1.5,
            ),
          ),
        ),

        const SizedBox(height: 14),
        _SectionTitle(s.tr('Case Study', 'دراسة حالة')),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFEFCE8),
            borderRadius: BorderRadius.circular(8),
            border: const Border(left: BorderSide(color: Color(0xFFF59E0B), width: 3)),
          ),
          child: _BodyText(data.caseStudy),
        ),

        if (data.industryVariations.isNotEmpty) ...[
          const SizedBox(height: 14),
          _SectionTitle(s.tr('Industry Variations', 'الاختلافات حسب القطاع')),
          const SizedBox(height: 6),
          ...data.industryVariations.take(4).map((v) => _BulletItem(v)),
        ],

        if (data.regulatoryConsiderations.isNotEmpty) ...[
          const SizedBox(height: 14),
          _SectionTitle(s.tr('Regulatory Considerations', 'الاعتبارات التنظيمية')),
          const SizedBox(height: 6),
          ...data.regulatoryConsiderations.take(4).map(
            (r) => _BulletItem(r, iconColor: const Color(0xFF7C3AED)),
          ),
        ],
      ],
    );
  }
}

// ===========================================================================
// Shared Widgets
// ===========================================================================

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryLight,
      ),
    );
  }
}

class _BodyText extends StatelessWidget {
  final String text;
  const _BodyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: AppColors.textSecondary(context),
        height: 1.5,
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? iconColor;

  const _BulletItem(this.text, {this.icon, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: icon != null
                ? Icon(icon, size: 12, color: iconColor ?? AppColors.primaryLight)
                : Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: iconColor ?? AppColors.primaryLight,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermItem extends StatelessWidget {
  final String term;
  final String definition;

  const _TermItem({required this.term, required this.definition});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.04)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$term: ',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary(context),
              ),
            ),
            TextSpan(
              text: definition,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColoredBox extends StatelessWidget {
  final Color color;
  final Color darkColor;
  final String title;
  final Color titleColor;
  final List<String> items;
  final Color bulletColor;
  final bool isCheck;

  const _ColoredBox({
    required this.color,
    required this.darkColor,
    required this.title,
    required this.titleColor,
    required this.items,
    required this.bulletColor,
    required this.isCheck,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? darkColor.withValues(alpha: 0.3) : color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: titleColor),
          ),
          const SizedBox(height: 6),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCheck ? '\u2713 ' : '\u2717 ',
                    style: TextStyle(fontSize: 10, color: bulletColor, fontWeight: FontWeight.w700),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 10, color: AppColors.textSecondary(context), height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatiosTable extends ConsumerWidget {
  final List<KeyRatio> ratios;
  const _RatiosTable({required this.ratios});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor(context).withValues(alpha: 0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.2),
          1: FlexColumnWidth(1.5),
          2: FlexColumnWidth(1.5),
        },
        children: [
          // Header
          TableRow(
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF1F5F9),
            ),
            children: [
              _TableCell(text: s.tr('Ratio', 'النسبة'), isHeader: true),
              _TableCell(text: s.tr('Formula', 'المعادلة'), isHeader: true),
              _TableCell(text: s.tr('Interpretation', 'التفسير'), isHeader: true),
            ],
          ),
          // Data rows
          ...ratios.map(
            (r) => TableRow(
              children: [
                _TableCell(text: r.ratio, color: AppColors.primaryLight),
                _TableCell(text: r.formula, isMono: true),
                _TableCell(text: r.interpretation),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final bool isMono;
  final Color? color;

  const _TableCell({required this.text, this.isHeader = false, this.isMono = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        style: isMono
            ? GoogleFonts.jetBrainsMono(
                fontSize: 10,
                color: color ?? AppColors.textSecondary(context),
              )
            : TextStyle(
                fontSize: 10,
                fontWeight: isHeader ? FontWeight.w700 : FontWeight.normal,
                color: color ?? (isHeader ? AppColors.textPrimary(context) : AppColors.textSecondary(context)),
              ),
      ),
    );
  }
}

class _JournalEntriesTable extends ConsumerWidget {
  final List<JournalEntry> entries;
  const _JournalEntriesTable({required this.entries});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor(context).withValues(alpha: 0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1.5),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF1F5F9),
            ),
            children: [
              _TableCell(text: s.tr('Debit', 'مدين'), isHeader: true),
              _TableCell(text: s.tr('Credit', 'دائن'), isHeader: true),
              _TableCell(text: s.tr('Description', 'الوصف'), isHeader: true),
            ],
          ),
          ...entries.map(
            (e) => TableRow(
              children: [
                _TableCell(text: e.debit, isMono: true, color: const Color(0xFF15803D)),
                _TableCell(text: e.credit, isMono: true, color: const Color(0xFFDC2626)),
                _TableCell(text: e.description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatementImpactCards extends ConsumerWidget {
  final FinancialStatementImpact impact;
  const _StatementImpactCards({required this.impact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Column(
      children: [
        _ImpactCard(
          title: s.tr('Balance Sheet', 'قائمة المركز المالي'),
          text: impact.balanceSheet,
          color: const Color(0xFFEFF6FF),
          darkColor: const Color(0xFF1E3A5F),
          titleColor: const Color(0xFF1E40AF),
        ),
        const SizedBox(height: 6),
        _ImpactCard(
          title: s.tr('Income Statement', 'قائمة الدخل'),
          text: impact.incomeStatement,
          color: const Color(0xFFF0FDF4),
          darkColor: const Color(0xFF052E16),
          titleColor: const Color(0xFF15803D),
        ),
        const SizedBox(height: 6),
        _ImpactCard(
          title: s.tr('Cash Flow Statement', 'قائمة التدفقات النقدية'),
          text: impact.cashFlowStatement,
          color: const Color(0xFFFAF5FF),
          darkColor: const Color(0xFF3B0764),
          titleColor: const Color(0xFF7C3AED),
        ),
      ],
    );
  }
}

class _ImpactCard extends StatelessWidget {
  final String title;
  final String text;
  final Color color;
  final Color darkColor;
  final Color titleColor;

  const _ImpactCard({
    required this.title,
    required this.text,
    required this.color,
    required this.darkColor,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? darkColor.withValues(alpha: 0.3) : color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: titleColor)),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary(context), height: 1.4),
          ),
        ],
      ),
    );
  }
}
