// Generates the Dart rule tables for FinPlay's "What this amount does" panel from the
// website's shared/decision-impact.ts, plus a golden fixture of describeImpact() outputs
// the Dart port is tested against. Run from the web repo root (read-only use):
//   npx tsx tool/generators/gen_impact.mts <finplayRoot>
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { pathToFileURL } from 'node:url';

const webRoot = process.cwd();
const finplay = process.argv[2];
if (!finplay) throw new Error('usage: gen_impact.ts <finplayRoot>');
const scratch = dirname(new URL(import.meta.url).pathname);

const srcPath = resolve(webRoot, 'shared/decision-impact.ts');
let src = readFileSync(srcPath, 'utf8');

function replaceOnce(from: string, to: string) {
  const n = src.split(from).length - 1;
  if (n !== 1) throw new Error(`expected exactly one "${from}" in decision-impact.ts, found ${n}`);
  src = src.replace(from, to);
}

replaceOnce("from './ppe-schedule'", `from '${resolve(webRoot, 'shared/ppe-schedule.ts')}'`);
replaceOnce("from './eosb-schedule'", `from '${resolve(webRoot, 'shared/eosb-schedule.ts')}'`);
for (const fn of ['interestLine', 'capexLine', 'opexLine', 'staffLine', 'inventoryLine']) {
  replaceOnce(`function ${fn}(`, `function __${fn}(`);
}
// Tag every builder's closure with what it is, so the generator can emit the Dart kind.
replaceOnce(
  'const RULES: Record<ImpactModule, Record<number, Rule>> = {',
  `const tag = (f: any, k: any) => Object.assign(f, { __kind: k });
const interestLine = (label: Bi) => tag(__interestLine(label), { kind: 'interest', label });
const capexLine = (row: number) => tag(__capexLine(row), { kind: 'capex', row });
const opexLine = (salesLift: boolean, extra?: Bi) =>
  tag(__opexLine(salesLift, extra), { kind: 'opex', salesLift, extra: extra ?? null });
const staffLine = (salesLift: boolean) => tag(__staffLine(salesLift), { kind: 'staff', salesLift });
const inventoryLine = () => tag(__inventoryLine(), { kind: 'inventory' });
const RULES: Record<ImpactModule, Record<number, Rule>> = {`
);
src += '\nexport { RULES, CF_NAMES, STATEMENT_NAMES };\n';

mkdirSync(scratch, { recursive: true });
const copyPath = resolve(scratch, 'decision-impact.copy.mts');
writeFileSync(copyPath, src);
const mod: any = await import(pathToFileURL(copyPath).href);
const { RULES, CF_NAMES, STATEMENT_NAMES, TEMPLATE_RATES, describeImpact } = mod;

const dq = (s: string) =>
  "'" +
  s
    .replace(/\\/g, '\\\\')
    .replace(/'/g, "\\'")
    .replace(/\$/g, '\\$')
    .replace(/\n/g, '\\n') +
  "'";
const bi = (b: { en: string; ar: string }) => `Bi(${dq(b.en)}, ${dq(b.ar)})`;

// Inline income lambdas whose text depends on the amount: known kinds, checked by the golden test.
const KNOWN_COMPUTED_INLINE: Record<string, string> = { 'investing:8': '_AmortizationIncome()' };

const perturbed: Record<string, number> = {};
for (const [k, v] of Object.entries(TEMPLATE_RATES as Record<string, number>)) {
  perturbed[k] = k === 'eosbRateMode' ? 0 : (v as number) * 1.37 + 1;
}

function incomeDart(module: string, row: number, income: any): string {
  if (income == null) return 'null';
  const k = income.__kind;
  if (k) {
    switch (k.kind) {
      case 'interest':
        return `_InterestIncome(${bi(k.label)})`;
      case 'capex':
        return `_CapexIncome(${k.row})`;
      case 'opex':
        return `_OpexIncome(${k.salesLift}${k.extra ? `, ${bi(k.extra)}` : ''})`;
      case 'staff':
        return `_StaffIncome(${k.salesLift})`;
      case 'inventory':
        return '_InventoryIncome()';
    }
    throw new Error(`unknown builder kind ${k.kind}`);
  }
  const key = `${module}:${row}`;
  if (KNOWN_COMPUTED_INLINE[key]) return KNOWN_COMPUTED_INLINE[key];
  // A fixed text per sign: must not depend on the amount's size or on the rates.
  const out: Record<string, string> = {};
  for (const lang of ['en', 'ar']) {
    for (const [sign, amts] of [
      ['plus', [1_000_000, 3_333_333]],
      ['minus', [-1_000_000, -3_333_333]],
    ] as const) {
      const texts = new Set<string>();
      for (const a of amts) for (const r of [TEMPLATE_RATES, perturbed]) texts.add(income(a, r, lang));
      if (texts.size !== 1) {
        throw new Error(`inline income for ${key} depends on the amount or rates; add a Dart kind`);
      }
      out[`${sign}.${lang}`] = [...texts][0];
    }
  }
  return `_FixedIncome(${bi({ en: out['plus.en'], ar: out['plus.ar'] })}, ${bi({
    en: out['minus.en'],
    ar: out['minus.ar'],
  })})`;
}

const lines: string[] = [];
lines.push('// GENERATED from the website\'s shared/decision-impact.ts by gen_impact.mts');
lines.push('// (from the web repo root: npx tsx gen_impact.mts <FinPlay root>). Do not edit by hand;');
lines.push('// regenerate when the web rules change (it also rewrites test/fixtures/decision_impact_golden.json).');
lines.push('// ignore_for_file: lines_longer_than_80_chars');
lines.push('');
lines.push("part of 'decision_impact.dart';");
lines.push('');
lines.push('/// Template model rates (TEMPLATE_RATES), keyed as in model_assumptions.');
lines.push('const Map<String, double> kTemplateRates = {');
for (const [k, v] of Object.entries(TEMPLATE_RATES as Record<string, number>)) {
  lines.push(`  '${k}': ${Number.isInteger(v) ? v.toFixed(1) : String(v)},`);
}
lines.push('};');
lines.push('');
lines.push('const Map<String, Bi> _statementNames = {');
for (const [k, v] of Object.entries(STATEMENT_NAMES as Record<string, any>)) lines.push(`  '${k}': ${bi(v)},`);
lines.push('};');
lines.push('');
lines.push('const Map<String, Bi> _cfNames = {');
for (const [k, v] of Object.entries(CF_NAMES as Record<string, any>)) lines.push(`  '${k}': ${bi(v)},`);
lines.push('};');
lines.push('');
lines.push('const Map<String, Map<int, _Rule>> _rules = {');
for (const [module, rows] of Object.entries(RULES as Record<string, Record<string, any>>)) {
  lines.push(`  '${module}': {`);
  for (const [row, rule] of Object.entries(rows)) {
    lines.push(`    ${row}: _Rule(`);
    lines.push(`      bsAccount: ${bi(rule.bsAccount)},`);
    lines.push(`      cashMoves: ${rule.cashMoves},`);
    lines.push(`      cf: ${rule.cf ? `'${rule.cf}'` : 'null'},`);
    lines.push(`      income: ${incomeDart(module, Number(row), rule.income)},`);
    lines.push(`      meaningPlus: ${bi(rule.meaningPlus)},`);
    lines.push(`      meaningMinus: ${bi(rule.meaningMinus)},`);
    lines.push('    ),');
  }
  lines.push('  },');
}
lines.push('};');
lines.push('');

const dartOut = resolve(finplay, 'lib/features/simulation/impact/decision_impact_rules.g.dart');
mkdirSync(dirname(dartOut), { recursive: true });
writeFileSync(dartOut, lines.join('\n'));

// Golden fixture: describeImpact() for every module/row, both signs, both languages, two rate sets.
const custom: Record<string, number> = {
  ...TEMPLATE_RATES,
  interestExpenseRate: 0.075,
  taxRate: 0.15,
  revenueMultiplier: 0.125,
  marketingROI: 0.08,
  inventoryWriteOffRate: 0.65,
  capacityPerSarOfPpe: 4,
  productivityPerMillion: 0.015,
  productivityCap: 0.04,
  marketingCarryOver: 0.4,
  lifeMachinery: 6,
  lifeBuildings: 20,
  lifeAutomation: 8,
  lifeTechnology: 4,
  lifeNewRegion: 9,
  lifeIntangibles: 7,
  eosbRateYears1to5: 0.05,
  eosbAccrualRateOfSalaryCost: 0.1,
  eosbRateMode: 0.5,
};
const rateSets: Record<string, Record<string, number>> = { template: TEMPLATE_RATES, custom };
const cases: any[] = [];
for (const module of ['financing', 'investing', 'operating']) {
  for (let row = 0; row <= 10; row++) {
    for (const amount of [1_500_000, -2_250_000, -1_234_567, 0]) {
      for (const lang of ['en', 'ar']) {
        for (const [ratesKey, rates] of Object.entries(rateSets)) {
          if ((row === 0 || row === 10 || amount === 0) && (lang === 'ar' || ratesKey === 'custom')) continue;
          cases.push({ module, row, amount, lang, rates: ratesKey, expected: describeImpact(module, row, amount, rates, lang) });
        }
      }
    }
  }
}
const goldenOut = resolve(finplay, 'test/fixtures/decision_impact_golden.json');
mkdirSync(dirname(goldenOut), { recursive: true });
writeFileSync(goldenOut, JSON.stringify({ rateSets, cases }, null, 1));
console.log(`wrote ${dartOut}\nwrote ${goldenOut} (${cases.length} cases)`);
