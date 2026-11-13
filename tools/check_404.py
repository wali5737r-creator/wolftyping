#!/usr/bin/env python3
"""Regression + drift check for the WolfTyping 404 behaviour.

Cloudflare Pages serves the root index.html with HTTP 200 for ANY unknown
path when the project has no top-level 404.html (its SPA assumption). Adding
web/404.html turns unknown paths into real 404s served from that file, so
there is no allowlist to maintain: a path 404s exactly when no static file
backs it. This script enforces the invariants that keep that true:

  1. web/404.html exists (and build/web/404.html after `flutter build web`).
  2. 404.html is never listed in web/sitemap.xml, is noindex, and carries
     none of the forbidden claim terms used by the paper generator.
  3. Every URL in web/sitemap.xml has a backing file under web/ -- a
     sitemap URL without a file would newly 404 instead of soft-200.
  4. The paper pages on disk and the paper URLs in the sitemap agree
     exactly (same set) -- the equivalent of the allowlist check.
  5. Every internal root-absolute href/src in the static pages resolves
     to a file -- no live link relies on the old SPA fallback.

Usage (run from the repo root, after `flutter build web --release`):
  python3 tools/check_404.py

Exits 0 when every check passes, 1 otherwise. Pure stdlib.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
WEB_DIR = ROOT / "web"
BUILD_WEB_DIR = ROOT / "build" / "web"
SITEMAP = WEB_DIR / "sitemap.xml"
NOT_FOUND = WEB_DIR / "404.html"
SITE = "https://wolftyping.pages.dev"

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

FAILURES: list[str] = []


def fail(msg: str) -> None:
    FAILURES.append(msg)
    print(f"FAIL: {msg}")


def ok(msg: str) -> None:
    print(f"ok: {msg}")


def backing_file(path: str) -> Path | None:
    """Map a site path (e.g. /paper-246-.../ or /robots.txt) to its file."""
    rel = path.lstrip("/")
    candidate = WEB_DIR / rel
    if candidate.is_dir():
        candidate = candidate / "index.html"
    return candidate if candidate.is_file() else None


def main() -> int:
    # 1. 404 page present in source and in the built output.
    if not NOT_FOUND.is_file():
        fail("web/404.html is missing")
    else:
        ok("web/404.html exists")
    built = BUILD_WEB_DIR / "404.html"
    if BUILD_WEB_DIR.is_dir():
        if not built.is_file():
            fail("build/web/404.html is missing -- run flutter build web --release")
        elif built.read_bytes() != NOT_FOUND.read_bytes():
            fail("build/web/404.html differs from web/404.html -- rebuild")
        else:
            ok("build/web/404.html matches web/404.html")
    else:
        print("note: build/web not present, skipping built-output check")

    # 2. 404 page hygiene: not in the sitemap, noindex, no forbidden terms.
    text = NOT_FOUND.read_text(encoding="utf-8") if NOT_FOUND.is_file() else ""
    sitemap_text = SITEMAP.read_text(encoding="utf-8") if SITEMAP.is_file() else ""
    if "404" in sitemap_text:
        fail("web/sitemap.xml mentions 404 -- the 404 page must stay out of the sitemap")
    else:
        ok("404 page is not in web/sitemap.xml")
    if not re.search(
        r'<meta\s+name="robots"\s+content="noindex"',
        text,
    ):
        fail('web/404.html lacks <meta name="robots" content="noindex">')
    else:
        ok('web/404.html is noindex')
    # Same convention as generate.py --verify: forbidden terms are checked
    # in the VISIBLE text only (style/script stripped), as whole words,
    # after removing the standard "not official" disclaimer.
    import html as _html

    visible = re.sub(r"<(style|script)[^>]*>.*?</\1>", " ", text, flags=re.S)
    visible = re.sub(r"<[^>]+>", " ", visible)
    visible = _html.unescape(visible).lower()
    visible = re.sub(r"not (an? )?official papers?", " ", visible)
    visible = re.sub(r"not real ppsc", " ", visible)
    bad = [
        term
        for term in FORBIDDEN
        if re.search(r"(?<![a-z0-9])" + re.escape(term) + r"(?![a-z0-9])", visible)
    ]
    if bad:
        fail(f"web/404.html contains forbidden terms: {bad}")
    else:
        ok("web/404.html has no forbidden claim terms")
    if "Practice material only" not in text:
        fail("web/404.html lacks the practice-only wording")
    else:
        ok("web/404.html carries the practice-only wording")

    # 3 + 4. Sitemap URLs all have backing files; paper sets agree.
    if not SITEMAP.is_file():
        fail("web/sitemap.xml is missing")
        return 1
    locs = re.findall(r"<loc>(https://wolftyping\.pages\.dev[^<]*)</loc>", sitemap_text)
    print(f"info: sitemap has {len(locs)} URLs")
    missing = [u for u in locs if backing_file(u[len(SITE):]) is None]
    if missing:
        fail(f"{len(missing)} sitemap URLs have no backing file: {missing[:5]}")
    else:
        ok(f"all {len(locs)} sitemap URLs have a backing file")

    paper_locs = {
        u[len(SITE):].strip("/") for u in locs if "/paper-" in u
    }
    paper_dirs = {
        d.name for d in WEB_DIR.iterdir() if d.name.startswith("paper-") and d.is_dir()
    }
    print(f"info: {len(paper_locs)} paper URLs in sitemap, {len(paper_dirs)} paper dirs on disk")
    if paper_locs != paper_dirs:
        only_sitemap = sorted(paper_locs - paper_dirs)[:5]
        only_disk = sorted(paper_dirs - paper_locs)[:5]
        fail(
            "paper pages on disk and paper URLs in sitemap disagree: "
            f"only in sitemap={only_sitemap}, only on disk={only_disk}"
        )
    else:
        ok(f"paper pages on disk == paper URLs in sitemap ({len(paper_dirs)})")

    # 5. Every internal root-absolute link in the static pages resolves.
    link_re = re.compile(r'(?:href|src)="(/[^"#]+)"')
    broken: list[str] = []
    checked = 0
    for page in sorted(WEB_DIR.rglob("*.html")):
        for m in link_re.finditer(page.read_text(encoding="utf-8")):
            checked += 1
            if backing_file(m.group(1)) is None:
                broken.append(f"{m.group(1)} (in {page.relative_to(ROOT)})")
    if broken:
        fail(f"{len(broken)} internal links have no backing file: {broken[:5]}")
    else:
        ok(f"all {checked} internal root-absolute links resolve to a file")

    if FAILURES:
        print(f"\n{len(FAILURES)} check(s) failed")
        return 1
    print("\nall 404 checks passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
