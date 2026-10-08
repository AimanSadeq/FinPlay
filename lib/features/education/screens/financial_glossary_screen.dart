import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../app/i18n/app_strings.dart';
import '../../knowledge/data/financial_term.dart';
import '../../knowledge/data/financial_terms_data.dart';

/// The website's Financial Terms Directory (client/src/pages/financial-education.tsx):
/// all 176 terms with their Arabic term, definition, formula, example, importance and
/// tips, following the app language. Data is generated from the website sources into
/// `features/knowledge/data/financial_terms_data.dart`.
///
/// [initialTerm] deep-links to one term (the Knowledge Base's related-term chips pass
/// it as `?term=`); matching follows the website's order (exact, "(ABBR)", substring),
/// falling back to a pre-filled search when nothing matches confidently.
class FinancialGlossaryScreen extends ConsumerStatefulWidget {
  final String? initialTerm;
  const FinancialGlossaryScreen({super.key, this.initialTerm});

  @override
  ConsumerState<FinancialGlossaryScreen> createState() => _FinancialGlossaryScreenState();
}

/// Category order as the website derives it: first appearance in the directory.
final List<String> _categories = () {
  final seen = <String>[];
  for (final t in financialTerms) {
    if (!seen.contains(t.category)) seen.add(t.category);
  }
  return seen;
}();

IconData _categoryIcon(String category) => switch (category) {
      'Financial Statements' => Icons.description_rounded,
      'Balance Sheet Items' => Icons.layers_rounded,
      'Income Statement Items' => Icons.bar_chart_rounded,
      'Profitability Ratios' => Icons.trending_up_rounded,
      'Liquidity Ratios' => Icons.attach_money_rounded,
      'Leverage Ratios' => Icons.balance_rounded,
      'Efficiency Ratios' => Icons.speed_rounded,
      'DuPont Analysis' => Icons.track_changes_rounded,
      'Cash Flow' => Icons.account_balance_wallet_rounded,
      'Valuation' => Icons.show_chart_rounded,
      'Accounting' => Icons.calculate_rounded,
      _ => Icons.menu_book_rounded,
    };

Color _categoryColor(String category) => switch (category) {
      'Financial Statements' => const Color(0xFF2563EB),
      'Balance Sheet Items' => const Color(0xFF0D9488),
      'Income Statement Items' => const Color(0xFFD97706),
      'Profitability Ratios' => const Color(0xFF16A34A),
      'Liquidity Ratios' => const Color(0xFF0891B2),
      'Leverage Ratios' => const Color(0xFFEA580C),
      'Efficiency Ratios' => const Color(0xFF9333EA),
      'DuPont Analysis' => const Color(0xFF4F46E5),
      'Cash Flow' => const Color(0xFF059669),
      'Valuation' => const Color(0xFFE11D48),
      'Accounting' => const Color(0xFF475569),
      _ => AppColors.primaryLight,
    };

class _FinancialGlossaryScreenState extends ConsumerState<FinancialGlossaryScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _searchQuery = '';
  String? _selectedCategory; // null = all
  String? _expandedId;

  @override
  void initState() {
    super.initState();
    final wanted = widget.initialTerm?.trim();
    if (wanted != null && wanted.isNotEmpty) {
      final found = findTermByName(wanted);
      _searchQuery = found?.term ?? wanted;
      _expandedId = found?.id;
      _searchController.text = _searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<FinancialTerm> _filtered(bool ar) {
    final list = financialTerms
        .where((t) => _selectedCategory == null || t.category == _selectedCategory)
        .where((t) => termMatches(t, _searchQuery))
        .toList();
    list.sort((a, b) => ar ? a.arabicTerm.compareTo(b.arabicTerm) : a.term.toLowerCase().compareTo(b.term.toLowerCase()));
    return list;
  }

  /// First letter (in the display language) -> index in the filtered list.
  Map<String, int> _letterIndex(List<FinancialTerm> terms, bool ar) {
    final map = <String, int>{};
    for (var i = 0; i < terms.length; i++) {
      final name = terms[i].termIn(ar);
      if (name.isEmpty) continue;
      map.putIfAbsent(_firstLetter(name, ar), () => i);
    }
    return map;
  }

  static String _firstLetter(String name, bool ar) {
    final c = name.characters.first;
    if (!ar) return c.toUpperCase();
    // Fold the hamza/madda forms of alif into one index entry.
    return const {'أ': 'ا', 'إ': 'ا', 'آ': 'ا'}[c] ?? c;
  }

  void _jumpTo(int idx) {
    // Collapsed cards are roughly 76px high + 8px gap.
    _scrollController.animateTo(
      (idx * 84.0).clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _openRelated(String name) {
    final found = findTermByName(name);
    setState(() {
      _selectedCategory = null;
      _searchQuery = found?.term ?? name;
      _searchController.text = _searchQuery;
      _expandedId = found?.id;
    });
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final ar = s.ar;
    final filtered = _filtered(ar);
    final letterIndex = _letterIndex(filtered, ar);
    final total = financialTerms.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              // ---- Header ----
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const BackButtonIcon(),
                      onPressed: () => context.canPop() ? context.pop() : context.go('/education'),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.menu_book_rounded, size: 20, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(s.tr('Glossary', 'المصطلحات'),
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: Theme.of(context).textTheme.headlineMedium,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ).animate().fadeIn(),

              // ---- Category Chips ----
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  itemCount: _categories.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final cat = i == 0 ? null : _categories[i - 1];
                    final selected = _selectedCategory == cat;
                    final color = cat == null ? AppColors.primary : _categoryColor(cat);
                    return FilterChip(
                      avatar: Icon(
                        cat == null ? Icons.apps_rounded : _categoryIcon(cat),
                        size: 16,
                        color: selected ? Colors.white : color,
                      ),
                      label: Text(
                        cat == null ? s.tr('All', 'الكل') : termCategoryLabel(cat, ar),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : AppColors.textSecondary(context),
                        ),
                      ),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                      selectedColor: color,
                      backgroundColor: color.withValues(alpha: 0.08),
                      side: BorderSide(color: selected ? color : color.withValues(alpha: 0.2)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    );
                  },
                ),
              ).animate().fadeIn(delay: 100.ms),

              // ---- Search Bar ----
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() {
                    _searchQuery = v;
                    _expandedId = null;
                  }),
                  decoration: InputDecoration(
                    hintText: s.tr('Search $total terms (English or Arabic)...',
                        'ابحث في $total مصطلحًا (بالعربية أو الإنجليزية)...'),
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                                _expandedId = null;
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkCard.withValues(alpha: 0.6)
                        : AppColors.primary.withValues(alpha: 0.04),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.purple, width: 1.5),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),

              // ---- Count Badge ----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        s.tr('${filtered.length} of $total terms', '${filtered.length} من $total مصطلحًا'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.auto_awesome, size: 14, color: AppColors.primaryLight),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(s.tr('AI explanations available', 'شروحات الذكاء الاصطناعي متاحة'),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.primaryLight, fontSize: 11)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // ---- Terms List + Letter Sidebar ----
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.search_off_rounded, size: 48, color: AppColors.textTertiary(context)),
                                  const SizedBox(height: 12),
                                  Text(s.tr('No terms found', 'لا توجد مصطلحات'),
                                      style: TextStyle(color: AppColors.textTertiary(context), fontSize: 16)),
                                ],
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 4, 16),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final term = filtered[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _TermCard(
                                    key: ValueKey(term.id),
                                    term: term,
                                    s: s,
                                    expanded: _expandedId == term.id,
                                    onToggle: () => setState(
                                        () => _expandedId = _expandedId == term.id ? null : term.id),
                                    onRelated: _openRelated,
                                  ),
                                ).animate().fadeIn(delay: (30 * (index % 15)).ms);
                              },
                            ),
                    ),
                    if (letterIndex.length > 1)
                      SizedBox(
                        width: 28,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final letters = letterIndex.keys.toList();
                            final itemH = (constraints.maxHeight / letters.length).clamp(12.0, 22.0);
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (final letter in letters)
                                    GestureDetector(
                                      onTap: () => _jumpTo(letterIndex[letter]!),
                                      child: SizedBox(
                                        height: itemH,
                                        width: 28,
                                        child: Center(
                                          child: Text(
                                            letter,
                                            style: TextStyle(
                                              fontSize: itemH > 18 ? 11 : 9,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primaryLight,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Term Card
// ---------------------------------------------------------------------------

class _TermCard extends StatelessWidget {
  final FinancialTerm term;
  final AppStrings s;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<String> onRelated;

  const _TermCard({
    super.key,
    required this.term,
    required this.s,
    required this.expanded,
    required this.onToggle,
    required this.onRelated,
  });

  Widget _heading(BuildContext context, String text, Color color) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Text(text,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.8)),
      );

  @override
  Widget build(BuildContext context) {
    final ar = s.ar;
    final catColor = _categoryColor(term.category);
    final body = TextStyle(fontSize: 13, color: AppColors.textSecondary(context), height: 1.5);
    final formula = term.formulaIn(ar);
    final example = term.exampleIn(ar);
    final importance = term.importanceIn(ar);
    final tips = term.tipsIn(ar);
    final lead = term.termIn(ar);
    final other = term.termIn(!ar);

    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(start: BorderSide(color: catColor, width: 3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GlassCard(
        onTap: onToggle,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [catColor.withValues(alpha: 0.2), catColor.withValues(alpha: 0.08)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Text(
                      lead.isEmpty ? '' : lead.characters.first,
                      style: TextStyle(color: catColor, fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // The app language leads; the other language sits underneath as a reference.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lead,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              )),
                      const SizedBox(height: 2),
                      Text(
                        other,
                        textDirection: ar ? TextDirection.ltr : TextDirection.rtl,
                        style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary(context)),
                      ),
                      if (!expanded) ...[
                        const SizedBox(height: 3),
                        Text(
                          ar ? term.arabicDefinition : term.shortDefinition,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11.5, color: AppColors.textTertiary(context)),
                        ),
                      ],
                    ],
                  ),
                ),
                AiTooltipButton(term: term.term, color: catColor),
                const SizedBox(width: 6),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.expand_more, size: 20, color: AppColors.textTertiary(context)),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsetsDirectional.only(top: 6, start: 46),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _heading(context, s.tr('DEFINITION', 'التعريف'), catColor),
                    Text(term.definitionIn(ar), style: body),
                    if (formula != null) ...[
                      _heading(context, s.tr('FORMULA', 'الصيغة'), catColor),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkCard
                              : const Color(0xFFF0F4FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: catColor.withValues(alpha: 0.2)),
                        ),
                        // The Arabic formula is prose (RTL, normal face); the English one is code-like (LTR, mono).
                        child: term.formulaIsArabic(ar)
                            ? Text(formula, style: TextStyle(fontSize: 13, color: AppColors.textPrimary(context)))
                            : Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(formula,
                                    style: GoogleFonts.jetBrainsMono(
                                        fontSize: 12,
                                        color: AppColors.textPrimary(context),
                                        fontWeight: FontWeight.w500)),
                              ),
                      ),
                    ],
                    if (example != null) ...[
                      _heading(context, s.tr('EXAMPLE', 'مثال'), catColor),
                      Text(example, style: body.copyWith(fontStyle: ar ? FontStyle.normal : FontStyle.italic)),
                    ],
                    if (importance != null) ...[
                      _heading(context, s.tr('WHY IT MATTERS', 'الأهمية'), catColor),
                      Text(importance, style: body),
                    ],
                    if (tips.isNotEmpty) ...[
                      _heading(context, s.tr('KEY TIPS', 'نصائح'), catColor),
                      for (final tip in tips)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Icon(Icons.info_outline_rounded, size: 14, color: AppColors.info),
                              ),
                              const SizedBox(width: 6),
                              Expanded(child: Text(tip, style: body.copyWith(fontSize: 12.5))),
                            ],
                          ),
                        ),
                    ],
                    if (term.relatedTerms.isNotEmpty) ...[
                      _heading(context, s.tr('RELATED TERMS', 'مصطلحات ذات صلة'), catColor),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final rt in term.relatedTerms)
                            InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => onRelated(rt),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: catColor.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: catColor.withValues(alpha: 0.2)),
                                ),
                                child: Text(rt,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(fontSize: 11, color: catColor, fontWeight: FontWeight.w500)),
                              ),
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(termCategoryLabel(term.category, ar),
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: catColor)),
                    ),
                  ],
                ),
              ),
<<<<<<< Updated upstream
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(Icons.expand_more,
                    size: 20, color: AppColors.textTertiary(context)),
              ),
            ],
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 10, left: 46),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.term.definition,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary(context),
                      height: 1.5,
                    ),
                  ),
                  if (widget.term.formula != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkCard
                            : const Color(0xFFF0F4FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: catColor.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer(builder: (context, ref, _) {
                            final s = ref.watch(stringsProvider);
                            return Text(s.tr('FORMULA', 'الصيغة'), style: TextStyle(
                              fontSize: 9, fontWeight: FontWeight.w700,
                              color: catColor, letterSpacing: 1));
                          }),
                          const SizedBox(height: 4),
                          Text(widget.term.formula!,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12, color: AppColors.textPrimary(context),
                              fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                  if (widget.term.example != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb_outline_rounded, size: 14, color: AppColors.accentLight),
                        const SizedBox(width: 6),
                        Expanded(child: Text(widget.term.example!,
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context), height: 1.4, fontStyle: FontStyle.italic))),
                      ],
                    ),
                  ],
                  if (widget.term.tip != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 14, color: AppColors.info),
                        const SizedBox(width: 6),
                        Expanded(child: Text(widget.term.tip!,
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context), height: 1.4))),
                      ],
                    ),
                  ],
                  if (widget.term.relatedTerms != null && widget.term.relatedTerms!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6, runSpacing: 4,
                      children: widget.term.relatedTerms!.map((rt) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: catColor.withValues(alpha: 0.2)),
                        ),
                        child: Text(rt, style: TextStyle(fontSize: 10, color: catColor, fontWeight: FontWeight.w500)),
                      )).toList(),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Consumer(builder: (context, ref, _) {
                      final s = ref.watch(stringsProvider);
                      return Text(
                        _categoryLabel(s, widget.term.category),
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: catColor),
                      );
                    }),
                  ),
                ],
              ),
=======
              crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
>>>>>>> Stashed changes
            ),
          ],
        ),
      ),
    );
  }
}
