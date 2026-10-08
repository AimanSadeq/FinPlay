import 'package:finplay/features/education/screens/financial_glossary_screen.dart';
import 'package:finplay/features/knowledge/screens/knowledge_article_screen.dart';
import 'package:finplay/features/knowledge/screens/knowledge_base_screen.dart';
import 'package:finplay/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

Widget _host(Widget child, {bool arabic = false}) => ProviderScope(
      overrides: [isArabicProvider.overrideWithValue(arabic)],
      child: MaterialApp(
        home: Directionality(
          textDirection: arabic ? TextDirection.rtl : TextDirection.ltr,
          child: child,
        ),
      ),
    );

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('Knowledge Base index lists articles and filters by search', (tester) async {
    await tester.pumpWidget(_host(const KnowledgeBaseScreen()));
    expect(find.text('Knowledge Base'), findsOneWidget);
    expect(find.byType(KBArticleCard), findsWidgets);
    await tester.enterText(find.byType(TextField), 'zzzz-nothing');
    await tester.pump();
    expect(find.text('No articles match your search.'), findsOneWidget);
  });

  testWidgets('Knowledge Base index renders in Arabic', (tester) async {
    await tester.pumpWidget(_host(const KnowledgeBaseScreen(), arabic: true));
    expect(find.text('قاعدة المعرفة'), findsOneWidget);
  });

  testWidgets('article renders sections, standards and references', (tester) async {
    await tester.pumpWidget(_host(const KnowledgeArticleScreen(articleId: 'wacc')));
    expect(find.text('Cost of Capital and WACC'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('References'), 400);
    expect(find.text('References'), findsOneWidget);
  });

  testWidgets('unknown article shows not-found', (tester) async {
    await tester.pumpWidget(_host(const KnowledgeArticleScreen(articleId: 'nope')));
    expect(find.text('Article not found'), findsOneWidget);
  });

  testWidgets('glossary deep link opens the term, Arabic leads in Arabic', (tester) async {
    await tester.pumpWidget(_host(const FinancialGlossaryScreen(initialTerm: 'Balance Sheet'), arabic: true));
    await tester.pumpAndSettle();
    expect(find.text('الميزانية العمومية'), findsWidgets);
    expect(find.text('التعريف'), findsOneWidget); // expanded
  });
}
