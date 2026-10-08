// Generator: emit lib/features/education/modules/data/module<N>_data.dart for the FinPlay app
// from the website's bilingual education content (extends scripts/gen-mobile-module.ts).
//
// Run from the web repo dir so tsconfig paths resolve:
//   npx tsx --tsconfig tsconfig.json <this file> <outDir>
import * as fs from 'node:fs';
import * as path from 'node:path';

const W =
  '/Users/asaadalsharif/Desktop/VIFM Git/finance-gamification/client/src/data/education-modules/';
const imp = (f: string) => import(W + f + '.ts');

type BiT = { en: string; ar: string } | string | undefined | null;

function dq(s: string): string {
  return (s ?? '')
    .replace(/\\/g, '\\\\')
    .replace(/'/g, "\\'")
    .replace(/\$/g, '\\$')
    .replace(/\r?\n/g, '\\n');
}
const q = (s: string) => `'${dq(s)}'`;
function en(b: BiT): string {
  if (!b) return '';
  return typeof b === 'string' ? b : b.en ?? '';
}
function ar(b: BiT): string {
  if (!b) return '';
  return typeof b === 'string' ? '' : b.ar ?? '';
}
function bi(b: BiT): string {
  const e = en(b);
  const a = ar(b);
  return a ? `Bi(${q(e)}, ${q(a)})` : `Bi(${q(e)})`;
}

// ── slides + key terms ─────────────────────────────────────────────────────
function slides(sections: any[]): string {
  const rows = sections.map((sec) => {
    const parts: string[] = [
      `'id': ${q(sec.id)}`,
      `'number': ${q(sec.number)}`,
      `'title': ${q(`${sec.number} ${en(sec.title)}`)}`,
      `'titleAr': ${q(`${sec.number} ${ar(sec.title)}`)}`,
      `'content': ${q(sec.content.en.join('\n\n'))}`,
      `'contentAr': ${q((sec.content.ar || []).join('\n\n'))}`,
    ];
    const kEn = (sec.keyPoints?.en || []).join(' • ');
    const kAr = (sec.keyPoints?.ar || []).join(' • ');
    if (kEn) parts.push(`'keyPoint': ${q(kEn)}`);
    if (kAr) parts.push(`'keyPointAr': ${q(kAr)}`);
    if (sec.highlight) {
      parts.push(`'highlightType': ${q(sec.highlight.type)}`);
      parts.push(`'highlight': ${q(en(sec.highlight.text))}`);
      if (ar(sec.highlight.text)) parts.push(`'highlightAr': ${q(ar(sec.highlight.text))}`);
    }
    if (sec.examples && sec.examples.items?.length) {
      parts.push(`'examplesTitle': ${q(en(sec.examples.title))}`);
      if (ar(sec.examples.title)) parts.push(`'examplesTitleAr': ${q(ar(sec.examples.title))}`);
      parts.push(`'examples': ${q(sec.examples.items.map((i: any) => en(i)).join('\n'))}`);
      const exAr = sec.examples.items.map((i: any) => ar(i));
      if (exAr.every((x: string) => x)) parts.push(`'examplesAr': ${q(exAr.join('\n'))}`);
    }
    if (sec.keyTerms?.length) parts.push(`'keyTerms': ${q(sec.keyTerms.join(','))}`);
    return `    {${parts.join(', ')}},`;
  });
  return `  slides: [\n${rows.join('\n')}\n  ],`;
}

function keyTerms(sections: any[], pairs: any[], MODULE_TERMS: any[]): string {
  // Website Key Terms popover: the glossary entries each slide references (with IFRS
  // definitions), then the module's memory-match vocabulary not already listed (enriched
  // with a glossary definition when the English label matches).
  const byId = new Map<string, any>();
  const byTerm = new Map<string, any>();
  for (const t of MODULE_TERMS) {
    byId.set(t.id, t);
    byTerm.set(en(t.term).toLowerCase(), t);
  }
  const seen = new Set<string>();
  const rows: string[] = [];
  const push = (termEn: string, termAr: string, g: any | undefined) => {
    const k = termEn.toLowerCase().trim();
    if (!k || seen.has(k)) return;
    seen.add(k);
    const parts = [`'term': ${q(termEn)}`, `'termAr': ${q(termAr)}`];
    if (g) {
      parts.push(`'def': ${q(en(g.definition))}`);
      parts.push(`'defAr': ${q(ar(g.definition))}`);
    }
    rows.push(`    {${parts.join(', ')}},`);
  };
  for (const sec of sections) {
    for (const id of sec.keyTerms || []) {
      const g = byId.get(id);
      if (g) push(en(g.term), ar(g.term), g);
    }
  }
  for (const p of pairs) push(p.english, p.arabic, byTerm.get(String(p.english).toLowerCase()));
  return `  keyTerms: [\n${rows.join('\n')}\n  ],`;
}

// ── activities ─────────────────────────────────────────────────────────────
type Act = {
  id: string;
  tab: 'practice' | 'games' | 'sim';
  kind: string;
  title: BiT;
  description: BiT;
  maxScore: number;
  body: string; // extra named args
};

function quizBody(questions: any[]): string {
  const rows = questions.map((x) => {
    const opts = x.options.map((o: any) => bi(o)).join(', ');
    return `        QuizQuestion(id: ${q(x.id)}, question: ${bi(x.question)}, options: [${opts}], correctIndex: ${x.correctAnswer}, explanation: ${bi(x.explanation)}),`;
  });
  return `questions: [\n${rows.join('\n')}\n      ],`;
}

function memoryBody(pairs: any[]): string {
  const rows = pairs.map(
    (p) => `        MemoryPair(id: ${q(p.id)}, term: ${q(p.english)}, match: ${q(p.arabic)}),`
  );
  return `pairs: [\n${rows.join('\n')}\n      ],`;
}

function classBody(defs: Record<string, any>, items: any[], catKey = 'correctCategory'): string {
  const cats = Object.entries(defs).map(([id, d]: [string, any]) => {
    const desc = d.description ?? d.statement ?? d.altName;
    return `        ClassCategory(id: ${q(id)}, name: ${bi(d.name)}, description: ${bi(desc)}),`;
  });
  const used = new Set(items.map((i) => i[catKey]));
  for (const u of used) if (!(u in defs)) throw new Error('missing category ' + u);
  const its = items.map(
    (i) =>
      `        ClassItem(id: ${q(i.id)}, name: ${bi(i.name)}, category: ${q(i[catKey])}${i.hint ? `, hint: ${bi(i.hint)}` : ''}),`
  );
  return `categories: [\n${cats.join('\n')}\n      ],\n      items: [\n${its.join('\n')}\n      ],`;
}

function orderingBody(cfg: any): string {
  const sorted = [...cfg.items].sort((a: any, b: any) => a.correctPosition - b.correctPosition);
  const rows = sorted.map(
    (i: any) =>
      `        OrderStep(id: ${q(i.id)}, name: ${bi(i.name)}${i.description ? `, description: ${bi(i.description)}` : ''}${i.hint ? `, hint: ${bi(i.hint)}` : ''}),`
  );
  return `instruction: ${bi(cfg.instructions)},\n      steps: [\n${rows.join('\n')}\n      ],`;
}

function num(n: any): string {
  if (n === undefined || n === null) return 'null';
  const v = Number(n);
  return Number.isInteger(v) ? `${v}.0` : `${v}`;
}

function calcBody(cfg: any): string {
  const probs = cfg.problems.map((p: any) => {
    const fields = p.fields.map((f: any) => {
      const parts = [
        `id: ${q(f.id)}`,
        `label: ${bi(f.label)}`,
        `type: CalcFieldType.${f.type}`,
      ];
      if (f.value !== undefined) parts.push(`value: ${num(f.value)}`);
      if (f.correctAnswer !== undefined) parts.push(`correctAnswer: ${num(f.correctAnswer)}`);
      if (f.unit) parts.push(`unit: ${q(f.unit)}`);
      if (f.formula) parts.push(`formula: ${q(f.formula)}`);
      if (f.tolerance !== undefined) parts.push(`tolerance: ${num(f.tolerance)}`);
      if (f.hint) parts.push(`hint: ${bi(f.hint)}`);
      return `            CalcField(${parts.join(', ')}),`;
    });
    return `        CalcProblem(id: ${q(p.id)}, title: ${bi(p.title)}, scenario: ${bi(p.scenario)}${p.explanation ? `, explanation: ${bi(p.explanation)}` : ''}, fields: [\n${fields.join('\n')}\n          ]),`;
  });
  return `instruction: ${bi(cfg.instructions)},\n      problems: [\n${probs.join('\n')}\n      ],`;
}

function scenarioBody(cfg: any): string {
  const sc = cfg.scenarios.map((s: any) => {
    const steps = s.steps.map((st: any) => {
      const opts = st.options.map((o: any) => {
        const parts = [bi(o.label)];
        if (o.isCorrect) parts.push('isCorrect: true');
        parts.push(`feedback: ${bi(o.feedback)}`);
        if (o.consequence) parts.push(`consequence: ${bi(o.consequence)}`);
        return `                CaseOption(${parts.join(', ')}),`;
      });
      const data = (st.data || []).map(
        (d: any) => `CaseDatum(${bi(d.label)}, ${q(String(d.value))})`
      );
      const parts = [
        `id: ${q(st.id)}`,
        `type: CaseStepType.${st.stepType}`,
        `title: ${bi(st.title)}`,
        `description: ${bi(st.description)}`,
      ];
      if (st.context) parts.push(`context: ${bi(st.context)}`);
      if (data.length) parts.push(`data: [${data.join(', ')}]`);
      parts.push(`question: ${bi(st.question)}`);
      return `            CaseStep(${parts.join(', ')}, options: [\n${opts.join('\n')}\n            ]),`;
    });
    const parts = [
      `id: ${q(s.id)}`,
      `title: ${bi(s.title)}`,
      `role: ${bi(s.role)}`,
      `overview: ${bi(s.overview)}`,
    ];
    if (s.finalSummary) parts.push(`finalSummary: ${bi(s.finalSummary)}`);
    return `        CaseScenario(${parts.join(', ')}, steps: [\n${steps.join('\n')}\n          ]),`;
  });
  return `instruction: ${bi(cfg.instructions)},\n      scenarios: [\n${sc.join('\n')}\n      ],`;
}

function actDart(a: Act): string {
  return `    ModuleActivity(
      id: ${q(a.id)},
      tab: ActivityTab.${a.tab},
      kind: ActivityKind.${a.kind},
      title: ${bi(a.title)},
      description: ${bi(a.description)},
      maxScore: ${a.maxScore},
      ${a.body}
    ),`;
}

// ── per-module specs (mirror client/src/pages/education-modules/*.tsx) ──────
const MEM_DESC = {
  en: 'Match English terms with Arabic translations',
  ar: 'طابق المصطلحات الإنجليزية مع العربية',
};

async function spec(n: number): Promise<{ title: any; sections: any[]; pairs: any[]; acts: Act[] }> {
  const terms = await imp(`module${n}-terms`);
  const content = await imp(`module${n}-content`);
  const pairs = terms[`MODULE_${n}_MEMORY_MATCH_PAIRS`];
  const memCfg = terms[`MODULE_${n}_MEMORY_MATCH_CONFIG`];
  const sections = content[`MODULE_${n}_SECTIONS`];
  const title = content[`MODULE_${n}_TITLE`];
  const quizM = await imp(`module${n}-quiz`);
  const quizQs = quizM[`MODULE_${n}_QUIZ_QUESTIONS`];
  const quizCfg = quizM[`MODULE_${n}_QUIZ_CONFIG`];
  const quiz = (description: BiT = quizCfg.description): Act => ({
    id: 'quiz',
    tab: 'practice',
    kind: 'quiz',
    title: quizCfg.title,
    description,
    maxScore: quizCfg.maxScore,
    body: quizBody(quizQs),
  });
  const memory = (t: BiT = memCfg.title, d: BiT = MEM_DESC, max = memCfg.maxScore): Act => ({
    id: 'memoryMatch',
    tab: 'games',
    kind: 'memoryMatch',
    title: t,
    description: d,
    maxScore: max,
    body: memoryBody(pairs),
  });
  const twenty = { en: '20 questions', ar: '20 سؤال' };
  const acts: Act[] = [];
  switch (n) {
    case 1: {
      const st = await imp('module1-statements');
      acts.push(quiz());
      acts.push(
        memory(memCfg.title, {
          en: 'Match English terms with their Arabic translations',
          ar: 'طابق المصطلحات الإنجليزية مع ترجماتها العربية',
        })
      );
      acts.push({
        id: 'statementBuilder',
        tab: 'sim',
        kind: 'statementBuilder',
        title: { en: 'Financial Statement Builder', ar: 'بناء القوائم المالية' },
        description: {
          en: 'Place items in the correct financial statement',
          ar: 'ضع البنود في القائمة المالية الصحيحة',
        },
        maxScore: 100,
        body: classBody(st.STATEMENT_DEFINITIONS, st.STATEMENT_ITEMS, 'correctStatement'),
      });
      break;
    }
    case 2: {
      const cl = await imp('module2-classification');
      const st = await imp('module2-statements');
      acts.push(quiz(twenty));
      acts.push(memory());
      acts.push({
        id: 'classification',
        tab: 'games',
        kind: 'classification',
        title: { en: 'Sector Classification Game', ar: 'لعبة تصنيف القطاعات' },
        description: {
          en: 'Classify items into Government or Private sector',
          ar: 'صنف العناصر إلى القطاع الحكومي أو الخاص',
        },
        maxScore: 75,
        body: classBody(cl.SECTOR_CATEGORY_DEFINITIONS, cl.SECTOR_CLASSIFICATION_ITEMS),
      });
      acts.push({
        id: 'scenarioBuilder',
        tab: 'sim',
        kind: 'statementBuilder',
        title: { en: 'Sector Scenario Builder', ar: 'بناء سيناريوهات القطاعات' },
        description: {
          en: 'Match scenarios with the appropriate sector approach',
          ar: 'حدد النهج المناسب لكل سيناريو',
        },
        maxScore: 100,
        body: classBody(st.SCENARIO_CATEGORY_DEFINITIONS, st.SCENARIO_ITEMS),
      });
      break;
    }
    case 3: {
      const cl = await imp('module3-classification');
      const st = await imp('module3-statements');
      acts.push(quiz());
      acts.push({
        id: 'classification',
        tab: 'games',
        kind: 'classification',
        title: { en: 'Statement Classification Game', ar: 'لعبة تصنيف القوائم' },
        description: { en: 'Sort items into 4 financial statements', ar: 'صنف البنود إلى 4 قوائم مالية' },
        maxScore: 75,
        body: classBody(cl.STATEMENT_CATEGORY_DEFINITIONS, cl.STATEMENT_CLASSIFICATION_ITEMS),
      });
      acts.push(memory({ en: 'Statement Terms Match', ar: 'لعبة مطابقة المصطلحات' }, MEM_DESC, 50));
      acts.push({
        id: 'statementBuilder',
        tab: 'sim',
        kind: 'statementBuilder',
        title: { en: 'Statement Item Builder', ar: 'بناء بنود القوائم المالية' },
        description: {
          en: 'Place items in the correct section of financial statements',
          ar: 'ضع البنود في القسم الصحيح من القوائم المالية',
        },
        maxScore: 100,
        body: classBody(st.STATEMENT_BUILDER_CATEGORIES, st.STATEMENT_BUILDER_ITEMS),
      });
      break;
    }
    case 4: {
      const q3 = await imp('module4-quiz3');
      const ra = await imp('module4-ratios');
      const sc = await imp('module4-scenarios');
      acts.push(quiz());
      acts.push({
        id: 'quiz3',
        tab: 'practice',
        kind: 'quiz',
        title: q3.MODULE_4_QUIZ3_CONFIG.title,
        description: q3.MODULE_4_QUIZ3_CONFIG.description,
        maxScore: q3.MODULE_4_QUIZ3_CONFIG.maxScore,
        body: quizBody(q3.MODULE_4_QUIZ3_QUESTIONS),
      });
      acts.push(memory());
      acts.push({
        id: 'ratioClassification',
        tab: 'games',
        kind: 'classification',
        title: { en: 'Ratio Classification Game', ar: 'لعبة تصنيف النسب المالية' },
        description: { en: 'Classify 25 ratios into 5 categories', ar: 'صنف 25 نسبة مالية في 5 فئات' },
        maxScore: ra.RATIO_CLASSIFICATION_GAME_CONFIG.maxScore,
        body: classBody(ra.RATIO_CATEGORY_DEFINITIONS, ra.RATIO_CLASSIFICATION_ITEMS),
      });
      const cfg = sc.FINANCIAL_ANALYSIS_SIMULATOR_CONFIG;
      acts.push({
        id: 'financialAnalysisSimulator',
        tab: 'sim',
        kind: 'caseScenario',
        title: cfg.title,
        description: {
          en: 'Apply ratio, trend, and DuPont analysis to real scenarios',
          ar: 'طبق تحليل النسب والاتجاهات وديبونت على سيناريوهات حقيقية',
        },
        maxScore: cfg.maxScore,
        body: scenarioBody(cfg),
      });
      break;
    }
    case 6: {
      const ca = await imp('module6-calculations');
      const or = await imp('module6-ordering');
      const sc = await imp('module6-scenarios');
      acts.push(quiz(twenty));
      acts.push({
        id: 'varianceCalculator',
        tab: 'practice',
        kind: 'calculator',
        title: ca.VARIANCE_CALCULATOR_CONFIG.title,
        description: { en: 'Calculate budget variances', ar: 'احسب انحرافات الميزانية' },
        maxScore: ca.VARIANCE_CALCULATOR_CONFIG.maxScore,
        body: calcBody(ca.VARIANCE_CALCULATOR_CONFIG),
      });
      acts.push(memory());
      acts.push({
        id: 'budgetCycleSequencer',
        tab: 'games',
        kind: 'ordering',
        title: or.BUDGET_CYCLE_SEQUENCER_CONFIG.title,
        description: { en: 'Arrange budget cycle phases', ar: 'رتب مراحل دورة الموازنة' },
        maxScore: or.BUDGET_CYCLE_SEQUENCER_CONFIG.maxScore,
        body: orderingBody(or.BUDGET_CYCLE_SEQUENCER_CONFIG),
      });
      const cfg = sc.BUDGET_MEETING_SIMULATOR_CONFIG;
      acts.push({
        id: 'budgetSimulator',
        tab: 'sim',
        kind: 'caseScenario',
        title: cfg.title,
        description: {
          en: 'Make decisions in budget scenarios',
          ar: 'اتخذ قرارات في سيناريوهات الموازنة',
        },
        maxScore: cfg.maxScore,
        body: scenarioBody(cfg),
      });
      break;
    }
    case 7: {
      const cl = await imp('module7-classification');
      const sc = await imp('module7-scenarios');
      acts.push(quiz(twenty));
      acts.push(memory());
      acts.push({
        id: 'standardsClassification',
        tab: 'games',
        kind: 'classification',
        title: { en: 'IFRS vs IPSAS Classification', ar: 'تصنيف IFRS مقابل IPSAS' },
        description: {
          en: 'Classify 25 items as Similar or Different',
          ar: 'صنف 25 عنصراً كمتشابه أو مختلف',
        },
        maxScore: cl.STANDARDS_CLASSIFICATION_CONFIG.maxScore,
        body: classBody(cl.STANDARDS_CATEGORY_DEFINITIONS, cl.STANDARDS_CLASSIFICATION_ITEMS),
      });
      const cfg = sc.IFRS_IPSAS_CASE_STUDIES_CONFIG;
      acts.push({
        id: 'ifrsIpsasCaseStudies',
        tab: 'sim',
        kind: 'caseScenario',
        title: cfg.title,
        description: {
          en: 'Apply IFRS vs IPSAS standards to real-world cases',
          ar: 'طبق معايير IFRS مقابل IPSAS على حالات واقعية',
        },
        maxScore: cfg.maxScore,
        body: scenarioBody(cfg),
      });
      break;
    }
    case 9: {
      const cl = await imp('module9-classification');
      const or = await imp('module9-ordering');
      const sc = await imp('module9-scenarios');
      acts.push(quiz(twenty));
      acts.push(memory());
      acts.push({
        id: 'complianceClassification',
        tab: 'games',
        kind: 'classification',
        title: { en: 'Control Classification Game', ar: 'لعبة تصنيف الضوابط' },
        description: {
          en: 'Classify 25 controls: Preventive, Detective, or Corrective',
          ar: 'صنف 25 ضابطاً: وقائي أو استكشافي أو تصحيحي',
        },
        maxScore: 75,
        body: classBody(cl.COMPLIANCE_CATEGORY_DEFINITIONS, cl.COMPLIANCE_CLASSIFICATION_ITEMS),
      });
      acts.push({
        id: 'complianceOrdering',
        tab: 'games',
        kind: 'ordering',
        title: or.COMPLIANCE_ORDERING_CONFIG.title,
        description: {
          en: 'Arrange the five compliance process steps in order',
          ar: 'رتب خطوات عملية الامتثال الخمس بالترتيب الصحيح',
        },
        maxScore: or.COMPLIANCE_ORDERING_CONFIG.maxScore,
        body: orderingBody(or.COMPLIANCE_ORDERING_CONFIG),
      });
      const cfg = sc.INTERNAL_CONTROLS_SIMULATOR_CONFIG;
      acts.push({
        id: 'internalControlsSimulator',
        tab: 'sim',
        kind: 'caseScenario',
        title: cfg.title,
        description: {
          en: 'Apply compliance and internal control principles',
          ar: 'طبق مبادئ الامتثال والضوابط الداخلية',
        },
        maxScore: cfg.maxScore,
        body: scenarioBody(cfg),
      });
      break;
    }
    case 10: {
      const cl = await imp('module10-classification');
      const or = await imp('module10-ordering');
      const sc = await imp('module10-scenarios');
      acts.push(quiz(twenty));
      acts.push(memory());
      acts.push({
        id: 'auditProcessSequencer',
        tab: 'games',
        kind: 'ordering',
        title: or.AUDIT_PROCESS_SEQUENCER_CONFIG.title,
        description: {
          en: 'Arrange the five audit phases in correct order',
          ar: 'رتب مراحل التدقيق الخمس بالترتيب الصحيح',
        },
        maxScore: or.AUDIT_PROCESS_SEQUENCER_CONFIG.maxScore,
        body: orderingBody(or.AUDIT_PROCESS_SEQUENCER_CONFIG),
      });
      acts.push({
        id: 'auditClassification',
        tab: 'games',
        kind: 'classification',
        title: { en: 'Audit Classification Game', ar: 'لعبة تصنيف التدقيق' },
        description: {
          en: 'Classify 25 audit activities into 5 audit types',
          ar: 'صنف 25 نشاط تدقيق في 5 أنواع',
        },
        maxScore: 50,
        body: classBody(cl.AUDIT_CATEGORY_DEFINITIONS, cl.AUDIT_CLASSIFICATION_ITEMS),
      });
      const cfg = sc.AUDIT_PLANNING_WORKSHOP_CONFIG;
      acts.push({
        id: 'auditPlanningWorkshop',
        tab: 'sim',
        kind: 'caseScenario',
        title: cfg.title,
        description: {
          en: 'Lead an audit planning engagement step by step',
          ar: 'قُد مهمة تخطيط التدقيق خطوة بخطوة',
        },
        maxScore: cfg.maxScore,
        body: scenarioBody(cfg),
      });
      break;
    }
    default:
      throw new Error('no spec for module ' + n);
  }
  return { title, sections, pairs, acts };
}

const outDir = process.argv[2];
const { MODULE_TERMS } = await imp('module-terms');
const summary: Record<string, any> = {};
for (const n of [1, 2, 3, 4, 6, 7, 9, 10]) {
  const s = await spec(n);
  const total = s.acts.reduce((t, a) => t + a.maxScore, 0);
  summary[n] = { slides: s.sections.length, total, acts: s.acts.map((a) => `${a.id}:${a.maxScore}`) };
  const dart = `// GENERATED from the website's bilingual education content
// (finance-gamification client/src/data/education-modules, module${n}-*.ts) by the
// FinPlay module generator. Do not hand-edit: regenerate so the app stays a faithful
// port of the website (slides, key terms, and every Practice / Games / Sim activity).
// ignore_for_file: lines_longer_than_80_chars
${s.acts.some((a) => a.kind === 'caseScenario') ? "import '../case_scenario_data.dart';\n" : ''}import '../education_module_data.dart';

const module${n}Data = EducationModuleContent(
  id: ${n},
  title: ${q(en(s.title))},
  titleAr: ${q(ar(s.title))},
${slides(s.sections)}
${keyTerms(s.sections, s.pairs, MODULE_TERMS)}
  activities: [
${s.acts.map(actDart).join('\n')}
  ],
);
`;
  fs.writeFileSync(path.join(outDir, `module${n}_data.dart`), dart);
}
console.log(JSON.stringify(summary, null, 1));
