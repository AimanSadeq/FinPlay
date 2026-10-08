import { BREAK_EVEN_SLIDES } from '/Users/asaadalsharif/Desktop/VIFM Git/finance-gamification/client/src/data/education-modules/break-even-slides-content';
import { CAPITAL_BUDGETING_SLIDES } from '/Users/asaadalsharif/Desktop/VIFM Git/finance-gamification/client/src/data/education-modules/capital-budgeting-slides-content';
import { writeFileSync } from 'fs';

function dq(s: string): string {
  return "'" + (s ?? '').replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\$/g, '\\$').replace(/\r?\n/g, '\\n') + "'";
}
const list = (a?: string[]) => `[${(a ?? []).map(dq).join(', ')}]`;

function emit(cls: string, varName: string, sections: any[]): string {
  const rows = sections.map((s) => {
    const p: string[] = [
      `id: ${dq(s.id)}`, `number: ${dq(s.number)}`,
      `title: ${dq(s.title.en)}`, `titleAr: ${dq(s.title.ar)}`,
      `content: ${list(s.content.en)}`, `contentAr: ${list(s.content.ar)}`,
    ];
    if (s.keyPoints) { p.push(`keyPoints: ${list(s.keyPoints.en)}`, `keyPointsAr: ${list(s.keyPoints.ar)}`); }
    if (s.highlight) { p.push(`highlightType: ${dq(s.highlight.type)}`, `highlight: ${dq(s.highlight.text.en)}`, `highlightAr: ${dq(s.highlight.text.ar)}`); }
    if (s.examples) {
      p.push(`examplesTitle: ${dq(s.examples.title.en)}`, `examplesTitleAr: ${dq(s.examples.title.ar)}`,
        `examples: ${list(s.examples.items.map((i: any) => i.en))}`, `examplesAr: ${list(s.examples.items.map((i: any) => i.ar))}`);
    }
    return `  ${cls}(\n    ${p.join(',\n    ')},\n  ),`;
  });
  return `const List<${cls}> ${varName} = [\n${rows.join('\n')}\n];\n`;
}
const out = process.argv[2];
writeFileSync(out + '/be.dart', emit('BreakEvenSlide', 'breakEvenSlides', BREAK_EVEN_SLIDES));
writeFileSync(out + '/cb.dart', emit('CapitalBudgetingSlide', 'capitalBudgetingSlides', CAPITAL_BUDGETING_SLIDES));
console.log(BREAK_EVEN_SLIDES.length, CAPITAL_BUDGETING_SLIDES.length);
console.log(JSON.stringify(BREAK_EVEN_SLIDES.map(s=>s.id)));
console.log(JSON.stringify(CAPITAL_BUDGETING_SLIDES.map(s=>s.id)));
