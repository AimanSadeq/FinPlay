// Generates FinPlay Dart data from the website's TypeScript sources.
// Run from the web repo root:  npx tsx <this file> <FinPlay repo root>
import { writeFileSync, mkdirSync, rmSync } from 'node:fs';
import { join } from 'node:path';
import { KB_ARTICLES, KB_CATEGORIES } from '/Users/asaadalsharif/Desktop/VIFM Git/finance-gamification/client/src/data/knowledge-base/index';
import { parseStandardLabel } from '/Users/asaadalsharif/Desktop/VIFM Git/finance-gamification/client/src/data/knowledge-base/standard-links';
import { financialTermsData } from '/Users/asaadalsharif/Desktop/VIFM Git/finance-gamification/client/src/data/financial-terms';
import { ARABIC_TERM_CONTENT, ARABIC_CATEGORIES } from '/Users/asaadalsharif/Desktop/VIFM Git/finance-gamification/client/src/data/financial-terms-ar';

const out = process.argv[2];
if (!out) throw new Error('usage: gen.ts <FinPlay root>');

const HEADER = (src: string) =>
  `// GENERATED FILE - DO NOT EDIT BY HAND.\n// Source: finance-gamification ${src}\n// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).\n// ignore_for_file: lines_longer_than_80_chars\n`;

function s(v: string): string {
  return (
    "'" +
    v
      .replace(/\\/g, '\\\\')
      .replace(/'/g, "\\'")
      .replace(/\$/g, '\\$')
      .replace(/\r/g, '\\r')
      .replace(/\n/g, '\\n') +
    "'"
  );
}
const bi = (b: { en: string; ar: string }) => `Bi(${s(b.en)}, ${s(b.ar)})`;
const list = (items: string[], indent = '') =>
  items.length === 0 ? '[]' : `[\n${items.map((i) => `${indent}  ${i},`).join('\n')}\n${indent}]`;

// ── Knowledge Base ────────────────────────────────────────────────────────────
const kbDir = join(out, 'lib/features/knowledge/data/articles');
rmSync(kbDir, { recursive: true, force: true });
mkdirSync(kbDir, { recursive: true });

const camel = (id: string) =>
  'kb' + id.split('-').map((p) => p[0].toUpperCase() + p.slice(1)).join('');

const imports: string[] = [];
const names: string[] = [];
for (const a of KB_ARTICLES) {
  const name = camel(a.id);
  const file = `${a.id.replace(/-/g, '_')}.dart`;
  imports.push(`import 'articles/${file}';`);
  names.push(name);
  const sections = a.sections.map((sec) => {
    const parts = [
      `heading: ${bi(sec.heading)}`,
      `paragraphs: ${list(sec.paragraphs.map(bi), '      ')}`,
    ];
    if (sec.formulas?.length)
      parts.push(
        `formulas: ${list(
          sec.formulas.map(
            (f) => `KBFormula(${s(f.formula)}${f.caption ? `, caption: ${bi(f.caption)}` : ''})`
          ),
          '      '
        )}`
      );
    if (sec.bullets?.length) parts.push(`bullets: ${list(sec.bullets.map(bi), '      ')}`);
    if (sec.table)
      parts.push(
        `table: KBTable(\n        headers: ${list(sec.table.headers.map(bi), '        ')},\n        rows: ${list(
          sec.table.rows.map((r) => list(r.map(bi), '          ')),
          '        '
        )},\n      )`
      );
    return `KBSection(\n      ${parts.join(',\n      ')},\n    )`;
  });
  const standards = a.standards.map((st) => {
    const segs = parseStandardLabel(st.standard).map(
      (g) =>
        `KBStandardSegment(${s(g.text)}${g.href ? `, href: ${s(g.href)}` : ''}${
          g.viaIndex ? ', viaIndex: true' : ''
        })`
    );
    return `KBStandardRef(\n      standard: ${s(st.standard)},\n      note: ${bi(st.note)},\n      segments: ${list(segs, '      ')},\n    )`;
  });
  const body = `${HEADER(`client/src/data/knowledge-base/articles/${a.id}.ts`)}
import '../kb_models.dart';

const ${name} = KBArticle(
  id: ${s(a.id)},
  title: ${bi(a.title)},
  category: ${s(a.category)},
  level: KBLevel.${a.level},
  readingMinutes: ${a.readingMinutes},
  summary: ${bi(a.summary)},
  sections: ${list(sections, '  ')},
  pitfalls: ${list(a.pitfalls.map(bi), '  ')},
  standards: ${list(standards, '  ')},
  relatedTerms: ${list(a.relatedTerms.map(s), '  ')},
  relatedModules: ${list(a.relatedModules.map((m) => `KBRelatedModule(${s(m.href)}, ${bi(m.label)})`), '  ')},
  relatedArticles: ${list(a.relatedArticles.map(s), '  ')},
  references: ${list(a.references.map(s), '  ')},
  keywords: ${list(a.keywords.map(s), '  ')},
);
`;
  writeFileSync(join(kbDir, file), body);
}

const cats = KB_CATEGORIES.map(
  (c) => `KBCategory(${s(c.id)}, label: ${bi(c.label)}, description: ${bi(c.description)})`
);
writeFileSync(
  join(out, 'lib/features/knowledge/data/kb_catalog.dart'),
  `${HEADER('client/src/data/knowledge-base/index.ts')}
import 'kb_models.dart';
${imports.join('\n')}

/// Category taxonomy, in the website's order.
const List<KBCategory> kbCategories = ${list(cats)};

/// Every article, in the website's catalog order.
const List<KBArticle> kbArticles = ${list(names)};
`
);

// ── Financial terms (glossary + term trainer) ────────────────────────────────
// Same de-dupe as the website (\`new Map(list.map(t => [t.id, t]))\`): an id keeps the
// position of its first occurrence and the value of its last.
const byId = new Map(financialTermsData.map((t) => [t.id, t]));
const terms = Array.from(byId.values()).map((t) => {
  const ar = ARABIC_TERM_CONTENT[t.id] || {};
  const p = [
    `id: ${s(t.id)}`,
    `term: ${s(t.term)}`,
    `arabicTerm: ${s(t.arabicTerm)}`,
    `category: ${s(t.category)}`,
    `shortDefinition: ${s(t.shortDefinition)}`,
    `fullDefinition: ${s(t.fullDefinition)}`,
    `arabicDefinition: ${s(t.arabicDefinition)}`,
  ];
  if (t.formula) p.push(`formula: ${s(t.formula)}`);
  if (t.example) p.push(`example: ${s(t.example)}`);
  if (t.importance) p.push(`importance: ${s(t.importance)}`);
  if (t.relatedTerms?.length) p.push(`relatedTerms: ${list(t.relatedTerms.map(s), '    ')}`);
  if (t.tips?.length) p.push(`tips: ${list(t.tips.map(s), '    ')}`);
  if (ar.formula) p.push(`formulaAr: ${s(ar.formula)}`);
  if (ar.example) p.push(`exampleAr: ${s(ar.example)}`);
  if (ar.importance) p.push(`importanceAr: ${s(ar.importance)}`);
  if (ar.tips?.length) p.push(`tipsAr: ${list(ar.tips.map(s), '    ')}`);
  return `FinancialTerm(\n    ${p.join(',\n    ')},\n  )`;
});
const arCats = Object.entries(ARABIC_CATEGORIES).map(([k, v]) => `${s(k)}: ${s(v)}`);
writeFileSync(
  join(out, 'lib/features/knowledge/data/financial_terms_data.dart'),
  `${HEADER('client/src/data/financial-terms.ts + client/src/data/financial-terms-ar.ts')}
import 'financial_term.dart';

/// Arabic category labels for the term cards.
const Map<String, String> arabicTermCategories = {
${arCats.map((c) => `  ${c},`).join('\n')}
};

/// The website's Financial Terms Directory (${terms.length} terms, de-duplicated by id).
const List<FinancialTerm> financialTerms = ${list(terms)};
`
);

const missingAr = Array.from(byId.values()).filter((t) => !ARABIC_TERM_CONTENT[t.id]).map((t) => t.id);
const missingCat = Array.from(new Set(Array.from(byId.values()).map((t) => t.category))).filter(
  (c) => !ARABIC_CATEGORIES[c]
);
console.log(
  JSON.stringify({ articles: KB_ARTICLES.length, terms: terms.length, missingAr, missingCat })
);
