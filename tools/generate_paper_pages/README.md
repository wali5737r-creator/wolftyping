# Per-paper static pages generator

One static HTML page per WolfTyping practice paper, generated from the
paper Dart files — never hand-written.

## What it does

`generate.py` reads every `lib/features/ppsc/service/papers*/paper_*.dart`
file, computes each paper's metadata (post, department, exam date,
question count, per-subject counts, latest-update notes) and renders one
page per paper from `template.html` (same design as the Phase 2 year
pages: teal branding, GA4 tag `G-6NFRK6K224`, WebPage + FAQPage JSON-LD
matching the visible FAQ word-for-word).

URL scheme: `web/paper-<paperNo>-<slug>/index.html`, where `<slug>` is
the paper's post + department lowercased with non-alphanumerics as
hyphens (parenthetical groups and the filler words "different" /
"department(s)" dropped), plus the year — e.g.
`web/paper-246-junior-clerk-bor-2026/index.html`. Slugs are tried in
this order until one is unused: (1) parens dropped + year, (2) parens
kept + year, (3) parens dropped + year + exam date, (4) parens kept +
year + exam date, (5) candidate (4) + "-paper-<paperNo>" (last resort;
needed when several papers share post, department AND exam date, e.g.
papers 154–157). The paper number in the path makes every URL unique
regardless.

## How to re-run

From the repo root:

```sh
# Regenerate everything (all years)
python3 tools/generate_paper_pages/generate.py

# Regenerate one year only (e.g. after adding papers to that year)
python3 tools/generate_paper_pages/generate.py --year 2026

# Verify generated pages against the Dart data
python3 tools/generate_paper_pages/generate.py --verify [--year YYYY]

# Rebuild the sitemap (run after all years are generated)
python3 tools/generate_paper_pages/generate.py --update-sitemap
```

Each run writes `manifest-<year>.json` files here with the per-paper
metadata, slugs and URLs used.

## After adding papers

1. Add the paper Dart files + registry entries as usual (lib/ only).
2. Update `TOTAL_PAPERS`, `TOTAL_QUESTIONS` and `YEAR_TOTALS` at the
   top of `generate.py` — and add a `GAP_NOTES` entry if the new paper
   has an honest gap to disclose (short count, omitted question, repeat).
3. Re-run the generator for the affected year(s), then `--verify`,
   then `--update-sitemap`.
4. Update the matching counts in `web/index.html`, the year's static
   page (`web/<year>-practice-papers/index.html` — add the new rows to
   its table), and the global totals (241 papers / 20,163 questions)
   wherever they appear in the other static pages.
5. Run `flutter test`, `flutter analyze`, `flutter build web --release`
   (as its own checked step, never piped through `| tail`), commit
   source + `git add -f build/web`, and deploy through the normal flow.

## Rules the generator enforces

- Practice material only, never official/real papers; no "Typing
  Master", no "best/#1/official" claims, no fake ratings, no source,
  compilation, author or book names anywhere.
- Question counts and subject breakdowns come from the Dart files, never
  typed by hand. The `--verify` step fails the run if a page disagrees
  with the Dart data, if FAQ JSON-LD does not match the visible FAQ,
  or if a forbidden term appears in the visible text.
