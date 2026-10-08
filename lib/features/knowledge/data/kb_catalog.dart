// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/index.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import 'kb_models.dart';
import 'articles/accrual_accounting.dart';
import 'articles/revenue_recognition.dart';
import 'articles/depreciation_methods.dart';
import 'articles/inventory_costing.dart';
import 'articles/leases_ifrs16.dart';
import 'articles/impairment_testing.dart';
import 'articles/provisions_contingencies.dart';
import 'articles/financial_instruments.dart';
import 'articles/deferred_tax.dart';
import 'articles/foreign_currency.dart';
import 'articles/employee_benefits.dart';
import 'articles/transfer_pricing.dart';
import 'articles/borrowing_costs.dart';
import 'articles/intangible_assets.dart';
import 'articles/fair_value_measurement.dart';
import 'articles/income_statement.dart';
import 'articles/balance_sheet.dart';
import 'articles/cash_flow_statement.dart';
import 'articles/equity_and_oci.dart';
import 'articles/consolidation_goodwill.dart';
import 'articles/segment_reporting.dart';
import 'articles/discontinued_operations.dart';
import 'articles/related_party_disclosures.dart';
import 'articles/interim_reporting.dart';
import 'articles/investment_property.dart';
import 'articles/esg_sustainability_reporting.dart';
import 'articles/financial_ratios.dart';
import 'articles/statement_analysis_case.dart';
import 'articles/earnings_quality.dart';
import 'articles/credit_analysis.dart';
import 'articles/valuation_multiples.dart';
import 'articles/working_capital.dart';
import 'articles/cash_flow_forecasting.dart';
import 'articles/break_even_analysis.dart';
import 'articles/cost_accounting.dart';
import 'articles/budgeting_variance.dart';
import 'articles/time_value_of_money.dart';
import 'articles/npv_irr.dart';
import 'articles/wacc.dart';
import 'articles/dcf_valuation.dart';
import 'articles/mergers_acquisitions.dart';
import 'articles/capital_structure.dart';
import 'articles/dividend_policy.dart';
import 'articles/share_based_payment.dart';
import 'articles/bonds_and_sukuk.dart';
import 'articles/risk_management_hedging.dart';
import 'articles/ifrs_vs_ipsas.dart';
import 'articles/government_budget_cycle.dart';
import 'articles/government_cash_management.dart';
import 'articles/government_grants.dart';
import 'articles/public_debt_management.dart';
import 'articles/fiscal_sustainability.dart';
import 'articles/public_private_partnerships.dart';
import 'articles/internal_control_audit.dart';
import 'articles/zakat_and_tax.dart';

/// Category taxonomy, in the website's order.
const List<KBCategory> kbCategories = [
  KBCategory('accounting-foundations', label: Bi('Accounting Foundations', 'أسس المحاسبة'), description: Bi('The concepts every statement rests on: accrual, recognition, measurement.', 'المفاهيم التي تقوم عليها كل قائمة: الاستحقاق، والاعتراف، والقياس.')),
  KBCategory('financial-statements', label: Bi('Financial Statements', 'القوائم المالية'), description: Bi('The income statement, balance sheet, and cash flow statement in depth.', 'قائمة الدخل والميزانية العمومية وقائمة التدفقات النقدية بعمق.')),
  KBCategory('financial-analysis', label: Bi('Financial Analysis', 'التحليل المالي'), description: Bi('Ratios, working capital, and how professionals interrogate the numbers.', 'النسب ورأس المال العامل وكيف يسائل المهنيون الأرقام.')),
  KBCategory('corporate-finance', label: Bi('Corporate Finance', 'المالية للشركات'), description: Bi('Investment appraisal, the cost of capital, and financing decisions.', 'تقييم الاستثمار وتكلفة رأس المال وقرارات التمويل.')),
  KBCategory('public-sector', label: Bi('Public Sector Finance', 'مالية القطاع العام'), description: Bi('IPSAS, government budgeting, and public financial management.', 'معايير IPSAS والموازنة الحكومية والإدارة المالية العامة.')),
];

/// Every article, in the website's catalog order.
const List<KBArticle> kbArticles = [
  kbAccrualAccounting,
  kbRevenueRecognition,
  kbDepreciationMethods,
  kbInventoryCosting,
  kbLeasesIfrs16,
  kbImpairmentTesting,
  kbProvisionsContingencies,
  kbFinancialInstruments,
  kbDeferredTax,
  kbForeignCurrency,
  kbEmployeeBenefits,
  kbTransferPricing,
  kbBorrowingCosts,
  kbIntangibleAssets,
  kbFairValueMeasurement,
  kbIncomeStatement,
  kbBalanceSheet,
  kbCashFlowStatement,
  kbEquityAndOci,
  kbConsolidationGoodwill,
  kbSegmentReporting,
  kbDiscontinuedOperations,
  kbRelatedPartyDisclosures,
  kbInterimReporting,
  kbInvestmentProperty,
  kbEsgSustainabilityReporting,
  kbFinancialRatios,
  kbStatementAnalysisCase,
  kbEarningsQuality,
  kbCreditAnalysis,
  kbValuationMultiples,
  kbWorkingCapital,
  kbCashFlowForecasting,
  kbBreakEvenAnalysis,
  kbCostAccounting,
  kbBudgetingVariance,
  kbTimeValueOfMoney,
  kbNpvIrr,
  kbWacc,
  kbDcfValuation,
  kbMergersAcquisitions,
  kbCapitalStructure,
  kbDividendPolicy,
  kbShareBasedPayment,
  kbBondsAndSukuk,
  kbRiskManagementHedging,
  kbIfrsVsIpsas,
  kbGovernmentBudgetCycle,
  kbGovernmentCashManagement,
  kbGovernmentGrants,
  kbPublicDebtManagement,
  kbFiscalSustainability,
  kbPublicPrivatePartnerships,
  kbInternalControlAudit,
  kbZakatAndTax,
];
