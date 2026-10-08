import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../core/services/learn_resume.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Data models
// ──────────────────────────────────────────────────────────────────────────────

/// One Learn slide, ported verbatim (EN + AR) from the website's
/// break-even-slides-content.ts (BE.1-BE.15). [id] is the website section id: it is what
/// the resume position stores, so it must stay identical to the web.
class BreakEvenSlide {
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

  const BreakEvenSlide({
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
  });

  static bool _has(String? v) => v != null && v.trim().isNotEmpty;
  static bool _hasAll(List<String> v) => v.isNotEmpty && v.every(_has);

  // Arabic when the UI is Arabic and a translation exists, else English.
  String titleFor(bool ar) => ar && _has(titleAr) ? titleAr : title;
  List<String> contentFor(bool ar) => ar && _hasAll(contentAr) ? contentAr : content;
  List<String> keyPointsFor(bool ar) => ar && _hasAll(keyPointsAr) ? keyPointsAr : keyPoints;
  String? highlightFor(bool ar) => ar && _has(highlightAr) ? highlightAr : highlight;
  String? examplesTitleFor(bool ar) => ar && _has(examplesTitleAr) ? examplesTitleAr : examplesTitle;
  List<String> examplesFor(bool ar) => ar && _hasAll(examplesAr) ? examplesAr : examples;
}

class _PracticeScenario {
  final String title;
  final String city;
  final String currency;
  final String difficulty;
  final Color difficultyColor;
  final String description;
  final List<_CostItem> variableCosts;
  final double pricePerUnit;
  final double totalVariableCost;
  final double fixedCosts;
  final String fixedCostsBreakdown;
  final double bep;
  final String bepLabel;
  final String bepDetail;
  final bool isMultiProduct;
  final List<_ProductMix>? products;
  final double? weightedCM;

  const _PracticeScenario({
    required this.title,
    required this.city,
    required this.currency,
    required this.difficulty,
    required this.difficultyColor,
    required this.description,
    this.variableCosts = const [],
    this.pricePerUnit = 0,
    this.totalVariableCost = 0,
    required this.fixedCosts,
    this.fixedCostsBreakdown = '',
    required this.bep,
    required this.bepLabel,
    this.bepDetail = '',
    this.isMultiProduct = false,
    this.products,
    this.weightedCM,
  });
}

class _CostItem {
  final String name;
  final double cost;
  const _CostItem(this.name, this.cost);
}

class _ProductMix {
  final String name;
  final double price;
  final double cm;
  final double mixPercent;
  const _ProductMix(this.name, this.price, this.cm, this.mixPercent);
}

// ──────────────────────────────────────────────────────────────────────────────
// Static data
// ──────────────────────────────────────────────────────────────────────────────

// Ported from the website by a generator (tool/generators/gen_decks.ts + patch_decks.py); do not hand-edit.
const List<BreakEvenSlide> breakEvenSlides = [
  BreakEvenSlide(
    id: 'section-be-overview',
    number: 'BE.1',
    title: 'Introduction to Break-Even Analysis',
    titleAr: 'مقدمة في تحليل نقطة التعادل',
    content: ['The break-even point is the sales level where total revenue equals total costs. At this point there is no profit or loss, and any sales above it generate profit.', 'Everything in this module follows from one formula: the break-even point in units equals fixed costs divided by the contribution each unit makes, which is its selling price less its variable cost.', 'That formula relates three quantities. Fixed costs stay constant as volume changes, variable costs move with each unit produced, and the break-even point is the volume at which the two lines meet.'],
    contentAr: ['نقطة التعادل هي مستوى المبيعات الذي يتساوى فيه إجمالي الإيرادات مع إجمالي التكاليف. عند هذه النقطة لا ربح ولا خسارة، وأي مبيعات فوقها تولّد ربحاً.', 'كل ما في هذه الوحدة ينبع من معادلة واحدة: نقطة التعادل بالوحدات تساوي التكاليف الثابتة مقسومة على مساهمة كل وحدة، وهي سعر بيعها ناقص تكلفتها المتغيرة.', 'وتربط تلك المعادلة ثلاث كميات. فالتكاليف الثابتة تبقى ثابتة مع تغير الحجم، والتكاليف المتغيرة تتحرك مع كل وحدة منتجة، ونقطة التعادل هي الحجم الذي يلتقي عنده الخطان.'],
    keyPoints: ['BEP (units) = Fixed Costs ÷ (Selling Price − Variable Cost per Unit)', 'Fixed costs are constant; variable costs change with volume', 'Above the break-even point every additional unit adds profit'],
    keyPointsAr: ['نقطة التعادل (وحدات) = التكاليف الثابتة ÷ (سعر البيع − التكلفة المتغيرة للوحدة)', 'التكاليف الثابتة ثابتة؛ والتكاليف المتغيرة تتغير مع الحجم', 'فوق نقطة التعادل تضيف كل وحدة إضافية ربحاً'],
  ),
  BreakEvenSlide(
    id: 'section-be-1',
    number: 'BE.2',
    title: 'What is Break-Even Analysis?',
    titleAr: 'ما هو تحليل التعادل؟',
    content: ['Break-even analysis determines the point at which total revenue equals total costs, resulting in neither profit nor loss.', 'It is one of the most fundamental tools in managerial accounting and financial planning, helping businesses understand the minimum sales needed to cover all costs.', 'Beyond the break-even point, every additional unit sold contributes directly to profit. Below it, the business operates at a loss.', 'This analysis is essential for pricing decisions, cost control, and evaluating new product launches or business ventures.'],
    contentAr: ['يحدد تحليل التعادل النقطة التي يتساوى فيها إجمالي الإيرادات مع إجمالي التكاليف، مما لا ينتج عنه ربح ولا خسارة.', 'إنه أحد أهم الأدوات الأساسية في المحاسبة الإدارية والتخطيط المالي، حيث يساعد الشركات على فهم الحد الأدنى من المبيعات اللازمة لتغطية جميع التكاليف.', 'بعد نقطة التعادل، تساهم كل وحدة إضافية مباعة مباشرة في الربح. قبلها، تعمل الشركة بخسارة.', 'هذا التحليل ضروري لقرارات التسعير والتحكم في التكاليف وتقييم إطلاق منتجات جديدة أو مشاريع تجارية.'],
    keyPoints: ['Revenue = Total Costs at break-even', 'Essential for pricing and planning decisions', 'Sales above BEP generate profit'],
    keyPointsAr: ['الإيرادات = إجمالي التكاليف عند التعادل', 'ضروري لقرارات التسعير والتخطيط', 'المبيعات فوق نقطة التعادل تولد ربحاً'],
  ),
  BreakEvenSlide(
    id: 'section-be-2',
    number: 'BE.3',
    title: 'Understanding Fixed Costs',
    titleAr: 'فهم التكاليف الثابتة',
    content: ['Fixed costs remain constant regardless of the number of units produced or sold. They must be paid whether the business sells one unit or one million.', 'Common examples include rent, insurance premiums, salaries of permanent staff, depreciation of equipment, and interest on loans.', 'Fixed costs create a baseline that the business must cover before any profit is generated. The higher the fixed costs, the higher the break-even point.', 'Understanding fixed costs helps managers evaluate the risk of new investments and the operating leverage of the business.'],
    contentAr: ['التكاليف الثابتة تبقى ثابتة بغض النظر عن عدد الوحدات المنتجة أو المباعة. يجب دفعها سواء باعت الشركة وحدة واحدة أو مليون وحدة.', 'الأمثلة الشائعة تشمل الإيجار وأقساط التأمين ورواتب الموظفين الدائمين واستهلاك المعدات وفوائد القروض.', 'التكاليف الثابتة تنشئ خط أساس يجب على الشركة تغطيته قبل تحقيق أي ربح. كلما ارتفعت التكاليف الثابتة، ارتفعت نقطة التعادل.', 'فهم التكاليف الثابتة يساعد المديرين على تقييم مخاطر الاستثمارات الجديدة والرافعة التشغيلية للشركة.'],
    keyPoints: ['Do not change with production volume', 'Examples: rent, insurance, salaries', 'Higher fixed costs = higher break-even point'],
    keyPointsAr: ['لا تتغير مع حجم الإنتاج', 'أمثلة: الإيجار، التأمين، الرواتب', 'تكاليف ثابتة أعلى = نقطة تعادل أعلى'],
  ),
  BreakEvenSlide(
    id: 'section-be-3',
    number: 'BE.4',
    title: 'Understanding Variable Costs',
    titleAr: 'فهم التكاليف المتغيرة',
    content: ['Variable costs change in direct proportion to the number of units produced or sold. If production doubles, variable costs double.', 'Common examples include raw materials, direct labor (hourly wages), sales commissions, shipping costs, and packaging.', 'The variable cost per unit typically remains constant, but total variable costs increase with volume.', 'Businesses with lower variable costs relative to selling price have a higher contribution margin and reach break-even faster.'],
    contentAr: ['التكاليف المتغيرة تتغير بتناسب مباشر مع عدد الوحدات المنتجة أو المباعة. إذا تضاعف الإنتاج، تتضاعف التكاليف المتغيرة.', 'الأمثلة الشائعة تشمل المواد الخام والعمالة المباشرة (الأجور بالساعة) وعمولات المبيعات وتكاليف الشحن والتعبئة.', 'التكلفة المتغيرة لكل وحدة تبقى ثابتة عادة، لكن إجمالي التكاليف المتغيرة يزداد مع الحجم.', 'الشركات ذات التكاليف المتغيرة المنخفضة نسبة إلى سعر البيع لديها هامش مساهمة أعلى وتصل إلى التعادل بشكل أسرع.'],
    keyPoints: ['Change proportionally with production', 'Per-unit cost stays constant', 'Lower variable costs = faster break-even'],
    keyPointsAr: ['تتغير بشكل متناسب مع الإنتاج', 'التكلفة لكل وحدة تبقى ثابتة', 'تكاليف متغيرة أقل = تعادل أسرع'],
  ),
  BreakEvenSlide(
    id: 'section-be-4',
    number: 'BE.5',
    title: 'Contribution Margin',
    titleAr: 'هامش المساهمة',
    content: ['The contribution margin is the amount each unit sold contributes toward covering fixed costs and generating profit. It equals selling price minus variable cost per unit.', 'The contribution margin ratio (CM%) expresses this as a percentage of the selling price: CM% = Contribution Margin / Selling Price.', 'A higher contribution margin means each sale contributes more toward fixed costs, resulting in a lower break-even point.', 'This concept is critical for pricing decisions: if you lower prices, you must sell more units to cover the same fixed costs.'],
    contentAr: ['هامش المساهمة هو المبلغ الذي تساهم به كل وحدة مباعة في تغطية التكاليف الثابتة وتحقيق الربح. يساوي سعر البيع ناقص التكلفة المتغيرة لكل وحدة.', 'نسبة هامش المساهمة تعبر عن ذلك كنسبة من سعر البيع: نسبة هامش المساهمة = هامش المساهمة / سعر البيع.', 'هامش مساهمة أعلى يعني أن كل عملية بيع تساهم أكثر في التكاليف الثابتة، مما يؤدي إلى نقطة تعادل أقل.', 'هذا المفهوم حاسم لقرارات التسعير: إذا خفضت الأسعار، يجب بيع وحدات أكثر لتغطية نفس التكاليف الثابتة.'],
    keyPoints: ['CM = Selling Price - Variable Cost per Unit', 'CM Ratio = CM / Selling Price', 'Higher CM = Lower break-even point'],
    keyPointsAr: ['هامش المساهمة = سعر البيع - التكلفة المتغيرة لكل وحدة', 'نسبة هامش المساهمة = هامش المساهمة / سعر البيع', 'هامش أعلى = نقطة تعادل أقل'],
    highlightType: 'formula',
    highlight: 'Contribution Margin = Selling Price - Variable Cost per Unit',
    highlightAr: 'هامش المساهمة = سعر البيع - التكلفة المتغيرة لكل وحدة',
  ),
  BreakEvenSlide(
    id: 'section-be-5',
    number: 'BE.6',
    title: 'Calculating the Break-Even Point',
    titleAr: 'حساب نقطة التعادل',
    content: ['The break-even point in units is calculated by dividing total fixed costs by the contribution margin per unit: BEP = Fixed Costs / CM per Unit.', 'The break-even point in revenue (dollars) is: BEP (\$) = Fixed Costs / CM Ratio.', 'For example, with \$50,000 fixed costs, a \$20 selling price, and \$12 variable cost: CM = \$8, BEP = 50,000 / 8 = 6,250 units.', 'To find the target profit volume, add the desired profit to fixed costs: Units = (Fixed Costs + Target Profit) / CM per Unit.'],
    contentAr: ['نقطة التعادل بالوحدات تُحسب بقسمة إجمالي التكاليف الثابتة على هامش المساهمة لكل وحدة: نقطة التعادل = التكاليف الثابتة / هامش المساهمة لكل وحدة.', 'نقطة التعادل بالإيرادات: نقطة التعادل (بالدولار) = التكاليف الثابتة / نسبة هامش المساهمة.', 'مثال: مع 50,000 دولار تكاليف ثابتة، سعر بيع 20 دولار، وتكلفة متغيرة 12 دولار: هامش المساهمة = 8 دولار، نقطة التعادل = 50,000 / 8 = 6,250 وحدة.', 'لإيجاد حجم الربح المستهدف، أضف الربح المطلوب إلى التكاليف الثابتة: الوحدات = (التكاليف الثابتة + الربح المستهدف) / هامش المساهمة لكل وحدة.'],
    keyPoints: ['BEP (units) = Fixed Costs / CM per Unit', 'BEP (\$) = Fixed Costs / CM Ratio', 'Add target profit to find required volume'],
    keyPointsAr: ['نقطة التعادل (وحدات) = التكاليف الثابتة / هامش المساهمة', 'نقطة التعادل (دولار) = التكاليف الثابتة / نسبة الهامش', 'أضف الربح المستهدف لإيجاد الحجم المطلوب'],
    highlightType: 'formula',
    highlight: 'BEP (units) = Fixed Costs / (Selling Price - Variable Cost per Unit)',
    highlightAr: 'نقطة التعادل = التكاليف الثابتة / (سعر البيع - التكلفة المتغيرة لكل وحدة)',
  ),
  BreakEvenSlide(
    id: 'section-be-6',
    number: 'BE.7',
    title: 'The Break-Even Chart',
    titleAr: 'مخطط التعادل',
    content: ['A break-even chart (or CVP chart) is a visual representation that shows total revenue and total costs at different production levels.', 'The horizontal axis shows quantity (units), while the vertical axis shows monetary values (revenue and costs).', 'The total cost line starts at the fixed cost level (when zero units are sold) and slopes upward. The revenue line starts at zero and slopes upward at the selling price rate.', 'The point where the two lines cross is the break-even point. The area between revenue and cost lines shows profit (above BEP) or loss (below BEP).'],
    contentAr: ['مخطط التعادل (أو مخطط التكلفة-الحجم-الربح) هو تمثيل بصري يُظهر إجمالي الإيرادات وإجمالي التكاليف عند مستويات إنتاج مختلفة.', 'المحور الأفقي يُظهر الكمية (الوحدات)، بينما المحور الرأسي يُظهر القيم النقدية (الإيرادات والتكاليف).', 'خط التكلفة الإجمالية يبدأ عند مستوى التكلفة الثابتة (عند بيع صفر وحدة) وينحدر صعوداً. خط الإيرادات يبدأ من الصفر وينحدر صعوداً بمعدل سعر البيع.', 'النقطة التي يتقاطع فيها الخطان هي نقطة التعادل. المنطقة بين خطي الإيرادات والتكاليف تُظهر الربح (فوق نقطة التعادل) أو الخسارة (تحتها).'],
    keyPoints: ['Visual representation of CVP relationships', 'Lines cross at the break-even point', 'Shows profit and loss zones clearly'],
    keyPointsAr: ['تمثيل بصري لعلاقات التكلفة-الحجم-الربح', 'الخطوط تتقاطع عند نقطة التعادل', 'تُظهر مناطق الربح والخسارة بوضوح'],
  ),
  BreakEvenSlide(
    id: 'section-be-7',
    number: 'BE.8',
    title: 'Margin of Safety',
    titleAr: 'هامش الأمان',
    content: ['The margin of safety measures how far above the break-even point a business is currently operating. It represents the cushion before the business starts losing money.', 'Margin of Safety = Actual Sales - Break-Even Sales. It can be expressed in units, revenue, or as a percentage.', 'MoS% = (Actual Sales - BEP Sales) / Actual Sales x 100. A higher percentage means greater protection against sales declines.', 'Managers use this metric to assess risk: a low margin of safety indicates vulnerability to market downturns, while a high margin provides confidence.'],
    contentAr: ['يقيس هامش الأمان مدى بُعد الشركة فوق نقطة التعادل في عملياتها الحالية. يمثل الوسادة قبل أن تبدأ الشركة في خسارة المال.', 'هامش الأمان = المبيعات الفعلية - مبيعات التعادل. يمكن التعبير عنه بالوحدات أو الإيرادات أو كنسبة مئوية.', 'نسبة هامش الأمان = (المبيعات الفعلية - مبيعات التعادل) / المبيعات الفعلية × 100. نسبة أعلى تعني حماية أكبر ضد انخفاض المبيعات.', 'يستخدم المديرون هذا المقياس لتقييم المخاطر: هامش أمان منخفض يشير إلى الضعف أمام تراجع السوق، بينما هامش مرتفع يوفر الثقة.'],
    keyPoints: ['MoS = Actual Sales - Break-Even Sales', 'Higher MoS% = Less risk', 'Key metric for risk assessment'],
    keyPointsAr: ['هامش الأمان = المبيعات الفعلية - مبيعات التعادل', 'نسبة أعلى = مخاطر أقل', 'مقياس رئيسي لتقييم المخاطر'],
    highlightType: 'formula',
    highlight: 'Margin of Safety % = (Actual Sales - BEP Sales) / Actual Sales x 100',
    highlightAr: 'نسبة هامش الأمان = (المبيعات الفعلية - مبيعات التعادل) / المبيعات الفعلية × 100',
  ),
  BreakEvenSlide(
    id: 'section-be-8',
    number: 'BE.9',
    title: 'Multi-Product Break-Even',
    titleAr: 'تعادل المنتجات المتعددة',
    content: ['Most businesses sell more than one product. Multi-product break-even analysis accounts for the sales mix - the proportion each product represents of total sales.', 'The weighted average contribution margin (WACM) is calculated by weighting each product\'s CM by its share of total sales.', 'BEP (units) = Total Fixed Costs / WACM. This gives the total units needed; individual product quantities are then derived from the sales mix.', 'Changes in sales mix affect the break-even point: shifting toward higher-margin products lowers BEP, while shifting toward lower-margin products raises it.'],
    contentAr: ['معظم الشركات تبيع أكثر من منتج واحد. تحليل التعادل متعدد المنتجات يراعي مزيج المبيعات - النسبة التي يمثلها كل منتج من إجمالي المبيعات.', 'المتوسط المرجح لهامش المساهمة يُحسب بترجيح هامش مساهمة كل منتج بحصته من إجمالي المبيعات.', 'نقطة التعادل (وحدات) = إجمالي التكاليف الثابتة / المتوسط المرجح لهامش المساهمة. هذا يعطي إجمالي الوحدات المطلوبة؛ ثم تُشتق كميات المنتجات الفردية من مزيج المبيعات.', 'التغييرات في مزيج المبيعات تؤثر على نقطة التعادل: التحول نحو المنتجات ذات الهامش الأعلى يخفض نقطة التعادل، والتحول نحو المنتجات ذات الهامش الأقل يرفعها.'],
    keyPoints: ['Uses weighted average contribution margin', 'Sales mix affects the break-even point', 'Higher-margin products lower BEP'],
    keyPointsAr: ['يستخدم المتوسط المرجح لهامش المساهمة', 'مزيج المبيعات يؤثر على نقطة التعادل', 'المنتجات ذات الهامش الأعلى تخفض نقطة التعادل'],
  ),
  BreakEvenSlide(
    id: 'section-be-9',
    number: 'BE.10',
    title: 'Sensitivity Analysis',
    titleAr: 'تحليل الحساسية',
    content: ['Sensitivity analysis examines how changes in key variables (selling price, variable costs, fixed costs) affect the break-even point.', 'A small price increase can significantly lower BEP, while a price decrease raises it. This helps managers understand pricing power.', 'What-if scenarios test different combinations: What if rent increases 10%? What if raw material costs drop 5%? What if we raise prices 8%?', 'This analysis helps identify which variables have the greatest impact on profitability, guiding management attention to the most critical factors.'],
    contentAr: ['يفحص تحليل الحساسية كيف تؤثر التغييرات في المتغيرات الرئيسية (سعر البيع، التكاليف المتغيرة، التكاليف الثابتة) على نقطة التعادل.', 'زيادة صغيرة في السعر يمكن أن تخفض نقطة التعادل بشكل كبير، بينما انخفاض السعر يرفعها. هذا يساعد المديرين على فهم قوة التسعير.', 'سيناريوهات ماذا لو تختبر مجموعات مختلفة: ماذا لو ارتفع الإيجار 10%؟ ماذا لو انخفضت تكاليف المواد الخام 5%؟ ماذا لو رفعنا الأسعار 8%؟', 'يساعد هذا التحليل في تحديد المتغيرات ذات التأثير الأكبر على الربحية، مما يوجه انتباه الإدارة إلى العوامل الأكثر أهمية.'],
    keyPoints: ['Tests impact of changing key variables', 'Price changes have outsized impact on BEP', 'Identifies most critical profit drivers'],
    keyPointsAr: ['يختبر تأثير تغيير المتغيرات الرئيسية', 'تغييرات الأسعار لها تأثير كبير على نقطة التعادل', 'يحدد أهم محركات الربح'],
  ),
  BreakEvenSlide(
    id: 'section-be-assumptions',
    number: 'BE.11',
    title: 'Operating Leverage',
    titleAr: 'الرافعة التشغيلية',
    content: ['Operating leverage measures how sensitive operating income is to changes in sales volume. It is driven by cost structure: the higher the proportion of fixed costs, the higher the operating leverage. The degree of operating leverage (DOL) at a given sales level equals Contribution Margin / Operating Income.', 'A firm with high operating leverage earns more from each additional sale once fixed costs are covered, but suffers larger losses when sales fall. A DOL of 4 means a 10% increase in sales raises operating income by roughly 40% - and a 10% decline cuts it by roughly 40%.'],
    contentAr: ['تقيس الرافعة التشغيلية مدى حساسية الدخل التشغيلي للتغيرات في حجم المبيعات. وهي مدفوعة بهيكل التكاليف: فكلما ارتفعت نسبة التكاليف الثابتة، ارتفعت الرافعة التشغيلية. ودرجة الرافعة التشغيلية عند مستوى مبيعات معين تساوي هامش المساهمة / الدخل التشغيلي.', 'الشركة ذات الرافعة التشغيلية المرتفعة تكسب أكثر من كل عملية بيع إضافية بعد تغطية التكاليف الثابتة، لكنها تتكبد خسائر أكبر عند انخفاض المبيعات. درجة رافعة تساوي 4 تعني أن زيادة المبيعات بنسبة 10% ترفع الدخل التشغيلي بنحو 40% - وأن انخفاضها بنسبة 10% يخفضه بنحو 40%.'],
    keyPoints: ['DOL = Contribution Margin / Operating Income', 'Higher fixed costs = higher operating leverage = higher risk'],
    keyPointsAr: ['درجة الرافعة التشغيلية = هامش المساهمة / الدخل التشغيلي', 'تكاليف ثابتة أعلى = رافعة تشغيلية أعلى = مخاطر أعلى'],
    highlightType: 'tip',
    highlight: 'Operating leverage cuts both ways: the cost structure that magnifies profit on the way up magnifies loss on the way down.',
    highlightAr: 'الرافعة التشغيلية سيف ذو حدين: فهيكل التكاليف الذي يضخّم الربح صعوداً يضخّم الخسارة هبوطاً.',
  ),
  BreakEvenSlide(
    id: 'section-be-cvp-assumptions',
    number: 'BE.12',
    title: 'CVP Assumptions and the Relevant Range',
    titleAr: 'افتراضات تحليل التكلفة-الحجم-الربح والمدى الملائم',
    content: ['Break-even analysis is only valid within the five standard cost-volume-profit (CVP) assumptions listed below.', 'Outside the relevant range, these assumptions break down: bulk discounts change variable cost per unit, capacity expansions step up fixed costs, and price cuts may be needed to sell more volume. Treat the break-even point as a planning estimate that must be re-computed whenever the underlying assumptions change.'],
    contentAr: ['تحليل التعادل صالح فقط ضمن الافتراضات الخمسة القياسية لتحليل التكلفة-الحجم-الربح المدرجة أدناه.', 'خارج المدى الملائم تنهار هذه الافتراضات: فخصومات الكميات تغير التكلفة المتغيرة للوحدة، وتوسعات الطاقة الإنتاجية ترفع التكاليف الثابتة درجة، وقد يلزم خفض الأسعار لبيع حجم أكبر. تعامل مع نقطة التعادل باعتبارها تقديراً تخطيطياً يجب إعادة حسابه كلما تغيرت الافتراضات الأساسية.'],
    keyPoints: ['Total costs can be separated into fixed and variable components', 'Selling price, variable cost per unit and total fixed costs are constant, so revenue and total costs are linear in units sold', 'The analysis applies only within the relevant range, the band of activity for which those cost behaviors hold', 'For multi-product firms, the sales mix remains constant', 'Units produced equal units sold, so inventory levels do not change'],
    keyPointsAr: ['يمكن فصل إجمالي التكاليف إلى مكونات ثابتة ومتغيرة', 'سعر البيع والتكلفة المتغيرة للوحدة وإجمالي التكاليف الثابتة ثابتة، فتكون الإيرادات وإجمالي التكاليف خطية بالنسبة للوحدات المباعة', 'يسري التحليل فقط ضمن المدى الملائم، وهو نطاق النشاط الذي يظل فيه سلوك التكاليف على حاله', 'في الشركات متعددة المنتجات يبقى مزيج المبيعات ثابتاً', 'الوحدات المنتجة تساوي الوحدات المباعة، فلا تتغير مستويات المخزون'],
  ),
  BreakEvenSlide(
    id: 'section-be-10',
    number: 'BE.13',
    title: 'Summary of Break-Even Analysis',
    titleAr: 'ملخص تحليل التعادل',
    content: ['Break-even analysis is a powerful planning tool that connects costs, volume, and profit into a clear framework for decision-making.', 'Key formulas: BEP = Fixed Costs / CM per Unit. Margin of Safety = Actual Sales - BEP Sales. CM = Price - Variable Cost.', 'It supports pricing decisions, cost management, investment evaluation, and risk assessment across all types of businesses.', 'While the basic model assumes linear costs and constant prices, it provides an excellent starting point for more detailed financial planning.'],
    contentAr: ['تحليل التعادل هو أداة تخطيط قوية تربط التكاليف والحجم والربح في إطار واضح لاتخاذ القرارات.', 'الصيغ الرئيسية: نقطة التعادل = التكاليف الثابتة / هامش المساهمة. هامش الأمان = المبيعات الفعلية - مبيعات التعادل. هامش المساهمة = السعر - التكلفة المتغيرة.', 'يدعم قرارات التسعير وإدارة التكاليف وتقييم الاستثمار وتقييم المخاطر عبر جميع أنواع الأعمال.', 'بينما يفترض النموذج الأساسي تكاليف خطية وأسعار ثابتة، فإنه يوفر نقطة انطلاق ممتازة للتخطيط المالي الأكثر تفصيلاً.'],
    keyPoints: ['Connects costs, volume, and profit', 'Supports pricing, cost, and investment decisions', 'Foundation for detailed financial planning'],
    keyPointsAr: ['يربط التكاليف والحجم والربح', 'يدعم قرارات التسعير والتكاليف والاستثمار', 'أساس للتخطيط المالي التفصيلي'],
  ),
  BreakEvenSlide(
    id: 'section-be-frameworks',
    number: 'BE.14',
    title: 'Grounded in International Frameworks',
    titleAr: 'مُؤسَّس على الأطر الدولية',
    content: ['Everything in this module follows cost-volume-profit (CVP) analysis as canonized in managerial accounting. The contribution margin, break-even point in units and in revenue, target-profit volume, margin of safety, operating leverage, and the CVP assumptions presented here follow the standard treatment examined by the global professional accounting bodies.'],
    contentAr: ['كل ما ورد في هذه الوحدة يتبع تحليل التكلفة-الحجم-الربح كما هو مُكرَّس في المحاسبة الإدارية. فهامش المساهمة، ونقطة التعادل بالوحدات وبالإيرادات، وحجم الربح المستهدف، وهامش الأمان، والرافعة التشغيلية، وافتراضات التحليل المعروضة هنا تتبع المعالجة القياسية التي تختبرها الهيئات المحاسبية المهنية العالمية.'],
  ),
  BreakEvenSlide(
    id: 'section-be-framework-bodies',
    number: 'BE.15',
    title: 'The Professional Body Syllabi',
    titleAr: 'مناهج الهيئات المهنية',
    content: ['The primary anchors are the official curricula of three professional bodies, listed below.', 'In all three, CVP analysis - the model, its formulas, and the relevant-range assumptions exactly as taught in this module - is core examinable content of the management accounting curriculum used for short-term planning and decision-making.'],
    contentAr: ['المراجع الأساسية هي المناهج الرسمية لثلاث هيئات مهنية، مدرجة أدناه.', 'وفي المناهج الثلاثة يُعد تحليل التكلفة-الحجم-الربح - بنموذجه وصيغه وافتراضات المدى الملائم تماماً كما تُدرَّس في هذه الوحدة - محتوى أساسياً قابلاً للاختبار في منهج المحاسبة الإدارية المستخدم للتخطيط واتخاذ القرارات قصيرة الأجل.'],
    keyPoints: ['CIMA/CGMA Professional Qualification syllabus - CVP analysis as core management accounting content', 'IMA, CMA Content Specification Outlines - CVP in Part 1 planning and analytics', 'ACCA, Performance Management (PM) syllabus - CVP for short-term decision-making'],
    keyPointsAr: ['منهج المؤهل المهني CIMA/CGMA - تحليل التكلفة-الحجم-الربح محتوى أساسي في المحاسبة الإدارية', 'معهد IMA، مخططات محتوى شهادة CMA - التحليل ضمن الجزء الأول (التخطيط والتحليلات)', 'جمعية ACCA، منهج «إدارة الأداء» (PM) - التحليل لأغراض القرارات قصيرة الأجل'],
    highlightType: 'info',
    highlight: 'This module is aligned with these managerial accounting frameworks to ensure objective, verifiable knowledge transfer.',
    highlightAr: 'هذه الوحدة متوائمة مع أطر المحاسبة الإدارية هذه لضمان نقل معرفة موضوعية قابلة للتحقق.',
  ),
];

/// Icon + accent color per slide (by website section id; unknown ids cycle).
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

/// Renders one deck slide: number + title, paragraphs, key points, highlight
/// and examples. Scrolls inside the page so long slides never overflow.
Widget _buildBeSlideCard(BuildContext context, {
  required BreakEvenSlide slide,
  required int index,
  required int total,
  required bool ar,
  required IconData icon,
  required Color color,
}) {
  final dir = ar ? TextDirection.rtl : TextDirection.ltr;
  final align = ar ? TextAlign.right : TextAlign.left;
  final keyPoints = slide.keyPointsFor(ar);
  final highlight = slide.highlightFor(ar);
  final examples = slide.examplesFor(ar);
  final hlIcon = switch (slide.highlightType) {
    'formula' => Icons.functions_rounded,
    'warning' => Icons.warning_amber_rounded,
    'tip' => Icons.lightbulb_rounded,
    _ => Icons.info_outline_rounded,
  };
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
}

List<_PracticeScenario> _buildPracticeScenarios(AppStrings s) => <_PracticeScenario>[
  _PracticeScenario(
    title: s.tr('Coffee Shop', 'مقهى'),
    city: 'Dubai',
    currency: 'AED',
    difficulty: s.tr('Beginner', 'مبتدئ'),
    difficultyColor: AppColors.secondaryLight,
    description: s.tr('A specialty coffee shop in Dubai Marina selling premium lattes.',
        'مقهى متخصص في دبي مارينا يبيع اللاتيه الفاخر.'),
    pricePerUnit: 22,
    totalVariableCost: 7,
    variableCosts: [
      _CostItem(s.tr('Beans', 'البُن'), 3),
      _CostItem(s.tr('Milk', 'الحليب'), 2),
      _CostItem(s.tr('Cup', 'الكوب'), 1),
      _CostItem(s.tr('Sugar', 'السكر'), 0.5),
      _CostItem(s.tr('Napkin', 'المناديل'), 0.5),
    ],
    fixedCosts: 33000,
    fixedCostsBreakdown: s.tr('Rent, staff, equipment lease, utilities',
        'الإيجار، والموظفون، وإيجار المعدات، والمرافق'),
    bep: 2200,
    bepLabel: s.tr('2,200 cups/month', '2,200 كوب/شهر'),
    bepDetail: s.tr('≈ 74 cups/day', '≈ 74 كوب/يوم'),
  ),
  _PracticeScenario(
    title: s.tr('Car Wash', 'مغسلة سيارات'),
    city: 'Riyadh',
    currency: 'SAR',
    difficulty: s.tr('Beginner', 'مبتدئ'),
    difficultyColor: AppColors.secondaryLight,
    description: s.tr('A full-service car wash facility near King Fahd Road.',
        'مغسلة سيارات متكاملة الخدمات قرب طريق الملك فهد.'),
    pricePerUnit: 40,
    totalVariableCost: 12,
    variableCosts: [
      _CostItem(s.tr('Water', 'الماء'), 5),
      _CostItem(s.tr('Shampoo', 'الشامبو'), 3),
      _CostItem(s.tr('Wax', 'الشمع'), 2.5),
      _CostItem(s.tr('Towels', 'المناشف'), 1.5),
    ],
    fixedCosts: 30000,
    fixedCostsBreakdown: s.tr('Rent, equipment, staff wages',
        'الإيجار، والمعدات، وأجور الموظفين'),
    bep: 1072,
    bepLabel: s.tr('1,072 washes/month', '1,072 غسلة/شهر'),
    bepDetail: s.tr('≈ 36 washes/day', '≈ 36 غسلة/يوم'),
  ),
  _PracticeScenario(
    title: s.tr('Food Truck', 'عربة طعام'),
    city: 'Jeddah',
    currency: 'SAR',
    difficulty: s.tr('Beginner', 'مبتدئ'),
    difficultyColor: AppColors.secondaryLight,
    description: s.tr('A shawarma food truck operating along the Jeddah Corniche.',
        'عربة شاورما تعمل على كورنيش جدة.'),
    pricePerUnit: 25,
    totalVariableCost: 10,
    variableCosts: [
      _CostItem(s.tr('Chicken', 'الدجاج'), 4),
      _CostItem(s.tr('Bread', 'الخبز'), 1.5),
      _CostItem(s.tr('Vegetables', 'الخضار'), 2),
      _CostItem(s.tr('Sauces', 'الصلصات'), 1),
      _CostItem(s.tr('Packaging', 'التغليف'), 1.5),
    ],
    fixedCosts: 17000,
    fixedCostsBreakdown: s.tr('Truck lease, permit, driver salary',
        'إيجار العربة، والتصريح، وراتب السائق'),
    bep: 1134,
    bepLabel: s.tr('1,134 wraps/month', '1,134 لفافة/شهر'),
    bepDetail: s.tr('≈ 46 wraps/day', '≈ 46 لفافة/يوم'),
  ),
  _PracticeScenario(
    title: s.tr('Beauty Salon', 'صالون تجميل'),
    city: 'Abu Dhabi',
    currency: 'AED',
    difficulty: s.tr('Intermediate', 'متوسط'),
    difficultyColor: AppColors.accentLight,
    description: s.tr('A multi-service beauty salon on Al Maryah Island.',
        'صالون تجميل متعدد الخدمات في جزيرة الماريّة.'),
    isMultiProduct: true,
    products: [
      _ProductMix(s.tr('Haircut', 'قص الشعر'), 150, 120, 50),
      _ProductMix(s.tr('Makeup', 'المكياج'), 250, 180, 30),
      _ProductMix(s.tr('Mani/Pedi', 'عناية الأظافر'), 120, 95, 20),
    ],
    fixedCosts: 50000,
    fixedCostsBreakdown: s.tr('Rent 25k, Stylists 14k, Reception 6k, Utilities 3k, Insurance 2k',
        'الإيجار 25 ألفًا، المصففون 14 ألفًا، الاستقبال 6 آلاف، المرافق 3 آلاف، التأمين ألفان'),
    weightedCM: 133,
    bep: 376,
    bepLabel: s.tr('376 services/month', '376 خدمة/شهر'),
    bepDetail: s.tr('≈ 13 services/day', '≈ 13 خدمة/يوم'),
  ),
  _PracticeScenario(
    title: s.tr('Gym', 'نادٍ رياضي'),
    city: 'Jeddah',
    currency: 'SAR',
    difficulty: s.tr('Intermediate', 'متوسط'),
    difficultyColor: AppColors.accentLight,
    description: s.tr('A fitness center with tiered membership plans.',
        'مركز لياقة بدنية بخطط عضوية متدرّجة.'),
    isMultiProduct: true,
    products: [
      _ProductMix(s.tr('Basic', 'أساسي'), 200, 160, 60),
      _ProductMix(s.tr('Premium', 'مميّز'), 350, 270, 30),
      _ProductMix(s.tr('VIP', 'كبار الأعضاء'), 600, 400, 10),
    ],
    fixedCosts: 100000,
    fixedCostsBreakdown: s.tr('Rent, equipment, trainers, utilities',
        'الإيجار، والمعدات، والمدربون، والمرافق'),
    weightedCM: 217,
    bep: 461,
    bepLabel: s.tr('461 members', '461 عضوًا'),
    bepDetail: '',
  ),
  _PracticeScenario(
    title: s.tr('Grocery Store', 'بقالة'),
    city: 'Muscat',
    currency: 'OMR',
    difficulty: s.tr('Intermediate', 'متوسط'),
    difficultyColor: AppColors.accentLight,
    description: s.tr('A neighborhood grocery store with mixed product categories.',
        'بقالة حي بفئات منتجات متنوعة.'),
    isMultiProduct: true,
    products: [
      _ProductMix(s.tr('Fresh Produce', 'منتجات طازجة'), 2.00, 0.60, 40),
      _ProductMix(s.tr('Packaged', 'سلع معلّبة'), 3.50, 0.70, 45),
      _ProductMix(s.tr('Beverages', 'مشروبات'), 1.50, 0.45, 15),
    ],
    fixedCosts: 3250,
    fixedCostsBreakdown: s.tr('Rent, refrigeration, staff, license',
        'الإيجار، والتبريد، والموظفون، والترخيص'),
    weightedCM: 0.6225,
    bep: 5221,
    bepLabel: s.tr('5,221 units/month', '5,221 وحدة/شهر'),
    bepDetail: s.tr('≈ 174 units/day', '≈ 174 وحدة/يوم'),
  ),
  _PracticeScenario(
    title: s.tr('Event Management', 'إدارة الفعاليات'),
    city: 'Doha',
    currency: 'QAR',
    difficulty: s.tr('Advanced', 'متقدّم'),
    difficultyColor: AppColors.dangerLight,
    description: s.tr(
        'A premier event management company handling corporate events, weddings, and private parties.',
        'شركة رائدة في إدارة الفعاليات تتولّى الفعاليات المؤسسية والأعراس والحفلات الخاصة.'),
    isMultiProduct: true,
    products: [
      _ProductMix(s.tr('Corporate', 'فعاليات مؤسسية'), 75000, 30000, 30.8),
      _ProductMix(s.tr('Weddings', 'أعراس'), 120000, 40000, 23.1),
      _ProductMix(s.tr('Parties', 'حفلات'), 25000, 13000, 46.1),
    ],
    fixedCosts: 552000,
    fixedCostsBreakdown: s.tr('Office, full-time staff, equipment, insurance (annual)',
        'المكتب، والموظفون بدوام كامل، والمعدات، والتأمين (سنويًا)'),
    weightedCM: 24473,
    bep: 23,
    bepLabel: s.tr('23 events/year', '23 فعالية/سنة'),
    bepDetail: s.tr('≈ 2 events/month', '≈ 2 فعالية/شهر'),
  ),
];

// ──────────────────────────────────────────────────────────────────────────────
// Main Screen
// ──────────────────────────────────────────────────────────────────────────────

class BreakEvenScreen extends ConsumerStatefulWidget {
  const BreakEvenScreen({super.key});

  @override
  ConsumerState<BreakEvenScreen> createState() => _BreakEvenScreenState();
}

class _BreakEvenScreenState extends ConsumerState<BreakEvenScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  // Calculator state
  double _fixedCosts = 50000;
  double _pricePerUnit = 25;
  double _variableCostPerUnit = 15;
  // Expected sales volume (units). 0 = auto (1.5× break-even). Drives Margin of
  // Safety and Degree of Operating Leverage.
  double _expectedUnitsRaw = 0;

  // Sensitivity sliders (-50 to +50 %)
  double _priceAdj = 0;
  double _variableCostAdj = 0;
  double _fixedCostAdj = 0;

  // Learn tab page
  int _currentSlide = 0;
  PageController _pageController = PageController();
  // Resume at the last slide viewed (website a2da32f, key 'break-even').
  final LearnResumeRecorder _resume =
      LearnResumeRecorder(LearnResumeStore.breakEvenKey);

  // Practice tab expanded states
  final Set<int> _expandedScenarios = {};

  // API scenarios
  List<Map<String, dynamic>> _excelScenarios = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedTab = _tabController.index);
      }
    });
    _loadScenarios();
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

  Future<void> _loadScenarios() async {
    try {
      final repo = ref.read(educationRepositoryProvider);
      final scenarios = await repo.fetchBreakEvenScenarios();
      if (mounted) setState(() => _excelScenarios = scenarios);
    } catch (_) {}
  }

  void _applyScenario(Map<String, dynamic> scenario) {
    setState(() {
      _fixedCosts = (scenario['fixedCosts'] as num?)?.toDouble() ?? _fixedCosts;
      _pricePerUnit = (scenario['pricePerUnit'] as num?)?.toDouble() ?? _pricePerUnit;
      _variableCostPerUnit =
          (scenario['variableCostPerUnit'] as num?)?.toDouble() ?? _variableCostPerUnit;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _resume.dispose();
    super.dispose();
  }

  // ── Calculator helpers ──
  double get _contributionMargin => _pricePerUnit - _variableCostPerUnit;
  double get _breakEvenUnits =>
      _contributionMargin > 0 ? _fixedCosts / _contributionMargin : 0;
  double get _breakEvenRevenue => _breakEvenUnits * _pricePerUnit;
  /// Expected operating volume — defaults to 50% above break-even when the user
  /// has not set an explicit figure.
  double get _effectiveUnits =>
      _expectedUnitsRaw > 0 ? _expectedUnitsRaw : _breakEvenUnits * 1.5;

  double get _marginOfSafety => _effectiveUnits > 0
      ? ((_effectiveUnits - _breakEvenUnits) / _effectiveUnits) * 100
      : 0;

  // Degree of Operating Leverage at the expected volume:
  //   DOL = Total Contribution Margin / EBIT
  // Measures how sensitive operating profit is to a change in sales.
  double get _totalContribution => _effectiveUnits * _contributionMargin;
  double get _ebit => _totalContribution - _fixedCosts;
  double get _dol => _ebit.abs() > 0.0001 ? _totalContribution / _ebit : 0;

  // Adjusted values for sensitivity
  double get _adjPrice => _pricePerUnit * (1 + _priceAdj / 100);
  double get _adjVC => _variableCostPerUnit * (1 + _variableCostAdj / 100);
  double get _adjFC => _fixedCosts * (1 + _fixedCostAdj / 100);
  double get _adjCM => _adjPrice - _adjVC;
  double get _adjBEP => _adjCM > 0 ? _adjFC / _adjCM : 0;
  double get _bepChange =>
      _breakEvenUnits > 0 ? ((_adjBEP - _breakEvenUnits) / _breakEvenUnits) * 100 : 0;

  // ──────────────────────────────────────────────────────────────────────────
  // Build
  // ──────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: Text(
                        ref.watch(stringsProvider).tr('Break-Even Analysis', 'تحليل نقطة التعادل'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ).animate().fadeIn(),

              const SizedBox(height: 12),

              // ── Custom segmented tab bar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSegmentedTabs(),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

              const SizedBox(height: 8),

              // ── Tab body ──
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLearnTab(),
                    _buildCalculatorTab(),
                    _buildPracticeTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Segmented Tabs
  // ──────────────────────────────────────────────────────────────────────────

  // Website-matching tab colors
  static const _activeBlue = Color(0xFF0B5ED7);
  static const _activeBorderBlue = Color(0xFF0D6EFD);
  static const _inactiveText = Color(0xFF131B2B);

  Widget _buildSegmentedTabs() {
    final s = ref.watch(stringsProvider);
    final tabs = [
      (Icons.school_rounded, s.tr('Learn', 'تعلّم')),
      (Icons.calculate_rounded, s.tr('Calculator', 'الحاسبة')),
      (Icons.help_outline_rounded, s.tr('Practice', 'تدريب')),
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = _selectedTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => _tabController.animateTo(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: selected
                      ? (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white)
                      : Colors.transparent,
                  border: selected
                      ? Border(bottom: BorderSide(color: _activeBorderBlue, width: 2))
                      : null,
                  boxShadow: selected
                      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2)]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(tabs[i].$1,
                        size: 20,
                        color: selected
                            ? _activeBlue
                            : (isDark ? AppColors.darkTextSecondary : _inactiveText)),
                    const SizedBox(height: 2),
                    Text(
                      tabs[i].$2,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: selected
                            ? _activeBlue
                            : (isDark ? AppColors.darkTextSecondary : _inactiveText),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // LEARN TAB
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildLearnTab() {
    final s = ref.watch(stringsProvider);
    const slides = breakEvenSlides;
    return Column(
      children: [
        // Page counter
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentSlide + 1} / ${slides.length}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  color: AppColors.textTertiary(context),
                ),
              ),
              Text(
                s.tr('Swipe to navigate', 'اسحب للتنقل'),
                style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
              ),
            ],
          ),
        ),

        // PageView
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: _onSlideChanged,
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
            },
          ),
        ),

        // Dot indicators + nav buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              // Previous
              _NavCircleButton(
                icon: Icons.arrow_back_rounded,
                enabled: _currentSlide > 0,
                onTap: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              const SizedBox(width: 8),
              // Dots
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(slides.length, (i) {
                        final active = i == _currentSlide;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: active ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: active
                                ? _beSlideStyle(slides[_currentSlide].id, _currentSlide).$2
                                : AppColors.borderColor(context),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Next
              _NavCircleButton(
                icon: Icons.arrow_forward_rounded,
                enabled: _currentSlide < slides.length - 1,
                onTap: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // CALCULATOR TAB
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildCalculatorTab() {
    return CustomScrollView(
      slivers: [
        // API scenario selector
        if (_excelScenarios.isNotEmpty)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                itemCount: _excelScenarios.length,
                itemBuilder: (context, index) {
                  final s = _excelScenarios[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GlassCard(
                      onTap: () => _applyScenario(s),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s['name'] as String? ?? 'Scenario ${index + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryLight,
                            ),
                          ),
                          Text(
                            s['description'] as String? ?? '',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textTertiary(context),
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ).animate().fadeIn(delay: 100.ms),
          ),

        // Calculator sliders
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calculate_rounded,
                          color: AppColors.primaryLight, size: 20),
                      const SizedBox(width: 8),
                      Text('Calculator',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _SliderInput(
                    label: 'Fixed Costs',
                    value: _fixedCosts,
                    min: 1000,
                    max: 500000,
                    prefix: 'SAR ',
                    onChanged: (v) => setState(() => _fixedCosts = v),
                  ),
                  _SliderInput(
                    label: 'Price per Unit',
                    value: _pricePerUnit,
                    min: 1,
                    max: 200,
                    prefix: 'SAR ',
                    onChanged: (v) => setState(() => _pricePerUnit = v),
                  ),
                  _SliderInput(
                    label: 'Variable Cost / Unit',
                    value: _variableCostPerUnit,
                    min: 0,
                    max: 150,
                    prefix: 'SAR ',
                    onChanged: (v) => setState(() => _variableCostPerUnit = v),
                  ),
                  _SliderInput(
                    label: 'Expected Sales (units)',
                    // Surface the auto value so the slider has a sensible start;
                    // clamp to stay within the slider's range as BEP shifts.
                    value: _effectiveUnits
                        .clamp(0, (_breakEvenUnits * 4).clamp(100, 1000000))
                        .toDouble(),
                    min: 0,
                    max: (_breakEvenUnits * 4).clamp(100, 1000000).toDouble(),
                    prefix: '',
                    onChanged: (v) => setState(() => _expectedUnitsRaw = v),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),
          ),
        ),

        // Result cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _ResultCard('Break-Even Units', _breakEvenUnits.toStringAsFixed(0),
                    Icons.flag_rounded, AppColors.primaryLight),
                _ResultCard(
                    'Break-Even Revenue',
                    'SAR ${_breakEvenRevenue.toStringAsFixed(0)}',
                    Icons.attach_money_rounded,
                    AppColors.secondaryLight),
                _ResultCard(
                    'Contribution Margin',
                    'SAR ${_contributionMargin.toStringAsFixed(2)}',
                    Icons.trending_up_rounded,
                    AppColors.accentLight),
                _ResultCard('Margin of Safety', '${_marginOfSafety.toStringAsFixed(1)}%',
                    Icons.shield_rounded, const Color(0xFF06B6D4)),
                _ResultCard(
                    'Operating Leverage (DOL)',
                    _ebit <= 0 ? '—' : '${_dol.toStringAsFixed(2)}×',
                    Icons.bolt_rounded,
                    AppColors.purple),
              ],
            ).animate().fadeIn(delay: 400.ms),
          ),
        ),

        // Chart
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Break-Even Chart',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  SizedBox(height: 250, child: _buildChart()),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Legend('Revenue', AppColors.secondaryLight),
                      const SizedBox(width: 16),
                      _Legend('Total Cost', AppColors.dangerLight),
                      const SizedBox(width: 16),
                      _Legend('Fixed Cost', AppColors.accentLight),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 600.ms),
          ),
        ),

        // ── Sensitivity Analysis ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: GlassCard(
              borderColor: const Color(0xFFF97316).withValues(alpha: 0.3),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tune_rounded, color: Color(0xFFF97316), size: 20),
                      const SizedBox(width: 8),
                      Text('Sensitivity Analysis',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Adjust percentages to see how changes impact break-even',
                    style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                  ),
                  const SizedBox(height: 16),
                  _SensitivitySlider(
                    label: 'Price',
                    value: _priceAdj,
                    color: AppColors.secondaryLight,
                    onChanged: (v) => setState(() => _priceAdj = v),
                  ),
                  _SensitivitySlider(
                    label: 'Variable Cost',
                    value: _variableCostAdj,
                    color: AppColors.dangerLight,
                    onChanged: (v) => setState(() => _variableCostAdj = v),
                  ),
                  _SensitivitySlider(
                    label: 'Fixed Cost',
                    value: _fixedCostAdj,
                    color: AppColors.accentLight,
                    onChanged: (v) => setState(() => _fixedCostAdj = v),
                  ),
                  const SizedBox(height: 12),
                  // Impact summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: (_bepChange <= 0
                              ? AppColors.secondaryLight
                              : AppColors.dangerLight)
                          .withValues(alpha: 0.08),
                      border: Border.all(
                        color: (_bepChange <= 0
                                ? AppColors.secondaryLight
                                : AppColors.dangerLight)
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Original BEP',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textTertiary(context))),
                              Text(
                                '${_breakEvenUnits.toStringAsFixed(0)} units',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_rounded,
                            size: 20, color: AppColors.textTertiary(context)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Adjusted BEP',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textTertiary(context))),
                              Text(
                                '${_adjBEP.toStringAsFixed(0)} units',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: _bepChange <= 0
                                      ? AppColors.secondaryLight
                                      : AppColors.dangerLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: (_bepChange <= 0
                                    ? AppColors.secondaryLight
                                    : AppColors.dangerLight)
                                .withValues(alpha: 0.15),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _bepChange <= 0
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded,
                                size: 14,
                                color: _bepChange <= 0
                                    ? AppColors.secondaryLight
                                    : AppColors.dangerLight,
                              ),
                              Text(
                                '${_bepChange.abs().toStringAsFixed(1)}%',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: _bepChange <= 0
                                      ? AppColors.secondaryLight
                                      : AppColors.dangerLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_priceAdj != 0 || _variableCostAdj != 0 || _fixedCostAdj != 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => setState(() {
                            _priceAdj = 0;
                            _variableCostAdj = 0;
                            _fixedCostAdj = 0;
                          }),
                          icon: const Icon(Icons.refresh_rounded, size: 16),
                          label: const Text('Reset'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textTertiary(context),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ).animate().fadeIn(delay: 800.ms),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildChart() {
    final maxUnits = _breakEvenUnits * 2;
    if (maxUnits <= 0) {
      return Center(
        child: Text(
          'Adjust values to see chart\n(Price must exceed Variable Cost)',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textTertiary(context)),
        ),
      );
    }
    return LineChart(LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (v) => FlLine(
          color: AppColors.borderColor(context).withValues(alpha: 0.3),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: (v, _) => Text(
              'SAR ${(v / 1000).toInt()}k',
              style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context)),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, _) => Text(
              '${v.toInt()}',
              style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context)),
            ),
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        // Total cost line
        LineChartBarData(
          spots: List.generate(11, (i) {
            final u = i * (maxUnits / 10);
            return FlSpot(u, _fixedCosts + u * _variableCostPerUnit);
          }),
          isCurved: false,
          color: AppColors.dangerLight,
          barWidth: 2,
          dotData: const FlDotData(show: false),
        ),
        // Revenue line
        LineChartBarData(
          spots: List.generate(11, (i) {
            final u = i * (maxUnits / 10);
            return FlSpot(u, u * _pricePerUnit);
          }),
          isCurved: false,
          color: AppColors.secondaryLight,
          barWidth: 2,
          dotData: const FlDotData(show: false),
        ),
        // Fixed cost line
        LineChartBarData(
          spots: List.generate(11, (i) {
            final u = i * (maxUnits / 10);
            return FlSpot(u, _fixedCosts);
          }),
          isCurved: false,
          color: AppColors.accentLight,
          barWidth: 1,
          dashArray: [4, 4],
          dotData: const FlDotData(show: false),
        ),
      ],
    ));
  }

  // ──────────────────────────────────────────────────────────────────────────
  // PRACTICE TAB
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildPracticeTab() {
    final str = ref.watch(stringsProvider);
    final scenarios = _buildPracticeScenarios(str);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: scenarios.length,
      itemBuilder: (context, i) {
        final s = scenarios[i];
        final expanded = _expandedScenarios.contains(i);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            borderColor: expanded
                ? s.difficultyColor.withValues(alpha: 0.4)
                : null,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Header (always visible)
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => setState(() {
                    if (expanded) {
                      _expandedScenarios.remove(i);
                    } else {
                      _expandedScenarios.add(i);
                    }
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Number circle
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: s.difficultyColor.withValues(alpha: 0.15),
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: s.difficultyColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${s.title} - ${s.city}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                s.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textTertiary(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Difficulty badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: s.difficultyColor.withValues(alpha: 0.15),
                          ),
                          child: Text(
                            s.difficulty,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: s.difficultyColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedRotation(
                          turns: expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textTertiary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Expanded content
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: _buildScenarioDetails(s),
                  crossFadeState: expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ).animate().fadeIn(delay: (80 * i).ms).slideY(begin: 0.05),
        );
      },
    );
  }

  Widget _buildScenarioDetails(_PracticeScenario s) {
    final str = ref.watch(stringsProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: AppColors.borderColor(context), height: 1),
          const SizedBox(height: 14),

          // Multi-product table or single product info
          if (s.isMultiProduct && s.products != null) ...[
            _sectionLabel(str.tr('Product Mix', 'مزيج المنتجات'), Icons.category_rounded),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.cardColor(context).withValues(alpha: 0.5),
              ),
              child: Column(
                children: [
                  // Header row
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(str.tr('Service', 'الخدمة'),
                                style: _tableHeaderStyle(context))),
                        Expanded(
                            flex: 2,
                            child: Text(str.tr('Price', 'السعر'),
                                style: _tableHeaderStyle(context),
                                textAlign: TextAlign.right)),
                        Expanded(
                            flex: 2,
                            child: Text(str.tr('CM', 'هامش المساهمة'),
                                style: _tableHeaderStyle(context),
                                textAlign: TextAlign.right)),
                        Expanded(
                            flex: 2,
                            child: Text(str.tr('Mix', 'المزيج'),
                                style: _tableHeaderStyle(context),
                                textAlign: TextAlign.right)),
                      ],
                    ),
                  ),
                  ...s.products!.map((p) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color:
                                  AppColors.borderColor(context).withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text(p.name,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textPrimary(context)))),
                            Expanded(
                              flex: 2,
                              child: Text(
                                _fmtNum(p.price, s.currency),
                                style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    color: AppColors.textSecondary(context)),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                _fmtNum(p.cm, s.currency),
                                style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    color: AppColors.secondaryLight),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${p.mixPercent}%',
                                style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    color: AppColors.textSecondary(context)),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (s.weightedCM != null)
              _formulaRow(
                  str.tr('Weighted CM', 'هامش المساهمة المرجّح'),
                  '${s.currency} ${_fmtDouble(s.weightedCM!)}'),
          ] else ...[
            _sectionLabel(str.tr('Cost Breakdown', 'تفصيل التكاليف'), Icons.receipt_long_rounded),
            const SizedBox(height: 8),
            // Price
            _infoRow(str.tr('Selling Price', 'سعر البيع'), '${s.currency} ${_fmtDouble(s.pricePerUnit)}',
                AppColors.primaryLight),
            const SizedBox(height: 6),
            // Variable costs
            ...s.variableCosts.map((c) => _infoRow(
                  '  ${c.name}',
                  '${s.currency} ${_fmtDouble(c.cost)}',
                  AppColors.textTertiary(context),
                )),
            const SizedBox(height: 4),
            _infoRow(str.tr('Total Variable Cost', 'إجمالي التكلفة المتغيرة'),
                '${s.currency} ${_fmtDouble(s.totalVariableCost)}', AppColors.dangerLight),
            const SizedBox(height: 4),
            _formulaRow(str.tr('Contribution Margin', 'هامش المساهمة'),
                '${s.currency} ${_fmtDouble(s.pricePerUnit - s.totalVariableCost)}'),
          ],

          const SizedBox(height: 12),

          // Fixed costs
          _sectionLabel(str.tr('Fixed Costs', 'التكاليف الثابتة'), Icons.lock_rounded),
          const SizedBox(height: 6),
          _infoRow(str.tr('Monthly Fixed Costs', 'التكاليف الثابتة الشهرية'),
              '${s.currency} ${_fmtDouble(s.fixedCosts)}', AppColors.dangerLight),
          if (s.fixedCostsBreakdown.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                s.fixedCostsBreakdown,
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary(context),
                    fontStyle: FontStyle.italic),
              ),
            ),

          const SizedBox(height: 14),

          // Solution box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  s.difficultyColor.withValues(alpha: 0.1),
                  s.difficultyColor.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(color: s.difficultyColor.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 16, color: s.difficultyColor),
                    const SizedBox(width: 6),
                    Text(
                      str.tr('Solution', 'الحل'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: s.difficultyColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  str.tr('Break-Even Point:', 'نقطة التعادل:'),
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textSecondary(context)),
                ),
                const SizedBox(height: 4),
                Text(
                  s.bepLabel,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: s.difficultyColor,
                  ),
                ),
                if (s.bepDetail.isNotEmpty)
                  Text(
                    s.bepDetail,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 13,
                      color: AppColors.textTertiary(context),
                    ),
                  ),
              ],
            ),
          ),

          // "Try in Calculator" button for single-product scenarios
          if (!s.isMultiProduct)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _fixedCosts = s.fixedCosts;
                      _pricePerUnit = s.pricePerUnit;
                      _variableCostPerUnit = s.totalVariableCost;
                      _priceAdj = 0;
                      _variableCostAdj = 0;
                      _fixedCostAdj = 0;
                    });
                    _tabController.animateTo(1);
                  },
                  icon: const Icon(Icons.calculate_rounded, size: 16),
                  label: Text(str.tr('Try in Calculator', 'جرّب في الحاسبة')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryLight,
                    side: BorderSide(
                        color: AppColors.primaryLight.withValues(alpha: 0.4)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Helpers ──

  Widget _sectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textTertiary(context)),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary(context),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
        Text(value,
            style: GoogleFonts.jetBrainsMono(
                fontSize: 12, fontWeight: FontWeight.w600, color: valueColor)),
      ],
    );
  }

  Widget _formulaRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.secondaryLight.withValues(alpha: 0.08),
        border:
            Border.all(color: AppColors.secondaryLight.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryLight)),
          Text(value,
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryLight)),
        ],
      ),
    );
  }

  TextStyle _tableHeaderStyle(BuildContext context) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: AppColors.textTertiary(context),
      letterSpacing: 0.5,
    );
  }

  String _fmtNum(double n, String currency) {
    if (n >= 1000) {
      return n.toStringAsFixed(0);
    }
    return n.toStringAsFixed(n == n.roundToDouble() ? 0 : 2);
  }

  String _fmtDouble(double n) {
    if (n >= 1000) return n.toStringAsFixed(0);
    if (n == n.roundToDouble()) return n.toStringAsFixed(0);
    // Show up to 4 decimal places if needed (for small numbers like OMR)
    final s = n.toStringAsFixed(4);
    // Trim trailing zeros
    return s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Reusable private widgets
// ──────────────────────────────────────────────────────────────────────────────

class _NavCircleButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _NavCircleButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? AppColors.primaryLight.withValues(alpha: 0.15)
              : AppColors.borderColor(context).withValues(alpha: 0.3),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.primaryLight : AppColors.textTertiary(context),
        ),
      ),
    );
  }
}

class _SliderInput extends StatelessWidget {
  final String label;
  final double value;
  final double min, max;
  final String prefix;
  final ValueChanged<double> onChanged;

  const _SliderInput({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.prefix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Text(
              '$prefix${value.toStringAsFixed(0)}',
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 14, color: AppColors.primaryLight),
            ),
          ]),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            activeColor: AppColors.primaryLight,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SensitivitySlider extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;

  const _SensitivitySlider({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sign = value >= 0 ? '+' : '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: color.withValues(alpha: 0.12),
              ),
              child: Text(
                '$sign${value.toStringAsFixed(0)}%',
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 13, fontWeight: FontWeight.w600, color: color),
              ),
            ),
          ]),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: color.withValues(alpha: 0.15),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.1),
              trackHeight: 3,
            ),
            child: Slider(
              value: value,
              min: -50,
              max: 50,
              divisions: 100,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;

  const _ResultCard(this.title, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: color.withValues(alpha: 0.3),
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
                fontSize: 18, fontWeight: FontWeight.w700, color: color),
          ),
          const SizedBox(height: 4),
          Text(title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final String label;
  final Color color;
  const _Legend(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 3, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary(context))),
      ],
    );
  }
}
