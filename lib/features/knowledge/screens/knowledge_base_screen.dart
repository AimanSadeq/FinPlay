import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../data/kb_catalog.dart';
import '../data/kb_models.dart';
import '../data/kb_repository.dart';

/// Route of the article screen; the article id is appended.
const String kbArticleRoutePrefix = '/knowledge/';

/// Knowledge Base library (website parity: client/src/pages/knowledge-base.tsx):
/// the academic reference layer beneath the Learn slides. Articles are browsable by
/// category and searchable in both languages. Open to every audience, like the web.
class KnowledgeBaseScreen extends ConsumerStatefulWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  ConsumerState<KnowledgeBaseScreen> createState() => _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends ConsumerState<KnowledgeBaseScreen> {
  final _search = TextEditingController();
  String _query = '';
  String? _category; // null = all

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final ar = s.ar;
    final results = kbSearch(_query, category: _category);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const BackButtonIcon(),
                        onPressed: () => context.canPop() ? context.pop() : context.go('/education'),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F46E5).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.bookmarks_rounded, size: 22, color: Color(0xFF4338CA)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.tr('Knowledge Base', 'قاعدة المعرفة'),
                              style: GoogleFonts.plusJakartaSans(
                                textStyle: Theme.of(context).textTheme.headlineSmall,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              s.tr(
                                'The in-depth academic reference for finance and accounting, anchored to standards and linked to the learning modules',
                                'المرجع الأكاديمي المتعمق في المالية والمحاسبة، مرتبط بالمعايير وبالوحدات التعليمية',
                              ),
                              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary(context)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    controller: _search,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: s.tr('Search articles (English or Arabic)...',
                          'ابحث في المقالات (عربي أو إنجليزي)...'),
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 20),
                              onPressed: () {
                                _search.clear();
                                setState(() => _query = '');
                              },
                            ),
                      filled: true,
                      fillColor: AppColors.surfaceColor(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColors.borderColor(context)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColors.borderColor(context)),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 46,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    children: [
                      _chip(context, '${s.tr('All', 'الكل')} (${kbArticles.length})', _category == null,
                          () => setState(() => _category = null)),
                      for (final c in kbCategories)
                        if (kbCategoryCount(c.id) > 0)
                          _chip(context, '${c.label.of(ar)} (${kbCategoryCount(c.id)})', _category == c.id,
                              () => setState(() => _category = c.id)),
                    ],
                  ),
                ),
              ),
              if (results.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        s.tr('No articles match your search.', 'لا توجد مقالات مطابقة لبحثك.'),
                        style: TextStyle(color: AppColors.textTertiary(context)),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  sliver: SliverList.separated(
                    itemCount: results.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => KBArticleCard(article: results[i], arabic: ar),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, String label, bool selected, VoidCallback onTap) {
    const indigo = Color(0xFF4F46E5);
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
        label: Text(label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textSecondary(context),
            )),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: indigo,
        backgroundColor: AppColors.surfaceColor(context),
        side: BorderSide(color: selected ? indigo : AppColors.borderColor(context)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

/// Level badge colours, matching the website's emerald / blue / purple scheme.
Color kbLevelColor(KBLevel level) => switch (level) {
      KBLevel.foundation => const Color(0xFF059669),
      KBLevel.intermediate => const Color(0xFF2563EB),
      KBLevel.advanced => const Color(0xFF7C3AED),
    };

class KBBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  const KBBadge({super.key, required this.text, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(text,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class KBArticleCard extends StatelessWidget {
  final KBArticle article;
  final bool arabic;
  const KBArticleCard({super.key, required this.article, required this.arabic});

  @override
  Widget build(BuildContext context) {
    String t(String en, String ar) => arabic ? ar : en;
    return GlassCard(
      onTap: () => context.push('$kbArticleRoutePrefix${article.id}'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              KBBadge(
                text: kbLevelLabels[article.level]!.of(arabic),
                color: kbLevelColor(article.level),
                icon: Icons.school_rounded,
              ),
              KBBadge(text: kbCategoryLabel(article.category).of(arabic), color: AppColors.textSecondary(context)),
            ],
          ),
          const SizedBox(height: 10),
          Text(article.title.of(arabic),
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                height: 1.3,
                color: AppColors.textPrimary(context),
              )),
          const SizedBox(height: 6),
          Text(article.summary.of(arabic),
              style: TextStyle(fontSize: 13, height: 1.45, color: AppColors.textSecondary(context))),
          const SizedBox(height: 10),
          Divider(height: 1, color: AppColors.borderColor(context).withValues(alpha: 0.6)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 14, color: AppColors.textTertiary(context)),
              const SizedBox(width: 4),
              Text('${article.readingMinutes} ${t('min read', 'دقيقة قراءة')}',
                  style: TextStyle(fontSize: 11.5, color: AppColors.textTertiary(context))),
              const SizedBox(width: 14),
              Text('${article.standards.length} ${t('standards refs', 'مرجع معايير')}',
                  style: TextStyle(fontSize: 11.5, color: AppColors.textTertiary(context))),
            ],
          ),
        ],
      ),
    );
  }
}
