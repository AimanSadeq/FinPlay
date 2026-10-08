# Content generators

These scripts copy content from the website repo (`finance-gamification`) into the
app as Dart data, so the app stays a faithful port instead of a hand translation.
Run them from the **website repo root** (they import its TypeScript), and pass the
FinPlay repo root as the argument. The website repo is only read.

| Script | Produces | Command (from `finance-gamification/`) |
|---|---|---|
| `gen_modules.mts` | `lib/features/education/modules/data/module{1,2,3,4,6,7,9,10}_data.dart` (slides, key terms, every activity, EN + AR) | `npx tsx --tsconfig tsconfig.json ../FinPlay/tool/generators/gen_modules.mts ../FinPlay/lib/features/education/modules/data` |
| `gen_decks.ts` + `patch_decks.py` | Break-Even and Capital Budgeting slide decks inside `break_even_screen.dart` / `capital_budgeting_screen.dart` | `npx tsx ../FinPlay/tool/generators/gen_decks.ts <outDir>` then `python3 ../FinPlay/tool/generators/patch_decks.py <outDir>` |
| `gen_knowledge.ts` | Knowledge Base articles and the 176-term glossary under `lib/features/knowledge/data/` | `npx tsx ../FinPlay/tool/generators/gen_knowledge.ts ../FinPlay` |
| `gen_impact.mts` | "What this amount does" rules (`decision_impact_rules.g.dart`) and the golden test fixture | `npx tsx ../FinPlay/tool/generators/gen_impact.mts ../FinPlay` |

After regenerating, run `flutter analyze` and `flutter test`. The content tests check
Arabic coverage, activity ids and the module max scores against the server's
`MODULE_MAX_SCORES`; the impact tests compare the Dart port with the website's output.

Some scripts still contain absolute paths to the website checkout on the machine they
were written on; adjust them if your checkout lives elsewhere.
