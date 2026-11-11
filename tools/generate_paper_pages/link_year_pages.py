#!/usr/bin/env python3
"""Link each year page's paper-number cell to that paper's static page.

Reads tools/generate_paper_pages/manifest-<year>.json (paperNo -> URL) and
wraps the first <td> (the paper number) of every data row in
web/<year>-practice-papers/index.html in a link to the paper page, e.g.
<td>246</td> -> <td><a href="/paper-246-junior-clerk-bor-2026/">246</a></td>.

Without this, the 241 paper pages are reachable only via the sitemap; the
year pages are their only inbound links from the site itself. Re-run after
any regeneration of the year pages. Idempotent: already-linked cells are
left alone.
"""

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent.parent  # repo root
YEARS = [2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026]

ROW_RE = re.compile(r"(<tr[^>]*>\s*<td>\s*)(\d+)(\s*</td>)")
LINKED_RE = re.compile(r"<td>\s*<a\s+href=")


def main() -> int:
    total_linked = 0
    for year in YEARS:
        manifest_path = ROOT / "tools" / "generate_paper_pages" / f"manifest-{year}.json"
        page_path = ROOT / "web" / f"{year}-practice-papers" / "index.html"
        manifest = json.loads(manifest_path.read_text())
        by_no = {}
        for entry in manifest["entries"]:
            # URL is absolute; keep the link relative for the same site.
            rel = entry["url"].replace("https://wolftyping.pages.dev", "")
            by_no[entry["paperNo"]] = rel

        html = page_path.read_text()
        linked_here = 0

        def repl(match: "re.Match[str]") -> str:
            nonlocal linked_here
            num = int(match.group(2))
            if num not in by_no:
                return match.group(0)
            linked_here += 1
            return f'{match.group(1)}<a href="{by_no[num]}">{num}</a>{match.group(3)}'

        new_html = ROW_RE.sub(repl, html)
        if new_html != html:
            page_path.write_text(new_html)
        print(f"{year}: linked {linked_here} paper rows (manifest: {len(by_no)})")
        if linked_here != len(by_no):
            print(f"  WARNING: {year} linked {linked_here} but manifest has {len(by_no)}")
        total_linked += linked_here

    print(f"TOTAL linked: {total_linked} (expect 241)")
    return 0 if total_linked == 241 else 1


if __name__ == "__main__":
    sys.exit(main())
