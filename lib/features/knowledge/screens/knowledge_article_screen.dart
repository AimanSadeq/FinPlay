import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../data/kb_models.dart';
import '../data/kb_repository.dart';
import 'knowledge_base_screen.dart';

/// Glossary route; a `term` query parameter opens that term (see the glossary screen).
const String _glossaryRoute = '/education/glossary';

const _indigo = Color(0xFF4F46E5);
const _amber = Color(0xFFD97706);
const _blue = Color(0xFF2563EB);

/// Knowledge Base article (website parity: client/src/pages/knowledge-article.tsx):
/// definition, formal treatment, worked examples (tables/formulas), pitfalls,
/// standards anchors, related terms/modules/articles and APA references.
class KnowledgeArticleScreen extends ConsumerWidget {
  final String articleId;
  const KnowledgeArticleScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final ar = s.ar;
    final article = kbArticleById(articleId);

    void back() => context.canPop() ? context.pop() : context.go('/knowledge');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: article == null
              ? _NotFound(onBack: back, s: s)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton.icon(
                        onPressed: back,
                        icon: const BackButtonIcon(),
                        label: Text(s.tr('Knowledge Base', 'قاعدة المعرفة')),
                      ),
                    ),
                    _TitleBlock(article: article, s: s),
                    const SizedBox(height: 16),
                    GlassCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final section in article.sections) _SectionBlock(section: section, arabic: ar),
                          if (article.pitfalls.isNotEmpty) _Pitfalls(article: article, s: s),
                        ],
                      ),
                    ),
                    if (article.standards.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _Standards(article: article, s: s),
                    ],
                    const SizedBox(height: 16),
                    _Related(article: article, s: s),
                    if (article.references.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _References(article: article, s: s),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  final VoidCallback onBack;
  final AppStrings s;
  const _NotFound({required this.onBack, required this.s});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_library_outlined, size: 48, color: AppColors.textTertiary(context)),
          const SizedBox(height: 12),
          Text(s.tr('Article not found', 'المقالة غير موجودة'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: onBack,
            child: Text(s.tr('Back to the Knowledge Base', 'العودة إلى قاعدة المعرفة')),
          ),
        ],
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  final KBArticle article;
  final AppStrings s;
  const _TitleBlock({required this.article, required this.s});

  @override
  Widget build(BuildContext context) {
    final ar = s.ar;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            KBBadge(text: kbCategoryLabel(article.category).of(ar), color: _indigo, icon: Icons.bookmarks_rounded),
            KBBadge(
              text: kbLevelLabels[article.level]!.of(ar),
              color: AppColors.textSecondary(context),
              icon: Icons.school_rounded,
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.schedule_rounded, size: 14, color: AppColors.textTertiary(context)),
              const SizedBox(width: 4),
              Text('${article.readingMinutes} ${s.tr('min read', 'دقيقة قراءة')}',
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
            ]),
          ],
        ),
        const SizedBox(height: 10),
        Text(article.title.of(ar),
            style: TextStyle(
              fontSize: 24,
              height: 1.25,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary(context),
            )),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsetsDirectional.only(start: 12),
          decoration: BoxDecoration(
            border: BorderDirectional(start: BorderSide(color: _indigo.withValues(alpha: 0.35), width: 4)),
          ),
          child: Text(article.summary.of(ar),
              style: TextStyle(fontSize: 14.5, height: 1.5, color: AppColors.textSecondary(context))),
        ),
      ],
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final KBSection section;
  final bool arabic;
  const _SectionBlock({required this.section, required this.arabic});

  @override
  Widget build(BuildContext context) {
    final body = TextStyle(fontSize: 15, height: 1.6, color: AppColors.textSecondary(context));
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.heading.of(arabic),
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: AppColors.textPrimary(context))),
          const SizedBox(height: 10),
          for (final p in section.paragraphs)
            Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(p.of(arabic), style: body)),
          for (final b in section.bullets)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 8, bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: body),
                  Expanded(child: Text(b.of(arabic), style: body)),
                ],
              ),
            ),
          for (final f in section.formulas) _FormulaBox(formula: f, arabic: arabic),
          if (section.table != null) _KBTableView(table: section.table!, arabic: arabic),
        ],
      ),
    );
  }
}

class _FormulaBox extends StatelessWidget {
  final KBFormula formula;
  final bool arabic;
  const _FormulaBox({required this.formula, required this.arabic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // Formulas always render LTR, even in Arabic mode.
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: _indigo.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _indigo.withValues(alpha: 0.18)),
              ),
              child: Text(
                formula.formula,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 15,
                  height: 1.45,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ),
          ),
          if (formula.caption != null) ...[
            const SizedBox(height: 6),
            Text(formula.caption!.of(arabic),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, height: 1.4, color: AppColors.textTertiary(context))),
          ],
        ],
      ),
    );
  }
}

class _KBTableView extends StatelessWidget {
  final KBTable table;
  final bool arabic;
  const _KBTableView({required this.table, required this.arabic});

  @override
  Widget build(BuildContext context) {
    final cols = table.headers.length;
    final border = AppColors.borderColor(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: LayoutBuilder(builder: (context, constraints) {
        // Fit the screen when the columns can stay readable; otherwise scroll sideways.
        final colWidth = math.max(130.0, (constraints.maxWidth - 2) / math.max(cols, 1));
        Widget cell(String text, {bool header = false}) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(text,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    fontWeight: header ? FontWeight.w700 : FontWeight.w400,
                    color: header ? AppColors.textPrimary(context) : AppColors.textSecondary(context),
                  )),
            );
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: border), borderRadius: BorderRadius.circular(10)),
              child: Table(
                defaultColumnWidth: FixedColumnWidth(colWidth),
                border: TableBorder(horizontalInside: BorderSide(color: border.withValues(alpha: 0.6))),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: AppColors.cardColor(context)),
                    children: [for (final h in table.headers) cell(h.of(arabic), header: true)],
                  ),
                  for (final row in table.rows)
                    TableRow(children: [
                      for (var i = 0; i < cols; i++) cell(i < row.length ? row[i].of(arabic) : ''),
                    ]),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _Pitfalls extends StatelessWidget {
  final KBArticle article;
  final AppStrings s;
  const _Pitfalls({required this.article, required this.s});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(Icons.warning_amber_rounded, color: _amber, size: 22),
          const SizedBox(width: 8),
          Text(s.tr('Common pitfalls', 'أخطاء شائعة'),
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: AppColors.textPrimary(context))),
        ]),
        const SizedBox(height: 10),
        for (final p in article.pitfalls)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: _amber.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _amber.withValues(alpha: 0.3)),
            ),
            child: Text(p.of(s.ar),
                style: TextStyle(fontSize: 14, height: 1.5, color: AppColors.textPrimary(context))),
          ),
      ],
    );
  }
}

Future<void> _openExternal(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

/// A standards anchor chip: each identifier with a confirmed landing page opens the
/// issuing body's page; section pointers and separators stay plain text.
class KBStandardAnchor extends StatelessWidget {
  final KBStandardRef standard;
  final bool arabic;
  const KBStandardAnchor({super.key, required this.standard, required this.arabic});

  String _tooltip(KBStandardSegment seg) {
    final name = seg.text.trim();
    final host = Uri.parse(seg.href!).host;
    if (seg.viaIndex) {
      return arabic ? '$name: قائمة إصدارات المجلس على $host' : '$name: pronouncements list on $host';
    }
    return arabic ? '$name على $host' : '$name on $host';
  }

  @override
  Widget build(BuildContext context) {
    final hasLink = standard.segments.any((g) => g.href != null);
    const style = TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E40AF));
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: _blue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: _blue.withValues(alpha: 0.3)),
        ),
        child: Text.rich(
          TextSpan(children: [
            for (final seg in standard.segments)
              seg.href == null
                  ? TextSpan(text: seg.text, style: style)
                  : WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: Tooltip(
                        message: _tooltip(seg),
                        child: GestureDetector(
                          onTap: () => _openExternal(seg.href!),
                          child: Text(
                            seg.text,
                            style: style.copyWith(
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.dotted,
                            ),
                          ),
                        ),
                      ),
                    ),
            if (hasLink)
              const WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.open_in_new_rounded, size: 12, color: Color(0xFF1E40AF)),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

class _Standards extends StatelessWidget {
  final KBArticle article;
  final AppStrings s;
  const _Standards({required this.article, required this.s});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      borderColor: _blue.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(icon: Icons.account_balance_rounded, color: _blue, text: s.tr('Standards anchor', 'المرجعية في المعايير')),
          const SizedBox(height: 12),
          for (final st in article.standards)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KBStandardAnchor(standard: st, arabic: s.ar),
                  const SizedBox(height: 6),
                  Text(st.note.of(s.ar),
                      style: TextStyle(fontSize: 13.5, height: 1.5, color: AppColors.textSecondary(context))),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _CardTitle({required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(width: 8),
      Expanded(
        child: Text(text,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary(context))),
      ),
    ]);
  }
}

class _Related extends StatelessWidget {
  final KBArticle article;
  final AppStrings s;
  const _Related({required this.article, required this.s});

  Widget _label(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(text.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w700,
              color: AppColors.textTertiary(context),
            )),
      );

  Widget _pill(BuildContext context, String text, Color color, VoidCallback onTap, {IconData? icon, bool ltr = false}) {
    final label = Text(text, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: color));
    return Material(
      color: color.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (icon != null) ...[Icon(icon, size: 13, color: color), const SizedBox(width: 5)],
            Flexible(child: ltr ? Directionality(textDirection: TextDirection.ltr, child: label) : label),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ar = s.ar;
    final related = [
      for (final id in article.relatedArticles)
        if (kbArticleById(id) != null) kbArticleById(id)!,
    ];
    final modules = [
      for (final m in article.relatedModules)
        if (kbModuleRoute(m.href) != null) (m, kbModuleRoute(m.href)!),
    ];
    if (related.isEmpty && modules.isEmpty && article.relatedTerms.isEmpty) return const SizedBox.shrink();

    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(icon: Icons.link_rounded, color: _indigo, text: s.tr('Related content', 'محتوى مرتبط')),
          const SizedBox(height: 10),
          if (related.isNotEmpty) ...[
            _label(context, s.tr('Knowledge Base articles', 'مقالات في قاعدة المعرفة')),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final r in related)
                _pill(context, r.title.of(ar), _indigo, () => context.push('$kbArticleRoutePrefix${r.id}')),
            ]),
            const SizedBox(height: 12),
          ],
          if (modules.isNotEmpty) ...[
            _label(context, s.tr('Learning modules (slides)', 'الوحدات التعليمية (الشرائح)')),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final (m, route) in modules)
                _pill(context, m.label.of(ar), AppColors.secondary, () => context.push(route),
                    icon: Icons.menu_book_rounded),
            ]),
            const SizedBox(height: 12),
          ],
          if (article.relatedTerms.isNotEmpty) ...[
            _label(context, s.tr('Terms in the Financial Terms Directory', 'مصطلحات في دليل المصطلحات المالية')),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final t in article.relatedTerms)
                _pill(
                  context,
                  t,
                  AppColors.textSecondary(context),
                  () => context.push('$_glossaryRoute?term=${Uri.encodeQueryComponent(t)}'),
                  icon: Icons.open_in_new_rounded,
                  ltr: true,
                ),
            ]),
          ],
        ],
      ),
    );
  }
}

class _References extends StatelessWidget {
  final KBArticle article;
  final AppStrings s;
  const _References({required this.article, required this.s});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.tr('References', 'المراجع'),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary(context))),
          const SizedBox(height: 10),
          // Academic references are English-only and always LTR.
          Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final ref in article.references)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(ref,
                        style: TextStyle(fontSize: 12.5, height: 1.5, color: AppColors.textSecondary(context))),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
