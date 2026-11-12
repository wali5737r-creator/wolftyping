# Fonts

## Urdu (required, declared in pubspec.yaml)

Noto Nastaliq Urdu (variable font, wght 400–700, SIL Open Font
Licence, from google/fonts) at:

    assets/fonts/NotoNastaliqUrdu.ttf

Family name used in code: `Noto Nastaliq Urdu` (see
`lib/core/constants/app_fonts.dart`). The file is in the repo. It
replaces Jameel Noori Nastaleeq (10.8 MB), which was too large to
finish downloading on slow connections, so Urdu never appeared for
those users. The variable file is declared once per weight the app
uses (400, 500, 700) in pubspec.yaml.

Urdu styles live in `lib/core/constants/app_text_styles.dart`
(`typingTextUr`, `urduBody`, `urduTitle`, `urduHeading`, `urduKey`).

## English / UI (Inter) - NOT configured yet

Inter is a separate future task. Its pubspec block is left commented.
