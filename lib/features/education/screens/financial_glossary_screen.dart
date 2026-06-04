import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/ai_tooltip_button.dart';
import '../../../app/i18n/app_strings.dart';

/// Arabic display label for a glossary category key (key itself is unchanged
/// so filtering/search continue to use the canonical English value).
String _categoryLabel(AppStrings s, String key) {
  switch (key) {
    case 'All':
      return s.tr('All', 'الكل');
    case 'Accounting':
      return s.tr('Accounting', 'المحاسبة');
    case 'Finance':
      return s.tr('Finance', 'التمويل');
    case 'Investment':
      return s.tr('Investment', 'الاستثمار');
    case 'Banking':
      return s.tr('Banking', 'المصرفية');
    case 'Government':
      return s.tr('Government', 'الحكومة');
    case 'Risk':
      return s.tr('Risk', 'المخاطر');
    case 'Tax':
      return s.tr('Tax', 'الضرائب');
    default:
      return key;
  }
}

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

class _GlossaryTerm {
  final String term;
  final String termAr;
  final String definition;
  final String category;
  final String? formula;
  final String? example;
  final String? tip;
  final List<String>? relatedTerms;

  const _GlossaryTerm({
    required this.term,
    required this.termAr,
    required this.definition,
    required this.category,
    this.formula,
    this.example,
    this.tip,
    this.relatedTerms,
  });
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class FinancialGlossaryScreen extends StatefulWidget {
  const FinancialGlossaryScreen({super.key});

  @override
  State<FinancialGlossaryScreen> createState() =>
      _FinancialGlossaryScreenState();
}

class _FinancialGlossaryScreenState extends State<FinancialGlossaryScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  static const _categories = [
    'All',
    'Accounting',
    'Finance',
    'Investment',
    'Banking',
    'Government',
    'Risk',
    'Tax',
  ];

  static const _categoryIcons = <String, IconData>{
    'All': Icons.apps_rounded,
    'Accounting': Icons.menu_book_rounded,
    'Finance': Icons.account_balance_wallet_rounded,
    'Investment': Icons.trending_up_rounded,
    'Banking': Icons.account_balance_rounded,
    'Government': Icons.gavel_rounded,
    'Risk': Icons.shield_rounded,
    'Tax': Icons.receipt_long_rounded,
  };

  // -----------------------------------------------------------------------
  // 183 bilingual financial terms
  // -----------------------------------------------------------------------
  static const List<_GlossaryTerm> _terms = [
    // ===== Accounting (33) =====
    _GlossaryTerm(term: 'Accounts Payable', termAr: '\u0627\u0644\u062f\u0627\u0626\u0646\u0648\u0646', definition: 'Amounts owed by a company to its suppliers for goods and services received.', category: 'Accounting'),
    _GlossaryTerm(term: 'Accounts Receivable', termAr: '\u0627\u0644\u0645\u062f\u064a\u0646\u0648\u0646', definition: 'Amounts owed to a company by its customers for goods and services delivered.', category: 'Accounting'),
    _GlossaryTerm(term: 'Accrual Accounting', termAr: '\u0645\u062d\u0627\u0633\u0628\u0629 \u0627\u0644\u0627\u0633\u062a\u062d\u0642\u0627\u0642', definition: 'Accounting method that records revenues and expenses when they are incurred, regardless of cash timing.', category: 'Accounting'),
    _GlossaryTerm(term: 'Amortization', termAr: '\u0627\u0644\u0625\u0637\u0641\u0627\u0621', definition: 'The gradual reduction of a debt or intangible asset value over a period of time.', category: 'Accounting', formula: 'Amortization Expense = Cost of Asset / Useful Life', example: 'A patent costing \$100,000 with a 10-year life is amortized at \$10,000/year.', tip: 'Amortization applies to intangible assets, while depreciation applies to tangible assets.', relatedTerms: ['Depreciation', 'Fixed Assets', 'Goodwill']),
    _GlossaryTerm(term: 'Assets', termAr: '\u0627\u0644\u0623\u0635\u0648\u0644', definition: 'Resources owned by an entity that provide future economic benefits.', category: 'Accounting', formula: 'Assets = Liabilities + Equity', example: 'A company owns \$500K in cash, \$300K in equipment, and \$200K in inventory = \$1M total assets.', tip: 'Assets are listed on the balance sheet in order of liquidity, from most liquid (cash) to least.', relatedTerms: ['Liabilities', 'Equity', 'Balance Sheet', 'Current Assets', 'Fixed Assets']),
    _GlossaryTerm(term: 'Audit', termAr: '\u0627\u0644\u062a\u062f\u0642\u064a\u0642', definition: 'An independent examination and verification of financial statements and records.', category: 'Accounting'),
    _GlossaryTerm(term: 'Balance Sheet', termAr: '\u0627\u0644\u0645\u064a\u0632\u0627\u0646\u064a\u0629 \u0627\u0644\u0639\u0645\u0648\u0645\u064a\u0629', definition: 'A financial statement showing assets, liabilities, and equity at a point in time.', category: 'Accounting', formula: 'Assets = Liabilities + Shareholders\' Equity', example: 'If a company has \$1M in assets and \$600K in liabilities, equity is \$400K.', tip: 'The balance sheet is a snapshot at a single point in time, unlike the income statement which covers a period.', relatedTerms: ['Assets', 'Liabilities', 'Equity', 'Income Statement']),
    _GlossaryTerm(term: 'Book Value', termAr: '\u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u062f\u0641\u062a\u0631\u064a\u0629', definition: 'The value of an asset after deducting accumulated depreciation from its original cost.', category: 'Accounting'),
    _GlossaryTerm(term: 'Chart of Accounts', termAr: '\u062f\u0644\u064a\u0644 \u0627\u0644\u062d\u0633\u0627\u0628\u0627\u062a', definition: 'An organized listing of all accounts used in the general ledger of an organization.', category: 'Accounting'),
    _GlossaryTerm(term: 'Closing Entries', termAr: '\u0642\u064a\u0648\u062f \u0627\u0644\u0625\u0642\u0641\u0627\u0644', definition: 'Year-end journal entries to close temporary revenue and expense accounts.', category: 'Accounting'),
    _GlossaryTerm(term: 'Consolidation', termAr: '\u0627\u0644\u062a\u0648\u062d\u064a\u062f', definition: 'Combining the financial statements of a parent company and its subsidiaries.', category: 'Accounting'),
    _GlossaryTerm(term: 'Cost Accounting', termAr: '\u0645\u062d\u0627\u0633\u0628\u0629 \u0627\u0644\u062a\u0643\u0627\u0644\u064a\u0641', definition: 'A branch of accounting focused on recording and analyzing production costs.', category: 'Accounting'),
    _GlossaryTerm(term: 'Current Assets', termAr: '\u0627\u0644\u0623\u0635\u0648\u0644 \u0627\u0644\u0645\u062a\u062f\u0627\u0648\u0644\u0629', definition: 'Assets that can be converted to cash within one year.', category: 'Accounting'),
    _GlossaryTerm(term: 'Current Liabilities', termAr: '\u0627\u0644\u0627\u0644\u062a\u0632\u0627\u0645\u0627\u062a \u0627\u0644\u0645\u062a\u062f\u0627\u0648\u0644\u0629', definition: 'Financial obligations due within one year.', category: 'Accounting'),
    _GlossaryTerm(term: 'Deferred Revenue', termAr: '\u0627\u0644\u0625\u064a\u0631\u0627\u062f \u0627\u0644\u0645\u0624\u062c\u0644', definition: 'Payment received for goods or services not yet delivered to the customer.', category: 'Accounting'),
    _GlossaryTerm(term: 'Depreciation', termAr: '\u0627\u0644\u0627\u0633\u062a\u0647\u0644\u0627\u0643', definition: 'Systematic allocation of the cost of a tangible asset over its useful life.', category: 'Accounting', formula: 'Straight-Line = (Cost - Salvage Value) / Useful Life', example: 'A machine costing \$50,000 with \$5,000 salvage and 5-year life: \$9,000/year depreciation.', tip: 'Common methods include straight-line, declining balance, and units of production.', relatedTerms: ['Amortization', 'Fixed Assets', 'Book Value']),
    _GlossaryTerm(term: 'Double Entry', termAr: '\u0627\u0644\u0642\u064a\u062f \u0627\u0644\u0645\u0632\u062f\u0648\u062c', definition: 'Accounting principle where every transaction has equal and opposite debit and credit entries.', category: 'Accounting'),
    _GlossaryTerm(term: 'Equity', termAr: '\u062d\u0642\u0648\u0642 \u0627\u0644\u0645\u0644\u0643\u064a\u0629', definition: 'The residual interest in the assets of an entity after deducting all liabilities.', category: 'Accounting', formula: 'Equity = Total Assets - Total Liabilities', example: 'A company with \$2M in assets and \$1.2M in liabilities has \$800K in equity.', tip: 'Equity represents ownership value and includes common stock, retained earnings, and additional paid-in capital.', relatedTerms: ['Assets', 'Liabilities', 'Balance Sheet', 'Retained Earnings', 'Return on Equity']),
    _GlossaryTerm(term: 'Fair Value', termAr: '\u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u0639\u0627\u062f\u0644\u0629', definition: 'The price received in an orderly transaction between market participants.', category: 'Accounting'),
    _GlossaryTerm(term: 'FIFO', termAr: '\u0627\u0644\u0648\u0627\u0631\u062f \u0623\u0648\u0644\u0627\u064b \u0635\u0627\u062f\u0631 \u0623\u0648\u0644\u0627\u064b', definition: 'First In First Out \u2014 inventory valuation method where oldest items are sold first.', category: 'Accounting'),
    _GlossaryTerm(term: 'Fixed Assets', termAr: '\u0627\u0644\u0623\u0635\u0648\u0644 \u0627\u0644\u062b\u0627\u0628\u062a\u0629', definition: 'Long-term tangible assets used in business operations, not intended for resale.', category: 'Accounting'),
    _GlossaryTerm(term: 'General Ledger', termAr: '\u062f\u0641\u062a\u0631 \u0627\u0644\u0623\u0633\u062a\u0627\u0630 \u0627\u0644\u0639\u0627\u0645', definition: 'The complete record of all financial transactions of an organization.', category: 'Accounting'),
    _GlossaryTerm(term: 'Goodwill', termAr: '\u0627\u0644\u0634\u0647\u0631\u0629', definition: 'Intangible asset arising from acquiring a business above its net asset value.', category: 'Accounting'),
    _GlossaryTerm(term: 'Gross Profit', termAr: '\u0627\u0644\u0631\u0628\u062d \u0627\u0644\u0625\u062c\u0645\u0627\u0644\u064a', definition: 'Revenue minus cost of goods sold, before deducting operating expenses.', category: 'Accounting', formula: 'Gross Profit = Revenue - Cost of Goods Sold', example: 'Revenue of \$500K minus COGS of \$300K = \$200K gross profit.', tip: 'A declining gross profit margin may indicate rising production costs or pricing pressure.', relatedTerms: ['Revenue', 'Gross Margin', 'Net Income', 'Operating Expenses']),
    _GlossaryTerm(term: 'IFRS', termAr: '\u0627\u0644\u0645\u0639\u0627\u064a\u064a\u0631 \u0627\u0644\u062f\u0648\u0644\u064a\u0629 \u0644\u0644\u062a\u0642\u0627\u0631\u064a\u0631 \u0627\u0644\u0645\u0627\u0644\u064a\u0629', definition: 'International Financial Reporting Standards used for financial reporting globally.', category: 'Accounting'),
    _GlossaryTerm(term: 'Income Statement', termAr: '\u0642\u0627\u0626\u0645\u0629 \u0627\u0644\u062f\u062e\u0644', definition: 'Financial statement showing revenues, expenses, and profit over a period.', category: 'Accounting', formula: 'Net Income = Revenue - Expenses - Taxes', example: 'A quarterly income statement shows \$1M revenue, \$700K expenses, and \$300K net income.', tip: 'Also called the Profit & Loss (P&L) statement. It covers a time period, unlike the balance sheet.', relatedTerms: ['Revenue', 'Net Income', 'Balance Sheet', 'Operating Expenses', 'EBITDA']),
    _GlossaryTerm(term: 'Inventory', termAr: '\u0627\u0644\u0645\u062e\u0632\u0648\u0646', definition: 'Goods available for sale or raw materials used in production.', category: 'Accounting'),
    _GlossaryTerm(term: 'Journal Entry', termAr: '\u0627\u0644\u0642\u064a\u062f \u0627\u0644\u0645\u062d\u0627\u0633\u0628\u064a', definition: 'A formal recording of a financial transaction in the accounting system.', category: 'Accounting'),
    _GlossaryTerm(term: 'LIFO', termAr: '\u0627\u0644\u0648\u0627\u0631\u062f \u0623\u062e\u064a\u0631\u0627\u064b \u0635\u0627\u062f\u0631 \u0623\u0648\u0644\u0627\u064b', definition: 'Last In First Out \u2014 inventory valuation method where newest items are sold first.', category: 'Accounting'),
    _GlossaryTerm(term: 'Net Income', termAr: '\u0635\u0627\u0641\u064a \u0627\u0644\u062f\u062e\u0644', definition: 'Total revenue minus all expenses, taxes, and costs; the bottom line.', category: 'Accounting', formula: 'Net Income = Revenue - COGS - Operating Expenses - Interest - Taxes', example: 'Revenue \$1M - COGS \$400K - OpEx \$300K - Interest \$50K - Tax \$62.5K = \$187.5K net income.', tip: 'Net income is the most watched profitability metric and directly impacts earnings per share (EPS).', relatedTerms: ['Revenue', 'Gross Profit', 'EBITDA', 'Income Statement', 'Earnings Per Share']),
    _GlossaryTerm(term: 'Retained Earnings', termAr: '\u0627\u0644\u0623\u0631\u0628\u0627\u062d \u0627\u0644\u0645\u062d\u062a\u062c\u0632\u0629', definition: 'Cumulative net earnings not distributed as dividends, reinvested in the business.', category: 'Accounting'),
    _GlossaryTerm(term: 'Trial Balance', termAr: '\u0645\u064a\u0632\u0627\u0646 \u0627\u0644\u0645\u0631\u0627\u062c\u0639\u0629', definition: 'A list of all account balances used to verify that total debits equal total credits.', category: 'Accounting'),
    _GlossaryTerm(term: 'Working Capital', termAr: '\u0631\u0623\u0633 \u0627\u0644\u0645\u0627\u0644 \u0627\u0644\u0639\u0627\u0645\u0644', definition: 'Current assets minus current liabilities; measures short-term financial health.', category: 'Accounting', formula: 'Working Capital = Current Assets - Current Liabilities', example: 'Current assets of \$800K - current liabilities of \$500K = \$300K working capital.', tip: 'Negative working capital can signal liquidity problems, but some businesses (like grocery chains) operate this way normally.', relatedTerms: ['Current Assets', 'Current Liabilities', 'Liquidity', 'Current Ratio']),
    _GlossaryTerm(term: 'Accounts Reconciliation', termAr: '\u062a\u0633\u0648\u064a\u0629 \u0627\u0644\u062d\u0633\u0627\u0628\u0627\u062a', definition: 'The process of comparing internal records with external statements to ensure accuracy.', category: 'Accounting'),
    _GlossaryTerm(term: 'Accrued Expenses', termAr: '\u0627\u0644\u0645\u0635\u0631\u0648\u0641\u0627\u062a \u0627\u0644\u0645\u0633\u062a\u062d\u0642\u0629', definition: 'Expenses incurred but not yet paid or recorded at the end of an accounting period.', category: 'Accounting'),
    _GlossaryTerm(term: 'Cash Basis Accounting', termAr: '\u0627\u0644\u0645\u062d\u0627\u0633\u0628\u0629 \u0627\u0644\u0646\u0642\u062f\u064a\u0629', definition: 'Accounting method that records revenues and expenses only when cash is received or paid.', category: 'Accounting'),
    _GlossaryTerm(term: 'Ledger', termAr: '\u062f\u0641\u062a\u0631 \u0627\u0644\u0623\u0633\u062a\u0627\u0630', definition: 'A book or system containing individual accounts summarizing all business transactions.', category: 'Accounting'),
    _GlossaryTerm(term: 'Prepaid Expenses', termAr: '\u0627\u0644\u0645\u0635\u0631\u0648\u0641\u0627\u062a \u0627\u0644\u0645\u062f\u0641\u0648\u0639\u0629 \u0645\u0642\u062f\u0645\u0627\u064b', definition: 'Payments made for goods or services to be received in a future accounting period.', category: 'Accounting'),

    // ===== Finance (29) =====
    _GlossaryTerm(term: 'Bond', termAr: '\u0633\u0646\u062f', definition: 'A fixed-income instrument representing a loan made by an investor to a borrower.', category: 'Finance'),
    _GlossaryTerm(term: 'Budget', termAr: '\u0627\u0644\u0645\u064a\u0632\u0627\u0646\u064a\u0629', definition: 'A financial plan that estimates revenue and expenditures over a specific period.', category: 'Finance'),
    _GlossaryTerm(term: 'Capital Expenditure', termAr: '\u0627\u0644\u0646\u0641\u0642\u0627\u062a \u0627\u0644\u0631\u0623\u0633\u0645\u0627\u0644\u064a\u0629', definition: 'Funds used to acquire or upgrade physical assets such as property or equipment.', category: 'Finance'),
    _GlossaryTerm(term: 'Capital Structure', termAr: '\u0647\u064a\u0643\u0644 \u0631\u0623\u0633 \u0627\u0644\u0645\u0627\u0644', definition: 'The mix of debt and equity financing used by a company.', category: 'Finance'),
    _GlossaryTerm(term: 'Cash Flow', termAr: '\u0627\u0644\u062a\u062f\u0641\u0642 \u0627\u0644\u0646\u0642\u062f\u064a', definition: 'The net amount of cash moving in and out of a business during a period.', category: 'Finance', formula: 'Cash Flow = Cash Inflows - Cash Outflows', example: 'A business receives \$200K from sales and pays \$150K in expenses = \$50K net cash flow.', tip: 'Positive cash flow does not always mean profit, and profit does not always mean positive cash flow.', relatedTerms: ['Cash Flow Statement', 'Operating Cash Flow', 'Free Cash Flow', 'Net Income']),
    _GlossaryTerm(term: 'Cash Flow Statement', termAr: '\u0642\u0627\u0626\u0645\u0629 \u0627\u0644\u062a\u062f\u0641\u0642\u0627\u062a \u0627\u0644\u0646\u0642\u062f\u064a\u0629', definition: 'Financial statement reporting cash inflows and outflows over a period.', category: 'Finance'),
    _GlossaryTerm(term: 'Collateral', termAr: '\u0627\u0644\u0636\u0645\u0627\u0646', definition: 'An asset pledged as security for a loan, forfeited if the borrower defaults.', category: 'Finance'),
    _GlossaryTerm(term: 'Cost of Capital', termAr: '\u062a\u0643\u0644\u0641\u0629 \u0631\u0623\u0633 \u0627\u0644\u0645\u0627\u0644', definition: 'The required return necessary to make a capital budgeting project worthwhile.', category: 'Finance'),
    _GlossaryTerm(term: 'Debt-to-Equity Ratio', termAr: '\u0646\u0633\u0628\u0629 \u0627\u0644\u062f\u064a\u0646 \u0625\u0644\u0649 \u062d\u0642\u0648\u0642 \u0627\u0644\u0645\u0644\u0643\u064a\u0629', definition: 'Total liabilities divided by shareholders\' equity; measures financial leverage.', category: 'Finance'),
    _GlossaryTerm(term: 'Dividend', termAr: '\u062a\u0648\u0632\u064a\u0639\u0627\u062a \u0627\u0644\u0623\u0631\u0628\u0627\u062d', definition: 'A distribution of a portion of a company\'s earnings to its shareholders.', category: 'Finance'),
    _GlossaryTerm(term: 'EBITDA', termAr: '\u0627\u0644\u0623\u0631\u0628\u0627\u062d \u0642\u0628\u0644 \u0627\u0644\u0641\u0648\u0627\u0626\u062f \u0648\u0627\u0644\u0636\u0631\u0627\u0626\u0628 \u0648\u0627\u0644\u0627\u0633\u062a\u0647\u0644\u0627\u0643', definition: 'Earnings Before Interest, Taxes, Depreciation, and Amortization.', category: 'Finance'),
    _GlossaryTerm(term: 'Financial Leverage', termAr: '\u0627\u0644\u0631\u0627\u0641\u0639\u0629 \u0627\u0644\u0645\u0627\u0644\u064a\u0629', definition: 'The use of borrowed funds to increase potential returns on investment.', category: 'Finance'),
    _GlossaryTerm(term: 'Financial Statements', termAr: '\u0627\u0644\u0642\u0648\u0627\u0626\u0645 \u0627\u0644\u0645\u0627\u0644\u064a\u0629', definition: 'Formal records of the financial activities and position of a business.', category: 'Finance'),
    _GlossaryTerm(term: 'Fixed Costs', termAr: '\u0627\u0644\u062a\u0643\u0627\u0644\u064a\u0641 \u0627\u0644\u062b\u0627\u0628\u062a\u0629', definition: 'Costs that remain constant regardless of the level of production or sales.', category: 'Finance'),
    _GlossaryTerm(term: 'Free Cash Flow', termAr: '\u0627\u0644\u062a\u062f\u0641\u0642 \u0627\u0644\u0646\u0642\u062f\u064a \u0627\u0644\u062d\u0631', definition: 'Operating cash flow minus capital expenditures; cash available for distribution.', category: 'Finance'),
    _GlossaryTerm(term: 'Gross Margin', termAr: '\u0647\u0627\u0645\u0634 \u0627\u0644\u0631\u0628\u062d \u0627\u0644\u0625\u062c\u0645\u0627\u0644\u064a', definition: 'Revenue minus cost of goods sold, expressed as a percentage of revenue.', category: 'Finance'),
    _GlossaryTerm(term: 'Inflation', termAr: '\u0627\u0644\u062a\u0636\u062e\u0645', definition: 'A general increase in prices and fall in the purchasing value of money over time.', category: 'Finance'),
    _GlossaryTerm(term: 'Interest Rate', termAr: '\u0633\u0639\u0631 \u0627\u0644\u0641\u0627\u0626\u062f\u0629', definition: 'The cost of borrowing money, expressed as a percentage of the principal.', category: 'Finance'),
    _GlossaryTerm(term: 'Liabilities', termAr: '\u0627\u0644\u0627\u0644\u062a\u0632\u0627\u0645\u0627\u062a', definition: 'Financial obligations or debts owed by a company to external parties.', category: 'Finance'),
    _GlossaryTerm(term: 'Liquidity', termAr: '\u0627\u0644\u0633\u064a\u0648\u0644\u0629', definition: 'The ability to convert assets to cash quickly without significant loss in value.', category: 'Finance'),
    _GlossaryTerm(term: 'Net Worth', termAr: '\u0635\u0627\u0641\u064a \u0627\u0644\u0642\u064a\u0645\u0629', definition: 'Total assets minus total liabilities; the overall financial position.', category: 'Finance'),
    _GlossaryTerm(term: 'Operating Cash Flow', termAr: '\u0627\u0644\u062a\u062f\u0641\u0642 \u0627\u0644\u0646\u0642\u062f\u064a \u0627\u0644\u062a\u0634\u063a\u064a\u0644\u064a', definition: 'Cash generated from a company\'s core business operations.', category: 'Finance'),
    _GlossaryTerm(term: 'Operating Expenses', termAr: '\u0627\u0644\u0645\u0635\u0631\u0648\u0641\u0627\u062a \u0627\u0644\u062a\u0634\u063a\u064a\u0644\u064a\u0629', definition: 'Costs incurred in the normal course of running a business.', category: 'Finance'),
    _GlossaryTerm(term: 'Profit Margin', termAr: '\u0647\u0627\u0645\u0634 \u0627\u0644\u0631\u0628\u062d', definition: 'Net income divided by revenue; measures overall profitability.', category: 'Finance'),
    _GlossaryTerm(term: 'Revenue', termAr: '\u0627\u0644\u0625\u064a\u0631\u0627\u062f\u0627\u062a', definition: 'The total income generated from the sale of goods or services.', category: 'Finance'),
    _GlossaryTerm(term: 'Solvency', termAr: '\u0627\u0644\u0645\u0644\u0627\u0621\u0629 \u0627\u0644\u0645\u0627\u0644\u064a\u0629', definition: 'The ability of a company to meet its long-term financial obligations.', category: 'Finance'),
    _GlossaryTerm(term: 'Stakeholder', termAr: '\u0623\u0635\u062d\u0627\u0628 \u0627\u0644\u0645\u0635\u0644\u062d\u0629', definition: 'Any person or group that has an interest in or is affected by a business.', category: 'Finance'),
    _GlossaryTerm(term: 'Variable Costs', termAr: '\u0627\u0644\u062a\u0643\u0627\u0644\u064a\u0641 \u0627\u0644\u0645\u062a\u063a\u064a\u0631\u0629', definition: 'Costs that vary directly with the level of production or sales volume.', category: 'Finance'),
    _GlossaryTerm(term: 'Yield', termAr: '\u0627\u0644\u0639\u0627\u0626\u062f', definition: 'The income return on an investment, usually expressed as an annual percentage.', category: 'Finance'),
    _GlossaryTerm(term: 'Accounts Turnover', termAr: '\u0645\u0639\u062f\u0644 \u062f\u0648\u0631\u0627\u0646 \u0627\u0644\u062d\u0633\u0627\u0628\u0627\u062a', definition: 'The rate at which a company collects receivables or pays payables.', category: 'Finance'),
    _GlossaryTerm(term: 'Current Ratio', termAr: '\u0627\u0644\u0646\u0633\u0628\u0629 \u0627\u0644\u062c\u0627\u0631\u064a\u0629', definition: 'Current assets divided by current liabilities; measures short-term liquidity.', category: 'Finance'),
    _GlossaryTerm(term: 'Quick Ratio', termAr: '\u0627\u0644\u0646\u0633\u0628\u0629 \u0627\u0644\u0633\u0631\u064a\u0639\u0629', definition: 'Current assets minus inventory, divided by current liabilities; a stricter liquidity measure.', category: 'Finance'),
    _GlossaryTerm(term: 'Margin of Safety', termAr: '\u0647\u0627\u0645\u0634 \u0627\u0644\u0623\u0645\u0627\u0646', definition: 'The difference between actual sales and break-even sales.', category: 'Finance'),
    _GlossaryTerm(term: 'Inventory Turnover', termAr: '\u0645\u0639\u062f\u0644 \u062f\u0648\u0631\u0627\u0646 \u0627\u0644\u0645\u062e\u0632\u0648\u0646', definition: 'The number of times inventory is sold and replaced over a period.', category: 'Finance'),

    // ===== Investment (25) =====
    _GlossaryTerm(term: 'Alpha', termAr: '\u0623\u0644\u0641\u0627', definition: 'Excess return of an investment above the benchmark index return.', category: 'Investment'),
    _GlossaryTerm(term: 'Beta', termAr: '\u0628\u064a\u062a\u0627', definition: 'A measure of an asset\'s volatility relative to the overall market.', category: 'Investment'),
    _GlossaryTerm(term: 'Break-Even Point', termAr: '\u0646\u0642\u0637\u0629 \u0627\u0644\u062a\u0639\u0627\u062f\u0644', definition: 'The point where total revenue equals total costs, resulting in zero profit or loss.', category: 'Investment'),
    _GlossaryTerm(term: 'Capital Gain', termAr: '\u0627\u0644\u0631\u0628\u062d \u0627\u0644\u0631\u0623\u0633\u0645\u0627\u0644\u064a', definition: 'Profit realized from selling an asset at a higher price than the purchase price.', category: 'Investment'),
    _GlossaryTerm(term: 'Compound Interest', termAr: '\u0627\u0644\u0641\u0627\u0626\u062f\u0629 \u0627\u0644\u0645\u0631\u0643\u0628\u0629', definition: 'Interest calculated on the principal plus previously accumulated interest.', category: 'Investment'),
    _GlossaryTerm(term: 'Contribution Margin', termAr: '\u0647\u0627\u0645\u0634 \u0627\u0644\u0645\u0633\u0627\u0647\u0645\u0629', definition: 'Revenue minus variable costs per unit; the amount contributing to covering fixed costs.', category: 'Investment'),
    _GlossaryTerm(term: 'Discount Rate', termAr: '\u0645\u0639\u062f\u0644 \u0627\u0644\u062e\u0635\u0645', definition: 'Rate used to determine the present value of future cash flows.', category: 'Investment'),
    _GlossaryTerm(term: 'Diversification', termAr: '\u0627\u0644\u062a\u0646\u0648\u064a\u0639', definition: 'Strategy of spreading investments across different assets to reduce risk.', category: 'Investment'),
    _GlossaryTerm(term: 'Hedge', termAr: '\u0627\u0644\u062a\u062d\u0648\u0637', definition: 'An investment position to reduce the risk of adverse price movements.', category: 'Investment'),
    _GlossaryTerm(term: 'Internal Rate of Return', termAr: '\u0645\u0639\u062f\u0644 \u0627\u0644\u0639\u0627\u0626\u062f \u0627\u0644\u062f\u0627\u062e\u0644\u064a', definition: 'The discount rate that makes the net present value of all cash flows equal to zero.', category: 'Investment'),
    _GlossaryTerm(term: 'Market Capitalization', termAr: '\u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u0633\u0648\u0642\u064a\u0629', definition: 'The total market value of a company\'s outstanding shares of stock.', category: 'Investment'),
    _GlossaryTerm(term: 'Mutual Fund', termAr: '\u0635\u0646\u062f\u0648\u0642 \u0627\u0633\u062a\u062b\u0645\u0627\u0631 \u0645\u0634\u062a\u0631\u0643', definition: 'A pool of money collected from many investors to invest in diversified securities.', category: 'Investment'),
    _GlossaryTerm(term: 'Net Present Value', termAr: '\u0635\u0627\u0641\u064a \u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u062d\u0627\u0644\u064a\u0629', definition: 'The difference between the present value of cash inflows and outflows.', category: 'Investment'),
    _GlossaryTerm(term: 'Payback Period', termAr: '\u0641\u062a\u0631\u0629 \u0627\u0644\u0627\u0633\u062a\u0631\u062f\u0627\u062f', definition: 'The time required to recover the initial investment from project cash flows.', category: 'Investment'),
    _GlossaryTerm(term: 'Portfolio', termAr: '\u0627\u0644\u0645\u062d\u0641\u0638\u0629 \u0627\u0644\u0627\u0633\u062a\u062b\u0645\u0627\u0631\u064a\u0629', definition: 'A collection of financial investments such as stocks, bonds, and cash.', category: 'Investment'),
    _GlossaryTerm(term: 'Price-to-Earnings Ratio', termAr: '\u0646\u0633\u0628\u0629 \u0627\u0644\u0633\u0639\u0631 \u0625\u0644\u0649 \u0627\u0644\u0631\u0628\u062d', definition: 'Market price per share divided by earnings per share; a valuation metric.', category: 'Investment'),
    _GlossaryTerm(term: 'Profitability Index', termAr: '\u0645\u0624\u0634\u0631 \u0627\u0644\u0631\u0628\u062d\u064a\u0629', definition: 'Present value of future cash flows divided by the initial investment.', category: 'Investment'),
    _GlossaryTerm(term: 'Return on Assets', termAr: '\u0627\u0644\u0639\u0627\u0626\u062f \u0639\u0644\u0649 \u0627\u0644\u0623\u0635\u0648\u0644', definition: 'Net income divided by total assets; measures how efficiently assets generate profit.', category: 'Investment'),
    _GlossaryTerm(term: 'Return on Equity', termAr: '\u0627\u0644\u0639\u0627\u0626\u062f \u0639\u0644\u0649 \u062d\u0642\u0648\u0642 \u0627\u0644\u0645\u0644\u0643\u064a\u0629', definition: 'Net income divided by shareholders\' equity; measures return on ownership.', category: 'Investment'),
    _GlossaryTerm(term: 'Return on Investment', termAr: '\u0627\u0644\u0639\u0627\u0626\u062f \u0639\u0644\u0649 \u0627\u0644\u0627\u0633\u062a\u062b\u0645\u0627\u0631', definition: 'Gain from investment relative to its cost; measures investment efficiency.', category: 'Investment'),
    _GlossaryTerm(term: 'Risk Premium', termAr: '\u0639\u0644\u0627\u0648\u0629 \u0627\u0644\u0645\u062e\u0627\u0637\u0631', definition: 'The extra return expected for taking on additional risk above the risk-free rate.', category: 'Investment'),
    _GlossaryTerm(term: 'Sharpe Ratio', termAr: '\u0646\u0633\u0628\u0629 \u0634\u0627\u0631\u0628', definition: 'A risk-adjusted return measure comparing excess return to standard deviation.', category: 'Investment'),
    _GlossaryTerm(term: 'Simple Interest', termAr: '\u0627\u0644\u0641\u0627\u0626\u062f\u0629 \u0627\u0644\u0628\u0633\u064a\u0637\u0629', definition: 'Interest calculated only on the original principal amount.', category: 'Investment'),
    _GlossaryTerm(term: 'Time Value of Money', termAr: '\u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u0632\u0645\u0646\u064a\u0629 \u0644\u0644\u0646\u0642\u0648\u062f', definition: 'The concept that money available now is worth more than the same amount in the future.', category: 'Investment'),
    _GlossaryTerm(term: 'Volatility', termAr: '\u0627\u0644\u062a\u0642\u0644\u0628', definition: 'The degree of variation in trading price over time; a measure of risk.', category: 'Investment'),
    _GlossaryTerm(term: 'Equity Fund', termAr: '\u0635\u0646\u062f\u0648\u0642 \u0627\u0644\u0623\u0633\u0647\u0645', definition: 'A mutual fund that invests primarily in stocks and equity securities.', category: 'Investment'),
    _GlossaryTerm(term: 'Index Fund', termAr: '\u0635\u0646\u062f\u0648\u0642 \u0627\u0644\u0645\u0624\u0634\u0631', definition: 'A fund designed to track the performance of a specific market index.', category: 'Investment'),
    _GlossaryTerm(term: 'Dividend Yield', termAr: '\u0639\u0627\u0626\u062f \u062a\u0648\u0632\u064a\u0639\u0627\u062a \u0627\u0644\u0623\u0631\u0628\u0627\u062d', definition: 'Annual dividends per share divided by the stock price; measures income return.', category: 'Investment'),
    _GlossaryTerm(term: 'Blue Chip Stocks', termAr: '\u0627\u0644\u0623\u0633\u0647\u0645 \u0627\u0644\u0645\u0645\u062a\u0627\u0632\u0629', definition: 'Shares in large, well-established, and financially sound companies with reliable performance.', category: 'Investment'),
    _GlossaryTerm(term: 'Earnings Per Share', termAr: '\u0631\u0628\u062d\u064a\u0629 \u0627\u0644\u0633\u0647\u0645', definition: 'Net income divided by the number of outstanding shares; a profitability measure.', category: 'Investment'),
    _GlossaryTerm(term: 'Asset Allocation', termAr: '\u062a\u0648\u0632\u064a\u0639 \u0627\u0644\u0623\u0635\u0648\u0644', definition: 'The strategy of dividing investments among different asset classes to balance risk and return.', category: 'Investment'),

    // ===== Banking (20) =====
    _GlossaryTerm(term: 'Amortization Schedule', termAr: '\u062c\u062f\u0648\u0644 \u0627\u0644\u0625\u0637\u0641\u0627\u0621', definition: 'A table showing the breakdown of each loan payment into principal and interest over time.', category: 'Banking'),
    _GlossaryTerm(term: 'Annual Percentage Rate', termAr: '\u0645\u0639\u062f\u0644 \u0627\u0644\u0646\u0633\u0628\u0629 \u0627\u0644\u0633\u0646\u0648\u064a\u0629', definition: 'The annualized interest rate charged on a loan, including fees and costs.', category: 'Banking'),
    _GlossaryTerm(term: 'Central Bank', termAr: '\u0627\u0644\u0628\u0646\u0643 \u0627\u0644\u0645\u0631\u0643\u0632\u064a', definition: 'A national institution responsible for managing a country\'s monetary policy and currency.', category: 'Banking'),
    _GlossaryTerm(term: 'Certificate of Deposit', termAr: '\u0634\u0647\u0627\u062f\u0629 \u0625\u064a\u062f\u0627\u0639', definition: 'A savings certificate with a fixed interest rate and fixed maturity date.', category: 'Banking'),
    _GlossaryTerm(term: 'Credit Rating', termAr: '\u0627\u0644\u062a\u0635\u0646\u064a\u0641 \u0627\u0644\u0627\u0626\u062a\u0645\u0627\u0646\u064a', definition: 'An assessment of the creditworthiness of a borrower or debt issuer.', category: 'Banking'),
    _GlossaryTerm(term: 'Credit Risk', termAr: '\u0645\u062e\u0627\u0637\u0631 \u0627\u0644\u0627\u0626\u062a\u0645\u0627\u0646', definition: 'The risk that a borrower will fail to repay a loan or meet contractual obligations.', category: 'Banking'),
    _GlossaryTerm(term: 'Default', termAr: '\u0627\u0644\u062a\u0639\u062b\u0631', definition: 'Failure to meet the legal obligations or conditions of a loan agreement.', category: 'Banking'),
    _GlossaryTerm(term: 'Deposit', termAr: '\u0627\u0644\u0625\u064a\u062f\u0627\u0639', definition: 'Money placed into a banking institution for safekeeping or to earn interest.', category: 'Banking'),
    _GlossaryTerm(term: 'Exchange Rate', termAr: '\u0633\u0639\u0631 \u0627\u0644\u0635\u0631\u0641', definition: 'The value of one currency expressed in terms of another currency.', category: 'Banking'),
    _GlossaryTerm(term: 'Islamic Finance', termAr: '\u0627\u0644\u062a\u0645\u0648\u064a\u0644 \u0627\u0644\u0625\u0633\u0644\u0627\u0645\u064a', definition: 'Financial activities that comply with Sharia (Islamic law), prohibiting interest.', category: 'Banking'),
    _GlossaryTerm(term: 'Letter of Credit', termAr: '\u062e\u0637\u0627\u0628 \u0627\u0644\u0627\u0639\u062a\u0645\u0627\u062f', definition: 'A bank guarantee of payment to a seller on behalf of the buyer.', category: 'Banking'),
    _GlossaryTerm(term: 'Line of Credit', termAr: '\u062e\u0637 \u0627\u0644\u0627\u0626\u062a\u0645\u0627\u0646', definition: 'A preset borrowing limit that can be drawn upon at any time.', category: 'Banking'),
    _GlossaryTerm(term: 'Maturity Date', termAr: '\u062a\u0627\u0631\u064a\u062e \u0627\u0644\u0627\u0633\u062a\u062d\u0642\u0627\u0642', definition: 'The date on which the principal amount of a debt becomes due and payable.', category: 'Banking'),
    _GlossaryTerm(term: 'Mortgage', termAr: '\u0627\u0644\u0631\u0647\u0646 \u0627\u0644\u0639\u0642\u0627\u0631\u064a', definition: 'A loan secured by real estate property, repaid over a fixed period.', category: 'Banking'),
    _GlossaryTerm(term: 'Overdraft', termAr: '\u0627\u0644\u0633\u062d\u0628 \u0639\u0644\u0649 \u0627\u0644\u0645\u0643\u0634\u0648\u0641', definition: 'A withdrawal that exceeds the available balance in a bank account.', category: 'Banking'),
    _GlossaryTerm(term: 'Prime Rate', termAr: '\u0633\u0639\u0631 \u0627\u0644\u0641\u0627\u0626\u062f\u0629 \u0627\u0644\u0623\u0633\u0627\u0633\u064a', definition: 'The interest rate that commercial banks charge their most creditworthy customers.', category: 'Banking'),
    _GlossaryTerm(term: 'Repo Rate', termAr: '\u0633\u0639\u0631 \u0625\u0639\u0627\u062f\u0629 \u0627\u0644\u0634\u0631\u0627\u0621', definition: 'The rate at which a central bank lends short-term money to commercial banks.', category: 'Banking'),
    _GlossaryTerm(term: 'Reserve Ratio', termAr: '\u0646\u0633\u0628\u0629 \u0627\u0644\u0627\u062d\u062a\u064a\u0627\u0637\u064a', definition: 'The minimum percentage of deposits banks must hold as reserves.', category: 'Banking'),
    _GlossaryTerm(term: 'Sukuk', termAr: '\u0635\u0643\u0648\u0643', definition: 'Islamic financial certificates similar to bonds, compliant with Sharia law.', category: 'Banking'),
    _GlossaryTerm(term: 'Wire Transfer', termAr: '\u062a\u062d\u0648\u064a\u0644 \u0628\u0646\u0643\u064a', definition: 'An electronic transfer of funds between banks or financial institutions.', category: 'Banking'),
    _GlossaryTerm(term: 'Savings Account', termAr: '\u062d\u0633\u0627\u0628 \u0627\u0644\u062a\u0648\u0641\u064a\u0631', definition: 'A deposit account that earns interest while keeping funds accessible.', category: 'Banking'),
    _GlossaryTerm(term: 'Current Account', termAr: '\u0627\u0644\u062d\u0633\u0627\u0628 \u0627\u0644\u062c\u0627\u0631\u064a', definition: 'A bank account for daily transactions, deposits, and withdrawals without time restrictions.', category: 'Banking'),
    _GlossaryTerm(term: 'Basel Accords', termAr: '\u0627\u062a\u0641\u0627\u0642\u064a\u0627\u062a \u0628\u0627\u0632\u0644', definition: 'International banking regulations on capital adequacy, stress testing, and market risk.', category: 'Banking'),

    // ===== Government (20) =====
    _GlossaryTerm(term: 'Accountability', termAr: '\u0627\u0644\u0645\u0633\u0627\u0621\u0644\u0629', definition: 'The obligation to account for activities and accept responsibility for results.', category: 'Government'),
    _GlossaryTerm(term: 'Appropriation', termAr: '\u0627\u0644\u0627\u0639\u062a\u0645\u0627\u062f', definition: 'A legislative authorization to spend a specific amount of public funds.', category: 'Government'),
    _GlossaryTerm(term: 'Balanced Budget', termAr: '\u0627\u0644\u0645\u064a\u0632\u0627\u0646\u064a\u0629 \u0627\u0644\u0645\u062a\u0648\u0627\u0632\u0646\u0629', definition: 'A budget where total revenue equals total expenditure.', category: 'Government'),
    _GlossaryTerm(term: 'Budget Deficit', termAr: '\u0639\u062c\u0632 \u0627\u0644\u0645\u064a\u0632\u0627\u0646\u064a\u0629', definition: 'A situation where government expenditure exceeds revenue.', category: 'Government'),
    _GlossaryTerm(term: 'Budget Surplus', termAr: '\u0641\u0627\u0626\u0636 \u0627\u0644\u0645\u064a\u0632\u0627\u0646\u064a\u0629', definition: 'A situation where government revenue exceeds expenditure.', category: 'Government'),
    _GlossaryTerm(term: 'Capital Budget', termAr: '\u0627\u0644\u0645\u064a\u0632\u0627\u0646\u064a\u0629 \u0627\u0644\u0631\u0623\u0633\u0645\u0627\u0644\u064a\u0629', definition: 'A plan for long-term asset purchases and infrastructure investments.', category: 'Government'),
    _GlossaryTerm(term: 'Compliance', termAr: '\u0627\u0644\u0627\u0645\u062a\u062b\u0627\u0644', definition: 'Adherence to laws, regulations, standards, and ethical practices.', category: 'Government'),
    _GlossaryTerm(term: 'Fiscal Policy', termAr: '\u0627\u0644\u0633\u064a\u0627\u0633\u0629 \u0627\u0644\u0645\u0627\u0644\u064a\u0629', definition: 'Government decisions on taxation and spending to influence the economy.', category: 'Government'),
    _GlossaryTerm(term: 'Government Bonds', termAr: '\u0627\u0644\u0633\u0646\u062f\u0627\u062a \u0627\u0644\u062d\u0643\u0648\u0645\u064a\u0629', definition: 'Debt securities issued by a government to finance public expenditure.', category: 'Government'),
    _GlossaryTerm(term: 'Internal Controls', termAr: '\u0627\u0644\u0636\u0648\u0627\u0628\u0637 \u0627\u0644\u062f\u0627\u062e\u0644\u064a\u0629', definition: 'Processes ensuring reliable financial reporting and compliance with regulations.', category: 'Government'),
    _GlossaryTerm(term: 'IPSAS', termAr: '\u0645\u0639\u0627\u064a\u064a\u0631 \u0627\u0644\u0645\u062d\u0627\u0633\u0628\u0629 \u0627\u0644\u062f\u0648\u0644\u064a\u0629 \u0644\u0644\u0642\u0637\u0627\u0639 \u0627\u0644\u0639\u0627\u0645', definition: 'International Public Sector Accounting Standards for government financial reporting.', category: 'Government'),
    _GlossaryTerm(term: 'Monetary Policy', termAr: '\u0627\u0644\u0633\u064a\u0627\u0633\u0629 \u0627\u0644\u0646\u0642\u062f\u064a\u0629', definition: 'Central bank actions to control the money supply and interest rates.', category: 'Government'),
    _GlossaryTerm(term: 'National Debt', termAr: '\u0627\u0644\u062f\u064a\u0646 \u0627\u0644\u0639\u0627\u0645', definition: 'The total outstanding borrowings of a national government.', category: 'Government'),
    _GlossaryTerm(term: 'Performance Audit', termAr: '\u062a\u062f\u0642\u064a\u0642 \u0627\u0644\u0623\u062f\u0627\u0621', definition: 'An evaluation of whether programs are achieving goals efficiently and effectively.', category: 'Government'),
    _GlossaryTerm(term: 'Public Expenditure', termAr: '\u0627\u0644\u0625\u0646\u0641\u0627\u0642 \u0627\u0644\u0639\u0627\u0645', definition: 'Government spending on public goods, services, and infrastructure.', category: 'Government'),
    _GlossaryTerm(term: 'Public Revenue', termAr: '\u0627\u0644\u0625\u064a\u0631\u0627\u062f\u0627\u062a \u0627\u0644\u0639\u0627\u0645\u0629', definition: 'Government income from taxes, fees, fines, and other sources.', category: 'Government'),
    _GlossaryTerm(term: 'Tax Revenue', termAr: '\u0627\u0644\u0625\u064a\u0631\u0627\u062f\u0627\u062a \u0627\u0644\u0636\u0631\u064a\u0628\u064a\u0629', definition: 'Government income derived from taxation of individuals and businesses.', category: 'Government'),
    _GlossaryTerm(term: 'Treasury', termAr: '\u0627\u0644\u062e\u0632\u064a\u0646\u0629', definition: 'The government department responsible for managing public finances and debt.', category: 'Government'),
    _GlossaryTerm(term: 'Value Added Tax', termAr: '\u0636\u0631\u064a\u0628\u0629 \u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u0645\u0636\u0627\u0641\u0629', definition: 'A consumption tax levied on value added at each stage of production.', category: 'Government'),
    _GlossaryTerm(term: 'Zakat', termAr: '\u0627\u0644\u0632\u0643\u0627\u0629', definition: 'An Islamic obligatory charitable contribution, one of the Five Pillars of Islam.', category: 'Government'),
    _GlossaryTerm(term: 'Sovereign Wealth Fund', termAr: '\u0635\u0646\u062f\u0648\u0642 \u0627\u0644\u062b\u0631\u0648\u0629 \u0627\u0644\u0633\u064a\u0627\u062f\u064a', definition: 'A state-owned investment fund composed of financial assets for national benefit.', category: 'Government'),
    _GlossaryTerm(term: 'Public-Private Partnership', termAr: '\u0627\u0644\u0634\u0631\u0627\u0643\u0629 \u0628\u064a\u0646 \u0627\u0644\u0642\u0637\u0627\u0639\u064a\u0646', definition: 'A cooperative arrangement between government and private sector for public projects.', category: 'Government'),
    _GlossaryTerm(term: 'Subsidy', termAr: '\u0627\u0644\u062f\u0639\u0645', definition: 'Financial assistance given by government to individuals or businesses for public benefit.', category: 'Government'),

    // ===== Risk (15) =====
    _GlossaryTerm(term: 'Counterparty Risk', termAr: '\u0645\u062e\u0627\u0637\u0631 \u0627\u0644\u0637\u0631\u0641 \u0627\u0644\u0645\u0642\u0627\u0628\u0644', definition: 'The risk that the other party in a transaction will default on its obligation.', category: 'Risk'),
    _GlossaryTerm(term: 'Currency Risk', termAr: '\u0645\u062e\u0627\u0637\u0631 \u0627\u0644\u0639\u0645\u0644\u0629', definition: 'The risk of financial loss due to fluctuating exchange rates.', category: 'Risk'),
    _GlossaryTerm(term: 'Exposure', termAr: '\u0627\u0644\u062a\u0639\u0631\u0636', definition: 'The amount of money or assets at risk of loss from a particular event.', category: 'Risk'),
    _GlossaryTerm(term: 'Hedging', termAr: '\u0627\u0644\u062a\u062d\u0648\u0637', definition: 'A risk management strategy using financial instruments to offset potential losses.', category: 'Risk'),
    _GlossaryTerm(term: 'Insurance', termAr: '\u0627\u0644\u062a\u0623\u0645\u064a\u0646', definition: 'A contract providing financial protection against specified losses in exchange for premiums.', category: 'Risk'),
    _GlossaryTerm(term: 'Interest Rate Risk', termAr: '\u0645\u062e\u0627\u0637\u0631 \u0633\u0639\u0631 \u0627\u0644\u0641\u0627\u0626\u062f\u0629', definition: 'The risk that changes in interest rates will adversely affect asset values.', category: 'Risk'),
    _GlossaryTerm(term: 'KPI', termAr: '\u0645\u0624\u0634\u0631 \u0627\u0644\u0623\u062f\u0627\u0621 \u0627\u0644\u0631\u0626\u064a\u0633\u064a', definition: 'Key Performance Indicator \u2014 a measurable value showing how effectively objectives are achieved.', category: 'Risk'),
    _GlossaryTerm(term: 'Liquidity Risk', termAr: '\u0645\u062e\u0627\u0637\u0631 \u0627\u0644\u0633\u064a\u0648\u0644\u0629', definition: 'The risk of being unable to meet short-term financial obligations.', category: 'Risk'),
    _GlossaryTerm(term: 'Market Risk', termAr: '\u0645\u062e\u0627\u0637\u0631 \u0627\u0644\u0633\u0648\u0642', definition: 'The risk of losses from adverse movements in market prices.', category: 'Risk'),
    _GlossaryTerm(term: 'Operational Risk', termAr: '\u0627\u0644\u0645\u062e\u0627\u0637\u0631 \u0627\u0644\u062a\u0634\u063a\u064a\u0644\u064a\u0629', definition: 'Risk of loss from failed internal processes, people, systems, or external events.', category: 'Risk'),
    _GlossaryTerm(term: 'Risk Appetite', termAr: '\u0627\u0644\u0631\u063a\u0628\u0629 \u0641\u064a \u0627\u0644\u0645\u062e\u0627\u0637\u0631\u0629', definition: 'The amount and type of risk an organization is willing to accept to meet objectives.', category: 'Risk'),
    _GlossaryTerm(term: 'Risk Management', termAr: '\u0625\u062f\u0627\u0631\u0629 \u0627\u0644\u0645\u062e\u0627\u0637\u0631', definition: 'The process of identifying, assessing, and controlling threats to an organization.', category: 'Risk'),
    _GlossaryTerm(term: 'Stress Testing', termAr: '\u0627\u062e\u062a\u0628\u0627\u0631 \u0627\u0644\u0625\u062c\u0647\u0627\u062f', definition: 'Simulating extreme economic scenarios to assess financial resilience.', category: 'Risk'),
    _GlossaryTerm(term: 'Systemic Risk', termAr: '\u0627\u0644\u0645\u062e\u0627\u0637\u0631 \u0627\u0644\u0646\u0638\u0627\u0645\u064a\u0629', definition: 'The risk that the collapse of one entity triggers the failure of the entire financial system.', category: 'Risk'),
    _GlossaryTerm(term: 'Value at Risk', termAr: '\u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u0645\u0639\u0631\u0636\u0629 \u0644\u0644\u062e\u0637\u0631', definition: 'The maximum potential loss in value of a portfolio over a given time period.', category: 'Risk'),

    // ===== Tax (13) =====
    _GlossaryTerm(term: 'Corporate Tax', termAr: '\u0636\u0631\u064a\u0628\u0629 \u0627\u0644\u0634\u0631\u0643\u0627\u062a', definition: 'A tax levied on the profits of incorporated businesses.', category: 'Tax'),
    _GlossaryTerm(term: 'Deductible', termAr: '\u0642\u0627\u0628\u0644 \u0644\u0644\u062e\u0635\u0645', definition: 'An expense that can be subtracted from gross income to reduce taxable income.', category: 'Tax'),
    _GlossaryTerm(term: 'Double Taxation', termAr: '\u0627\u0644\u0627\u0632\u062f\u0648\u0627\u062c \u0627\u0644\u0636\u0631\u064a\u0628\u064a', definition: 'The same income being taxed twice by two different jurisdictions.', category: 'Tax'),
    _GlossaryTerm(term: 'Excise Tax', termAr: '\u0627\u0644\u0636\u0631\u064a\u0628\u0629 \u0627\u0644\u0627\u0646\u062a\u0642\u0627\u0626\u064a\u0629', definition: 'A tax on specific goods such as tobacco, alcohol, and fuel.', category: 'Tax'),
    _GlossaryTerm(term: 'Income Tax', termAr: '\u0636\u0631\u064a\u0628\u0629 \u0627\u0644\u062f\u062e\u0644', definition: 'A tax imposed on individuals or entities based on their income or profits.', category: 'Tax'),
    _GlossaryTerm(term: 'Tax Base', termAr: '\u0627\u0644\u0648\u0639\u0627\u0621 \u0627\u0644\u0636\u0631\u064a\u0628\u064a', definition: 'The total amount of assets or income that is subject to taxation.', category: 'Tax'),
    _GlossaryTerm(term: 'Tax Bracket', termAr: '\u0634\u0631\u064a\u062d\u0629 \u0636\u0631\u064a\u0628\u064a\u0629', definition: 'A range of income that is taxed at a particular rate.', category: 'Tax'),
    _GlossaryTerm(term: 'Tax Credit', termAr: '\u0627\u0626\u062a\u0645\u0627\u0646 \u0636\u0631\u064a\u0628\u064a', definition: 'An amount subtracted directly from the tax owed, reducing the total tax bill.', category: 'Tax'),
    _GlossaryTerm(term: 'Tax Evasion', termAr: '\u0627\u0644\u062a\u0647\u0631\u0628 \u0627\u0644\u0636\u0631\u064a\u0628\u064a', definition: 'The illegal non-payment or underpayment of taxes owed.', category: 'Tax'),
    _GlossaryTerm(term: 'Tax Exemption', termAr: '\u0627\u0644\u0625\u0639\u0641\u0627\u0621 \u0627\u0644\u0636\u0631\u064a\u0628\u064a', definition: 'Income or transactions that are not subject to tax by law.', category: 'Tax'),
    _GlossaryTerm(term: 'Tax Haven', termAr: '\u0645\u0644\u0627\u0630 \u0636\u0631\u064a\u0628\u064a', definition: 'A country or jurisdiction with very low or zero tax rates to attract foreign capital.', category: 'Tax'),
    _GlossaryTerm(term: 'Transfer Pricing', termAr: '\u062a\u0633\u0639\u064a\u0631 \u0627\u0644\u062a\u062d\u0648\u064a\u0644', definition: 'The pricing of goods, services, or assets transferred between related entities.', category: 'Tax'),
    _GlossaryTerm(term: 'Withholding Tax', termAr: '\u0636\u0631\u064a\u0628\u0629 \u0627\u0644\u0627\u0633\u062a\u0642\u0637\u0627\u0639', definition: 'A tax deducted at source from payments such as wages, dividends, or interest.', category: 'Tax'),
    _GlossaryTerm(term: 'Customs Duty', termAr: '\u0627\u0644\u0631\u0633\u0648\u0645 \u0627\u0644\u062c\u0645\u0631\u0643\u064a\u0629', definition: 'A tax on goods imported into or exported from a country.', category: 'Tax'),
    _GlossaryTerm(term: 'Tax Return', termAr: '\u0627\u0644\u0625\u0642\u0631\u0627\u0631 \u0627\u0644\u0636\u0631\u064a\u0628\u064a', definition: 'A form filed with the tax authority reporting income, expenses, and taxes owed.', category: 'Tax'),
    _GlossaryTerm(term: 'Progressive Tax', termAr: '\u0627\u0644\u0636\u0631\u064a\u0628\u0629 \u0627\u0644\u062a\u0635\u0627\u0639\u062f\u064a\u0629', definition: 'A tax system where the rate increases as the taxable amount rises.', category: 'Tax'),
    _GlossaryTerm(term: 'Flat Tax', termAr: '\u0627\u0644\u0636\u0631\u064a\u0628\u0629 \u0627\u0644\u0645\u0648\u062d\u062f\u0629', definition: 'A tax system that applies the same rate to all taxpayers regardless of income.', category: 'Tax'),
  ];

  // -----------------------------------------------------------------------
  // Filtering
  // -----------------------------------------------------------------------

  List<_GlossaryTerm> get _filteredTerms {
    var list = _terms.toList();

    // Category filter
    if (_selectedCategory != 'All') {
      list = list.where((t) => t.category == _selectedCategory).toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((t) =>
              t.term.toLowerCase().contains(q) ||
              t.termAr.contains(q) ||
              t.definition.toLowerCase().contains(q))
          .toList();
    }

    // Alphabetical sort
    list.sort((a, b) => a.term.compareTo(b.term));
    return list;
  }

  /// Build a map of first-letter -> index in the filtered list for quick jump.
  Map<String, int> _buildLetterIndex(List<_GlossaryTerm> terms) {
    final map = <String, int>{};
    for (var i = 0; i < terms.length; i++) {
      final letter = terms[i].term[0].toUpperCase();
      map.putIfAbsent(letter, () => i);
    }
    return map;
  }

  void _jumpToLetter(String letter, Map<String, int> letterIndex) {
    final idx = letterIndex[letter];
    if (idx == null) return;
    // Each card is roughly 76px high + 8px bottom padding = 84px
    _scrollController.animateTo(
      idx * 84.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // -----------------------------------------------------------------------
  // Build
  // -----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTerms;
    final letterIndex = _buildLetterIndex(filtered);
    final availableLetters = letterIndex.keys.toSet();

    return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              // ---- Header ----
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => context.pop(),
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
                    Consumer(builder: (context, ref, _) {
                      final s = ref.watch(stringsProvider);
                      return Text(s.tr('Financial Glossary', 'القاموس المالي'),
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: Theme.of(context).textTheme.headlineMedium,
                            fontWeight: FontWeight.w700,
                          ));
                    }),
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
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final cat = _categories[i];
                    final selected = _selectedCategory == cat;
                    return FilterChip(
                      avatar: Icon(
                        _categoryIcons[cat] ?? Icons.label_rounded,
                        size: 16,
                        color: selected ? Colors.white : AppColors.primaryLight,
                      ),
                      label: Consumer(builder: (context, ref, _) {
                        final s = ref.watch(stringsProvider);
                        return Text(_categoryLabel(s, cat), style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : AppColors.textSecondary(context),
                        ));
                      }),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                      side: BorderSide(
                        color: selected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    );
                  },
                ),
              ).animate().fadeIn(delay: 100.ms),

              // ---- Search Bar ----
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Consumer(builder: (context, ref, _) {
                final s = ref.watch(stringsProvider);
                return TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: s.tr('Search ${_terms.length} financial terms...',
                        'ابحث في ${_terms.length} مصطلحًا ماليًا...'),
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
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
                );
                }),
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
                      child: Consumer(builder: (context, ref, _) {
                        final s = ref.watch(stringsProvider);
                        return Text(
                          s.tr('${filtered.length} of ${_terms.length} terms',
                              '${filtered.length} من ${_terms.length} مصطلحًا'),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        );
                      }),
                    ),
                    if (_selectedCategory != 'All') ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Consumer(builder: (context, ref, _) {
                          final s = ref.watch(stringsProvider);
                          return Text(
                            _categoryLabel(s, _selectedCategory),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.accentLight,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          );
                        }),
                      ),
                    ],
                    const Spacer(),
                    const Icon(Icons.auto_awesome, size: 14, color: AppColors.primaryLight),
                    const SizedBox(width: 4),
                    Consumer(builder: (context, ref, _) {
                      final s = ref.watch(stringsProvider);
                      return Text(s.tr('AI explanations available', 'شروحات الذكاء الاصطناعي متاحة'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryLight, fontSize: 11));
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // ---- Terms List + Alphabet Sidebar ----
              Expanded(
                child: Row(
                  children: [
                    // Main list
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.search_off_rounded,
                                      size: 48,
                                      color: AppColors.textTertiary(context)),
                                  const SizedBox(height: 12),
                                  Consumer(builder: (context, ref, _) {
                                    final s = ref.watch(stringsProvider);
                                    return Text(s.tr('No terms found', 'لا توجد مصطلحات'),
                                        style: TextStyle(
                                          color: AppColors.textTertiary(context),
                                          fontSize: 16,
                                        ));
                                  }),
                                ],
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.fromLTRB(16, 0, 4, 16),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final term = filtered[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _TermCard(term: term),
                                ).animate().fadeIn(
                                    delay: (30 * (index % 15)).ms);
                              },
                            ),
                    ),

                    // Alphabet sidebar
                    SizedBox(
                      width: 28,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
                            final maxH = constraints.maxHeight;
                            final itemH = (maxH / 26).clamp(14.0, 22.0);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(26, (i) {
                                final letter = letters[i];
                                final isAvailable = availableLetters.contains(letter);
                                return GestureDetector(
                                  onTap: isAvailable
                                      ? () => _jumpToLetter(letter, letterIndex)
                                      : null,
                                  child: SizedBox(
                                    height: itemH,
                                    width: 28,
                                    child: Center(
                                      child: Text(
                                        letter,
                                        style: TextStyle(
                                          fontSize: itemH > 18 ? 11 : 9,
                                          fontWeight: isAvailable
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                          color: isAvailable
                                              ? AppColors.primaryLight
                                              : AppColors.textTertiary(context)
                                                  .withValues(alpha: 0.4),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
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
// Term Card Widget
// ---------------------------------------------------------------------------

class _TermCard extends StatefulWidget {
  final _GlossaryTerm term;

  const _TermCard({required this.term});

  @override
  State<_TermCard> createState() => _TermCardState();
}

class _TermCardState extends State<_TermCard> {
  bool _expanded = false;

  static const _categoryColors = <String, Color>{
    'Accounting': AppColors.primaryLight,
    'Finance': AppColors.secondaryLight,
    'Investment': AppColors.accentLight,
    'Banking': AppColors.info,
    'Government': Color(0xFF8B5CF6),
    'Risk': AppColors.dangerLight,
    'Tax': AppColors.warning,
  };

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColors[widget.term.category] ?? AppColors.primaryLight;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: catColor, width: 3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GlassCard(
        onTap: () => setState(() => _expanded = !_expanded),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Letter badge
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
                      widget.term.term[0],
                      style: TextStyle(
                        color: catColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              // English + Arabic terms
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.term.term,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 2),
                    Text(
                      widget.term.termAr,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary(context),
                        fontFamily: 'Noto Sans Arabic',
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              AiTooltipButton(term: widget.term.term, color: catColor),
              const SizedBox(width: 6),
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
            ),
            crossFadeState:
                _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
      ),
    );
  }
}
