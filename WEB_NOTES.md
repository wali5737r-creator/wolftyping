# Typing Master — Web Build Notes

This document records how the Windows desktop app (Flutter + GetX + Drift)
was converted to a web build, what was changed and why, what persists on
web vs desktop, and how to add PPSC mock-test questions.

The desktop app is unchanged in behaviour: the `windows/` folder and all
desktop code paths are intact. Web-only behaviour is isolated behind
conditional imports (see §2).

## 1. How to rebuild

Requirements: Flutter SDK 3.x (stable). This build used Flutter 3.47.9
(Dart 3.13.7), installed persistently at `~/workspace/.flutter` on the
build machine. If Flutter is not on your PATH, add it for the session:

```sh
export PATH="$HOME/workspace/.flutter/bin:$PATH"
cd typing-master
```

Then:

```sh
# Install dependencies (offline if the package cache is already populated):
dart pub get --offline        # or: flutter pub get
flutter test                  # run the unit/widget tests
flutter analyze               # static analysis
flutter build web --release   # output in build/web/
```

Serve the result with any static file server, e.g.:

```sh
cd build/web
python3 -m http.server 8000
# open http://localhost:8000/
```

Notes from the build environment (VM, 2026-10-30): Dart/pub HTTP requests
hung (the Dart HTTP client did not pick up the egress proxy), while `curl`
worked. Packages were downloaded via `curl` from pub.dev, SHA-256-verified
against `pubspec.lock`, and placed in `~/.pub-cache/hosted/pub.dev/`, after
which `dart pub get --offline` succeeded. `flutter create --platforms=web .`
also failed ("Failed to update packages") for the same reason, so `web/`
was generated manually from the Flutter SDK template
(`packages/flutter_tools/templates/app/web/`). If `flutter` hangs on a
fresh machine, retry with a normal network connection first — the
workarounds above were environment-specific, not app changes.

## 2. What was changed for web, and why

| File | Change | Why |
|---|---|---|
| `lib/core/database/database_connection.dart` (new) | Conditional export: `database_connection_io.dart` on desktop, `database_connection_web.dart` on web (`dart.library.js_interop`). | `dart:io` `File` does not exist on web; the database connection must differ per platform without touching repositories. |
| `lib/core/database/database_connection_io.dart` (new) | The original file-based connection from `app_database.dart` (`LazyDatabase` + `NativeDatabase.createInBackground(File(...))`, via `path_provider`). | Desktop behaviour unchanged. |
| `lib/core/database/database_connection_web.dart` (new) | Drift WASM: `WasmDatabase.open(databaseName: 'typing_master', sqlite3Uri: Uri.parse('sqlite3.wasm'), driftWorkerUri: Uri.parse('drift_worker.js'))` inside `LazyDatabase`. | The only Drift-supported way to run SQLite in the browser. |
| `lib/core/database/app_database.dart` | Removed `dart:io`/`path`/`path_provider` imports; uses `openDatabaseConnection()`. All tables, DAOs and repositories unchanged. | The app's database API is identical on both platforms; only the connection differs. |
| `web/` (new, generated) | `index.html`, `manifest.json`, `favicon.png`, icons. Then enhanced for landing/SEO (see §6): title, meta description, Open Graph/Twitter tags, `<noscript>` description. The Flutter bootstrap (`flutter_bootstrap.js`) is untouched. | Flutter web needs these entry files; they did not exist in the desktop project. |
| `web/sqlite3.wasm`, `web/drift_worker.js` (new) | Copied from the Drift 2.35.0 release (byte-identical to the files shipped in the `drift` package). | Required by `WasmDatabase` at runtime; Flutter does not bundle them automatically. |
| `pubspec.yaml` | `web: ^1.1.1` added (for the result-card PNG download). `drift` resolved to 2.35.0 via the lockfile (declared `^2.16.0`). | `package:web` is the web-safe replacement for `dart:html`. |
| `lib/core/services/result_share.dart` + `result_share_web.dart` + `result_share_io.dart` (new) | Conditional export. Web: capture a `RepaintBoundary` as PNG and download it via a Blob + anchor click (browser APIs only). Desktop: PNG download returns `false`; copy-text still works. | Result-card sharing without desktop file APIs. |
| `lib/features/typing_test/view/widgets/result_card.dart` (new) | `ShareableResultCard` (WPM, accuracy, duration, date) + `ResultShareButtons` (Copy Result / Download Result Card) + `formatResultShareText`. | Phase 1 item 3 (result card share). |
| `lib/features/typing_test/view/widgets/typing_result_view.dart`, `urdu_style_result_view.dart` | Result card + share buttons added under the existing result summary (English test and Urdu/PPSC test results). Nothing else changed. | Phase 1 item 3 wiring. |
| `lib/features/ppsc/model/mock_question.dart` (new) | `MockQuestion` (id, subject, question, exactly 4 options, correctIndex 0–3, optional topic) and `MockSubject` enum (English, General Knowledge, Pakistan Studies, Islamiat, Mathematics, Everyday Science). | MCQ mock-test data model. |
| `lib/features/ppsc/service/mock_questions.dart` (new) | 18 original practice sample questions (3 per subject), grouped by subject, with comments explaining how to add 100 questions. Labelled practice samples only. | MCQ question bank (see §4). |
| `lib/features/ppsc/service/mock_test_engine.dart` (new) | Pure scoring/session logic: answers, correct/wrong/skipped counts, unanswered list, negative marking (score = correct − wrong × deduction, floored at 0; skipped never deducts), percentage, `MockTestResult`. | MCQ engine; unit-tested, including a generated 100-question session. |
| `lib/features/ppsc/controller/mock_test_controller.dart` (new) | GetX controller: setup (full/subject, subject, durations, negative-marking toggle), 1-second countdown with auto-submit at zero, navigation, answers, submit confirmation, result, 5-minute warning flag. | MCQ session state. |
| `lib/features/ppsc/view/mock_test_view.dart` (new) | Setup/test/result UI reusing the app's theme/components: one question at a time, A–D options, Previous/Next/Clear/Submit, question-number palette (answered = filled, current = outlined), 5-minute warning banner, submit-confirm dialog listing unanswered questions, result stats + per-question review. | MCQ UI. |
| `lib/core/routes/app_routes.dart`, `app_pages.dart` | New route `AppRoutes.ppscMockTest` (`/ppsc-mock-test`) with its GetPage + binding. | MCQ mode entry point. |
| `lib/core/widgets/sidebar_item.dart` | Sidebar item "PPSC Mock Test" added after "PPSC Urdu". | Navigation to the MCQ mode. |
| `lib/features/ppsc/view/ppsc_view.dart` | Link ("Practice MCQ Mock Test…") added under the PPSC typing-test setup panel. The typing test itself is untouched. | Discoverability of the MCQ mode from the PPSC section. |
| `test/mock_test_engine_test.dart` (new) | Engine tests: scoring, negative marking on/off, floor at 0, unanswered list, clear answer, and a generated 100-question session. | Verifies the MCQ engine, including 100-question support. |
| `lib/features/practice/view/practice_view.dart` | "Weak-Keys Drill" card added above the existing mode buttons: lists the user's weakest keys (from existing mistake records) as tappable chips, plus a "Start Weak-Keys Drill" button reusing `startCharacterPractice`. | Phase 1 item 1. |
| `lib/features/paragraphs/controller/paragraph_form_controller.dart` | New `saveAndGetParagraph()` (save + return the saved paragraph); `save()` now delegates to it. Trims title/text before saving. | Phase 1 item 2 plumbing. |
| `lib/features/paragraphs/view/paragraph_form_view.dart` | "Save & Start Test" button beside Save: saves the pasted paragraph, then opens the matching typing test (English → English test, Urdu → Urdu test) with the same timing/result flow as any other test. The existing "Use for Test" flow in My Paragraphs is unchanged. | Phase 1 item 2. |
| `lib/features/profile/service/profile_repository.dart` | New `bestScores({limit = 10})`: the user's own top tests by net WPM from the existing `TypingTests` table. | Phase 1 item 8 (on-device board). |
| `lib/features/profile/controller/profile_controller.dart` | Loads `bestScores` alongside the existing stats. | Phase 1 item 8 wiring. |
| `lib/features/profile/view/profile_view.dart` | "Best Scores on This Device" section (ranked list, labelled as on-device only, with the shared-leaderboard limitation explained). | Phase 1 item 8 UI. |

No features were removed. No `dart:io` usage remains outside the database
connection layer (verified by grep). The Jameel Noori Nastaleeq font and
all Urdu content are unchanged.

## 3. What persists on web vs desktop

| Data | Desktop (Windows) | Web (browser) |
|---|---|---|
| Typing history, lessons progress, paragraphs, mistakes, profile, PPSC test records | SQLite file on disk (persists across restarts) | Drift WASM database. Drift probes the browser and uses OPFS first, then IndexedDB, and falls back to **in-memory** if neither is available. In OPFS/IndexedDB-capable browsers (current Chrome/Edge/Firefox) history persists across reloads; in the in-memory fallback, history is lost on refresh. **This fallback is a browser limitation, not a silent choice — if your browser shows history disappearing after reload, it is running in-memory.** |
| Settings / theme / preferences | `shared_preferences` (file) | `shared_preferences` web implementation (browser local storage) — persists. |
| Result-card PNG | Not offered (copy-text only) | Downloaded via the browser; nothing is uploaded anywhere. |

There is no server, no account, and no sync: data never leaves the device
except when the user explicitly downloads a result card or copies text.

## 4. PPSC MCQ mock test — adding your own 100 questions

The mock test is a **practice** tool. The built-in questions are 18
clearly-labelled practice samples (3 per subject). They are NOT real PPSC
past papers, and the app never claims they are. Add your own questions by
editing ONE file:

**File:** `lib/features/ppsc/service/mock_questions.dart`

**Format:** one `MockQuestion(...)` entry per question, in the
`sampleMockQuestions` list (or replace the whole list). Each entry has:

- `id`: a unique string, e.g. `'q1'`, `'q2'`, … `'q100'`.
- `subject`: one of `MockSubject.english`, `.generalKnowledge`,
  `.pakistanStudies`, `.islamiat`, `.mathematics`, `.everydayScience`.
- `question`: the question text.
- `options`: exactly 4 option strings (the constructor asserts this).
- `correctIndex`: `0`, `1`, `2` or `3` — the index of the correct option
  (0 = first option, 1 = second, 2 = third, 3 = fourth).
- `topic` (optional): a short topic label, e.g. `'Geography'`.

**Example entry:**

```dart
MockQuestion(
  id: 'q1',
  subject: MockSubject.pakistanStudies,
  question: 'Pakistan ka qaumi khel konsa hai?',
  options: const ['Cricket', 'Hockey', 'Football', 'Squash'],
  correctIndex: 1,
  topic: 'National symbols',
),
```

After editing, rebuild with `flutter build web --release` (see §1). The
engine needs no changes: it works with any number of questions. Full mock
= all questions in the list (aim for 100); subject-wise tests filter the
list by subject (aim for 20 per subject). The 100-question behaviour is
verified by the generated-session test in `test/mock_test_engine_test.dart`
(it builds 100 questions programmatically and checks answering, scoring,
negative marking, and the unanswered list — without shipping fake
questions as content).

**Session behaviour:** full mock default 90 minutes (60/90/120 selectable);
subject tests default 20 minutes (15/20/30 selectable). Countdown timer
for the whole test, auto-submit at zero, question palette for jumping,
answered/unanswered marking, warning in the last 5 minutes, unanswered
list before submitting, result with score, correct/wrong/skipped counts,
and per-question review. Negative marking is OFF by default; when ON, the
deduction (0.25 / 0.5 / 1.0) is shown before starting and applied in the
result (skipped questions never deduct; score never goes below 0).

## 5. Phase 1 features — status

1. **Weak-Keys Drill** — done. Practice dashboard card lists weak keys
   from existing mistake records; chips drill one key; button starts a
   drill over all weak keys (reuses existing character-practice engine).
2. **Custom Paragraph** — done. "Save & Start Test" on the paragraph form
   (English + Urdu), same timing/result flow as existing tests. The
   original paste → My Paragraphs → "Use for Test" flow still works.
3. **Result Card Share** — done on web. PNG download via
   `RepaintBoundary` capture + browser download; Copy Result (clipboard
   text) on web and desktop. On desktop the download button is hidden
   (no browser download there) — copy-text is the desktop route.
4. **Subject-wise Mock Tests** — done. Full mock + per-subject short
   tests; samples grouped by subject in `mock_questions.dart`.
5. **Negative Marking Toggle** — done. Default OFF, deduction selectable
   (0.25/0.5/1.0), shown before starting, honoured in scoring/results.
6. **Time Warning + Unanswered List** — done. Warning banner in the last
   5 minutes; submit-confirm dialog lists unanswered question numbers
   with "Go Back" / "Submit Anyway".
7. **Landing/SEO** — done. `web/index.html` has a proper title, meta
   description, keywords, Open Graph/Twitter tags, theme colour, and a
   `<noscript>` landing description. The Flutter bootstrap is untouched.
   Note: the app is a single-page Flutter app, so search engines see the
   landing description, not per-screen content. No separate site was
   built (out of scope).
8. **Leaderboard** — on-device board done; **shared/global leaderboard
   deferred with reason.** There is no backend and no accounts in this
   build, so a shared leaderboard cannot honestly exist here. The
   Profile page shows "Best Scores on This Device" (top WPM/accuracy from
   local storage, clearly labelled). No fake scores from other people are
   shown. A shared leaderboard needs user accounts + a backend service —
   that is the one deferred item.

## 6. Remaining gaps / blockers

- **No headless-browser smoke check was possible** in the build
  environment (no Chromium/Firefox available, no Playwright). The build
  was verified by serving `build/web` and curl-checking that
  `index.html`, `main.dart.js`, `flutter.js`/`flutter_bootstrap.js`,
  `sqlite3.wasm` and `drift_worker.js` return HTTP 200. A visual/runtime
  check in a real browser (app mounts, typing test runs, WASM database
  opens, history persists across reload) still needs to be done by a
  human or a browser-capable agent before calling the web build "fully
  verified".
- **WASM persistence depends on the browser** (OPFS/IndexedDB support);
  see §3. The in-memory fallback loses history on refresh.
- **No commit/push/deploy was done** for this app (not approved). The
  working copy lives at `~/workspace/typing-master/`; the original zip
  was left untouched.
- **Ownership question unanswered:** it was asked whether this app is
  the user's own creation; no answer was recorded. Do not publish it
  publicly until that is confirmed.
- The built-in MCQ sample set is 18 questions, not 100. The user adds
  their own 100 (see §4); the engine demonstrably supports 100.
