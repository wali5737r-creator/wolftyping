#!/usr/bin/env python3
"""Generate one static SEO page per WolfTyping practice paper.

Reads the paper Dart files under lib/features/ppsc/service/papers*/,
computes each paper's metadata + per-subject question counts, and renders
one HTML page per paper from tools/generate_paper_pages/template.html
(same design as the Phase 2 year pages: teal branding, GA4 tag, WebPage +
FAQPage JSON-LD matching the visible FAQ word-for-word).

Usage (run from the repo root):
  python3 tools/generate_paper_pages/generate.py [--year YYYY]
  python3 tools/generate_paper_pages/generate.py --verify [--year YYYY]
  python3 tools/generate_paper_pages/generate.py --update-sitemap

  --year YYYY   only (re)generate that year's papers (default: all years)
  --verify      re-read generated pages and check them against the Dart
                data (counts, links, canonical, FAQ/JSON-LD match,
                forbidden terms); exits non-zero on any failure
  --update-sitemap  rebuild web/sitemap.xml: keep the 13 existing URLs
                (lastmod bumped to LASTMOD) and add every paper URL from
                the manifest files; run after all years are generated

Re-run after adding papers to regenerate their pages. The script only
writes web/paper-<no>-<slug>/index.html and manifest-<year>.json files;
it never touches lib/, the registries, or any other web/ page.

URL scheme: web/paper-<paperNo>-<slug>/index.html, where <slug> is the
paper's post + department lowercased with non-alphanumerics as hyphens
(parenthetical groups and the filler words "different"/"department(s)"
dropped), plus the year — e.g.
web/paper-246-junior-clerk-bor-2026/index.html. Slugs are tried in this
order until one is unused: (1) parens dropped + year, (2) parens kept +
year, (3) parens dropped + year + exam date, (4) parens kept + year +
exam date, (5) candidate (4) + "-paper-<paperNo>" (last resort; needed
when several papers share post, department AND exam date, e.g. papers
154–157). The paper number in the path makes every URL unique regardless.

Totals below are the live totals for this data set. Update them when new
papers are added, then re-run the generator and the sitemap step, and
update the matching counts in web/index.html and the year pages.
"""

from __future__ import annotations

import argparse
import html
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TOOLS_DIR = Path(__file__).resolve().parent
WEB_DIR = ROOT / "web"
PAPERS_ROOT = ROOT / "lib" / "features" / "ppsc" / "service"

SITE = "https://wolftyping.pages.dev"
LASTMOD = "2026-11-11"

# Live totals for the current paper data set (update when papers are added).
TOTAL_PAPERS = 241
TOTAL_QUESTIONS = 20163
YEAR_TOTALS = {
    2019: (31, 2987),
    2020: (29, 2866),
    2021: (23, 2051),
    2022: (28, 2712),
    2023: (25, 2381),
    2024: (24, 2175),
    2025: (56, 3179),
    2026: (25, 1812),
}

SUBJECT_LABELS = {
    "english": "English",
    "generalKnowledge": "General Knowledge",
    "pakistanStudies": "Pakistan Studies",
    "islamiat": "Islamiat",
    "mathematics": "Mathematics",
    "everydayScience": "Everyday Science",
}
SUBJECT_ORDER = [
    "generalKnowledge",
    "pakistanStudies",
    "english",
    "islamiat",
    "mathematics",
    "everydayScience",
]

# Honest gap notes, keyed by paper number. Shown in an "About this paper"
# note box and as an extra FAQ on that paper's page only.
GAP_NOTES = {
    64: "The printed header of this paper says 2011; it is grouped under 2021 as listed in the contents.",
    201: "This paper repeats paper 197 as printed — the same questions appear in both. It is kept here as a separate paper, exactly as listed.",
    209: "This paper has 89 questions, not 100 — the other 11 questions were not in the source material.",
    210: "Question 1 of this paper was omitted — it was not legible in the source material.",
    217: "This paper has 92 questions, not 100 — the other 8 questions were not in the source material.",
    246: "This paper has 95 questions, not 100 — questions 96–100 were not in the source material.",
}

FILLER_WORDS = {"different", "department", "departments"}
FORBIDDEN = [
    "typing master",
    "typing-master",
    "best",
    "#1",
    "official",
    "imtiaz",
    "shahid",
    "mam aisha",
    "achievers circle",
    "advanced ppsc",
]

DART_STR = re.compile(r"'((?:[^'\\]|\\.)*)'")
FIELD = re.compile(
    r"^\s*(paperNo|year|post|department|examDate|id):\s*(?:'((?:[^'\\]|\\.)*)'|(\d+)),",
    re.M,
)


def unescape_dart(s: str) -> str:
    """Unescape a Dart single-quoted string literal body."""

    def repl(m: re.Match) -> str:
        esc = m.group(1)
        if esc == "n":
            return "\n"
        if esc == "t":
            return "\t"
        if esc == "r":
            return "\r"
        if esc.startswith("u") and len(esc) == 5:
            return chr(int(esc[1:], 16))
        if esc.startswith("x") and len(esc) == 3:
            return chr(int(esc[1:], 16))
        return esc  # \' \" \\ \$ etc. -> the char itself

    return re.sub(r"\\(u[0-9a-fA-F]{4}|x[0-9a-fA-F]{2}|.)", repl, s)


def slugify(text: str, drop_parens: bool) -> str:
    """Lowercase, drop filler words, non-alphanumerics become hyphens."""
    if drop_parens:
        text = re.sub(r"\([^)]*\)", " ", text)
    text = text.lower()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    parts = [p for p in text.split("-") if p and p not in FILLER_WORDS]
    return "-".join(parts)


def parse_paper(path: Path) -> dict:
    """Parse one paper_*.dart file into metadata + subject counts."""
    text = path.read_text(encoding="utf-8")
    # Constructor fields only: everything before the questions list, so
    # per-question `id:` fields cannot overwrite the paper's own fields.
    head = text.split("questions: [", 1)[0]
    fields = {}
    for m in FIELD.finditer(head):
        fields[m.group(1)] = (
            unescape_dart(m.group(2)) if m.group(2) is not None else m.group(3)
        )
    paper_no = int(fields["paperNo"])
    year = int(fields["year"])
    subjects = {}
    for subj in re.findall(r"subject:\s*MockSubject\.(\w+)", text):
        subjects[subj] = subjects.get(subj, 0) + 1
    total = len(re.findall(r"MockQuestion\(", text))
    if sum(subjects.values()) != total:
        print(
            f"WARNING {path.name}: subject counts sum to "
            f"{sum(subjects.values())} but MockQuestion count is {total}",
            file=sys.stderr,
        )
    latest = 0
    m = re.search(r"latestUpdates:\s*\[(.*?)\],", text, re.S)
    if m:
        latest = len(DART_STR.findall(m.group(1)))
    return {
        "paperNo": paper_no,
        "year": year,
        "post": fields["post"],
        "department": fields["department"],
        "examDate": fields["examDate"],
        "id": fields.get("id", f"{year}-{paper_no}"),
        "questionCount": total,
        "subjects": {k: subjects[k] for k in SUBJECT_ORDER if k in subjects},
        "latestUpdates": latest,
        "source": str(path.relative_to(ROOT)),
    }


def build_slugs(papers: list[dict]) -> None:
    """Assign a unique slug to each paper (see module docstring)."""
    used: dict[str, int] = {}
    for p in papers:
        post_a = slugify(p["post"], True)
        dept_a = slugify(p["department"], True)
        post_b = slugify(p["post"], False)
        dept_b = slugify(p["department"], False)
        # Empty parts (e.g. a department that is only filler words) are
        # dropped so the slug never gets a double hyphen.
        base_a = "-".join(x for x in (post_a, dept_a, str(p["year"])) if x)
        base_b = "-".join(x for x in (post_b, dept_b, str(p["year"])) if x)
        date = p["examDate"].replace(".", "-")
        cands = [
            base_a,
            base_b,
            f"{base_a}-{date}",
            f"{base_b}-{date}",
            f"{base_b}-{date}-paper-{p['paperNo']}",
        ]
        slug = None
        for cand in cands:
            if cand not in used:
                slug = cand
                break
        if slug is None:
            raise SystemExit(
                f"slug collision for paper {p['paperNo']} even with exam date: {cands}"
            )
        used[slug] = p["paperNo"]
        p["slug"] = slug
        p["urlPath"] = f"/paper-{p['paperNo']}-{slug}/"
        p["url"] = SITE + p["urlPath"]


def esc(s: str) -> str:
    return html.escape(s, quote=True)


def meta_description(p: dict) -> str:
    full = (
        f"Paper {p['paperNo']} — {p['post']}, {p['department']} "
        f"({p['examDate']}): {p['questionCount']} timed practice questions "
        f"with explanations. Practice material only, not real papers."
    )
    if len(full) <= 160:
        return full
    suffix = (
        f" — {p['questionCount']} timed practice questions with "
        f"explanations. Practice material only, not real papers."
    )
    prefix = f"Paper {p['paperNo']}: "
    short = prefix + p["post"] + suffix
    if len(short) <= 160:
        return short
    # Very long post title: truncate it at a word boundary so the
    # description stays within 160 characters.
    budget = 160 - len(prefix) - len(suffix)
    post = p["post"][:budget].rsplit(" ", 1)[0] + "…"
    return prefix + post + suffix


def notes_phrase(n: int) -> str:
    """'1 latest-update note' or 'N latest-update notes'."""
    return f"{n} latest-update note" if n == 1 else f"{n} latest-update notes"


def faqs(p: dict) -> list[tuple[str, str]]:
    no = p["paperNo"]
    q = p["questionCount"]
    items = [
        (
            f"Is paper {no} a real PPSC paper?",
            f"No. Paper {no} on WolfTyping is practice material written in "
            f"fresh wording for practice only. It is not a real PPSC past "
            f"paper, not from any exam, and not an official paper.",
        ),
        (
            f"How many questions are in paper {no}?",
            f"Paper {no} has {q} practice questions in total. Every "
            f"question has an explanation in the end review"
            + (
                f", and {notes_phrase(p['latestUpdates'])} "
                f"{'covers' if p['latestUpdates'] == 1 else 'cover'} "
                f"current-affairs questions."
                if p["latestUpdates"]
                else "."
            ),
        ),
        (
            "How long is the paper test?",
            "Each paper runs as a timed test. You choose 60, 90 or 120 "
            "minutes before starting; 90 minutes is the default. The test "
            "submits automatically when the time ends, and the result shows "
            "your score with a correct, incorrect and skipped review.",
        ),
    ]
    if no in GAP_NOTES:
        items.append(
            (
                f"Is there anything unusual about paper {no}?",
                GAP_NOTES[no],
            )
        )
    items.append(
        (
            "Can I practise papers from other years?",
            f"Yes. WolfTyping has {TOTAL_PAPERS} timed practice papers from "
            f"2019 to 2026 with {TOTAL_QUESTIONS:,} practice questions in "
            f"total. You can browse the other years from the links below.",
        )
    )
    return items


def json_ld(obj: dict) -> str:
    """Render a JSON-LD script block the way the Phase 2 pages do."""
    body = json.dumps(obj, ensure_ascii=True, indent=2)
    indented = "\n".join("  " + line for line in body.split("\n"))
    return '  <script type="application/ld+json">\n' + indented + "\n  </script>"


def render(p: dict, template: str) -> str:
    no = p["paperNo"]
    year = p["year"]
    title = f"Paper {no} — {p['post']} | WolfTyping"
    desc = meta_description(p)
    app_url = f"{SITE}/#/ppsc-past-papers-year?year={year}"
    h1 = f"Paper {no} — {p['post']}, {p['department']}"
    lead = (
        f"Practise paper {no} as a timed test: {p['questionCount']} practice "
        f"questions — {p['post']} in {p['department']}, exam date "
        f"{p['examDate']}. Each question has an explanation in the end review."
    )

    rows = [
        ("Paper", str(no)),
        ("Post", p["post"]),
        ("Department", p["department"]),
        ("Exam date", p["examDate"]),
        ("Year", str(year)),
        ("Questions", str(p["questionCount"])),
        ("Latest-update notes", str(p["latestUpdates"])),
    ]
    meta_rows = "".join(
        f"          <tr><th>{esc(k)}</th><td>{esc(v)}</td></tr>\n" for k, v in rows
    )
    subj_rows = "".join(
        f"          <tr><td>{esc(SUBJECT_LABELS[s])}</td><td>{c}</td></tr>\n"
        for s, c in p["subjects"].items()
    )
    subj_rows += (
        f"          <tr><td><strong>Total</strong></td>"
        f"<td><strong>{p['questionCount']}</strong></td></tr>\n"
    )
    about = (
        f"      <h2>About this paper</h2>\n"
        f"      <p>Paper {no} is a timed practice test for {esc(p['post'])} "
        f"in {esc(p['department'])}, exam date {esc(p['examDate'])}. It has "
        f"{p['questionCount']} practice questions with an explanation for "
        f"every question in the end review"
        + (
            f" and {notes_phrase(p['latestUpdates'])} for "
            f"current-affairs questions."
            if p["latestUpdates"]
            else "."
        )
        + "</p>\n"
        f"      <p>Each paper runs as a timed test — choose 60, 90 or 120 "
        f"minutes (90 is the default) — with a warning in the last five "
        f"minutes, automatic submission when time ends, and a final score "
        f"with correct, incorrect and skipped review.</p>\n"
        f"      <div class=\"table-wrap\">\n"
        f"        <table>\n"
        f"          <tbody>\n{meta_rows}          </tbody>\n"
        f"        </table>\n"
        f"      </div>\n"
        f"      <h2>Questions by subject</h2>\n"
        f"      <p>The {p['questionCount']} questions break down by subject "
        f"as follows. "
        + (
            "Current-affairs questions carry a latest-update note saying "
            "who holds the office or post now."
            if p["latestUpdates"]
            else "Each question has an explanation in the end review."
        )
        + "</p>\n"
        f"      <div class=\"table-wrap\">\n"
        f"        <table>\n"
        f"          <thead><tr><th>Subject</th><th>Questions</th></tr></thead>\n"
        f"          <tbody>\n{subj_rows}          </tbody>\n"
        f"        </table>\n"
        f"      </div>\n"
    )
    if no in GAP_NOTES:
        about += (
            f"      <div class=\"warn\">\n"
            f"        <p><strong>Note about this paper.</strong> "
            f"{esc(GAP_NOTES[no])}</p>\n"
            f"      </div>\n"
        )

    faq_items = faqs(p)
    faq_html = (
        "      <div class=\"faq\">\n"
        "        <h2>Frequently asked questions</h2>\n"
        + "".join(
            f"        <h3>{esc(q)}</h3>\n        <p>{esc(a)}</p>\n"
            for q, a in faq_items
        )
        + "      </div>"
    )
    webpage = {
        "@context": "https://schema.org",
        "@type": "WebPage",
        "name": title,
        "url": p["url"],
        "description": desc,
        "inLanguage": "en",
        "isPartOf": {
            "@type": "WebSite",
            "name": "WolfTyping",
            "url": SITE + "/",
        },
    }
    faqpage = {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [
            {
                "@type": "Question",
                "name": q,
                "acceptedAnswer": {"@type": "Answer", "text": a},
            }
            for q, a in faq_items
        ],
    }

    out = template
    out = out.replace("@@PAGE_TITLE@@", esc(title))
    out = out.replace("@@META_DESCRIPTION@@", esc(desc))
    out = out.replace("@@CANONICAL@@", esc(p["url"]))
    out = out.replace("@@WEBPAGE_JSON@@", json_ld(webpage))
    out = out.replace("@@FAQ_JSON@@", json_ld(faqpage))
    out = out.replace("@@HERO_H1@@", esc(h1))
    out = out.replace("@@LEAD@@", esc(lead))
    out = out.replace("@@APP_URL@@", esc(app_url))
    out = out.replace("@@CTA_TEXT@@", esc(f"Open paper {no} in the app →"))
    out = out.replace("      @@BODY@@\n", about.rstrip("\n") + "\n")
    out = out.replace("      @@FAQ_HTML@@\n", faq_html + "\n")
    if "@@" in out:
        raise SystemExit(f"template tokens left unfilled in paper {no}")
    return out


def load_papers(years: list[int]) -> list[dict]:
    papers = []
    for year in years:
        d = PAPERS_ROOT / f"papers{year}"
        for path in sorted(d.glob("paper_*.dart")):
            papers.append(parse_paper(path))
    papers.sort(key=lambda p: p["paperNo"])
    build_slugs(papers)
    return papers


def generate(years: list[int]) -> dict:
    template = (TOOLS_DIR / "template.html").read_text(encoding="utf-8")
    papers = load_papers(years)
    by_year: dict[int, list[dict]] = {}
    for p in papers:
        by_year.setdefault(p["year"], []).append(p)
        out_dir = WEB_DIR / f"paper-{p['paperNo']}-{p['slug']}"
        out_dir.mkdir(parents=True, exist_ok=True)
        (out_dir / "index.html").write_text(render(p, template), encoding="utf-8")
    for year, ps in sorted(by_year.items()):
        manifest = {
            "year": year,
            "papers": len(ps),
            "questions": sum(p["questionCount"] for p in ps),
            "entries": [
                {
                    "paperNo": p["paperNo"],
                    "post": p["post"],
                    "department": p["department"],
                    "examDate": p["examDate"],
                    "questionCount": p["questionCount"],
                    "subjects": p["subjects"],
                    "latestUpdates": p["latestUpdates"],
                    "slug": p["slug"],
                    "url": p["url"],
                }
                for p in ps
            ],
        }
        (TOOLS_DIR / f"manifest-{year}.json").write_text(
            json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8"
        )
    total_q = sum(p["questionCount"] for p in papers)
    print(
        f"generated {len(papers)} pages, {total_q} questions "
        f"for years {sorted(by_year)}"
    )
    for year, ps in sorted(by_year.items()):
        exp_n, exp_q = YEAR_TOTALS[year]
        got_n, got_q = len(ps), sum(p["questionCount"] for p in ps)
        flag = "" if (got_n, got_q) == (exp_n, exp_q) else "  <-- MISMATCH vs YEAR_TOTALS"
        print(f"  {year}: {got_n} papers, {got_q} questions (expected {exp_n}, {exp_q}){flag}")
    return {"papers": papers, "by_year": by_year}


def verify(years: list[int]) -> bool:
    papers = load_papers(years)
    ok = True
    for p in papers:
        path = WEB_DIR / f"paper-{p['paperNo']}-{p['slug']}" / "index.html"
        if not path.exists():
            print(f"FAIL paper {p['paperNo']}: page missing")
            ok = False
            continue
        t = path.read_text(encoding="utf-8")
        problems = []
        if esc(f"Paper {p['paperNo']} — {p['post']}") not in t:
            problems.append("title/H1 missing post")
        if p["url"] not in t:
            problems.append("canonical/url missing")
        if f"/#/ppsc-past-papers-year?year={p['year']}" not in t:
            problems.append("app link wrong")
        if str(p["questionCount"]) not in t:
            problems.append("question count missing")
        for s, c in p["subjects"].items():
            if SUBJECT_LABELS[s] not in t:
                problems.append(f"subject {s} missing")
        low = t.lower()
        # Forbidden terms are checked in the VISIBLE text only (style and
        # scripts stripped), as whole words, after removing the standard
        # disclaimers ("not an official paper", "not real PPSC ...") —
        # those disclaimers are required content, not claims.
        visible = re.sub(r"<(style|script)[^>]*>.*?</\1>", " ", t, flags=re.S)
        visible = re.sub(r"<[^>]+>", " ", visible)
        visible = html.unescape(visible).lower()
        visible = re.sub(r"not (an? )?official papers?", " ", visible)
        visible = re.sub(r"not real ppsc", " ", visible)
        for term in FORBIDDEN:
            if re.search(r"(?<![a-z0-9])" + re.escape(term) + r"(?![a-z0-9])", visible):
                problems.append(f"forbidden term: {term}")
        # FAQ JSON questions must match the visible FAQ headings exactly.
        visible = re.findall(r"<h3>(.*?)</h3>", t, re.S)
        m = re.search(
            r'"@type": "FAQPage".*?"mainEntity": \[(.*?)\]\n  \}',
            t,
            re.S,
        )
        if not m:
            problems.append("FAQPage JSON-LD missing")
        else:
            names = re.findall(r'"name": "(.*?)"', m.group(1))
            if [html.unescape(v) for v in visible] != [html.unescape(n) for n in names]:
                problems.append("FAQ headings != FAQPage JSON-LD names")
        if "G-6NFRK6K224" not in t:
            problems.append("GA4 tag missing")
        m = re.search(r'<meta name="description" content="(.*?)">', t)
        if not m:
            problems.append("meta description missing")
        elif len(html.unescape(m.group(1))) > 160:
            problems.append(
                f"meta description {len(html.unescape(m.group(1)))} chars > 160"
            )
        if problems:
            print(f"FAIL paper {p['paperNo']}: {'; '.join(problems)}")
            ok = False
    print("verify: " + ("ALL OK" if ok else "FAILURES — see above"))
    return ok


def update_sitemap() -> None:
    manifests = []
    for mf in sorted(TOOLS_DIR.glob("manifest-*.json")):
        manifests.append(json.loads(mf.read_text(encoding="utf-8")))
    if not manifests:
        raise SystemExit("no manifest files found — generate pages first")
    entries = []
    for mf in manifests:
        for e in mf["entries"]:
            entries.append(e["url"])
    entries.sort(key=lambda u: int(re.search(r"paper-(\d+)-", u).group(1)))
    sitemap_path = WEB_DIR / "sitemap.xml"
    text = sitemap_path.read_text(encoding="utf-8")
    existing = re.findall(r"<loc>(.*?)</loc>\s*<lastmod>(.*?)</lastmod>", text, re.S)
    if len(existing) != 13:
        raise SystemExit(f"expected 13 existing sitemap URLs, found {len(existing)}")
    urls = [(loc, LASTMOD) for loc, _ in existing]
    urls += [(u, LASTMOD) for u in entries]
    body = "".join(
        f"  <url>\n    <loc>{loc}</loc>\n    <lastmod>{lm}</lastmod>\n  </url>\n"
        for loc, lm in urls
    )
    sitemap_path.write_text(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
        + body
        + "</urlset>\n",
        encoding="utf-8",
    )
    print(f"sitemap: {len(urls)} URLs (13 existing + {len(entries)} paper pages)")


def main() -> None:
    ap = argparse.ArgumentParser(description="Generate per-paper static pages")
    ap.add_argument("--year", type=int, help="only this year (default: all)")
    ap.add_argument("--verify", action="store_true", help="verify generated pages")
    ap.add_argument("--update-sitemap", action="store_true", help="rebuild sitemap.xml")
    args = ap.parse_args()
    years = [args.year] if args.year else sorted(YEAR_TOTALS)
    if args.update_sitemap:
        update_sitemap()
        return
    if args.verify:
        sys.exit(0 if verify(years) else 1)
    generate(years)


if __name__ == "__main__":
    main()
