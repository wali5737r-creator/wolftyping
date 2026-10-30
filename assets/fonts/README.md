# Fonts

## Urdu (required, declared in pubspec.yaml)

Place your licensed Jameel Noori Nastaleeq file at exactly:

    assets/fonts/JameelNooriNastaleeq.ttf

Family name used in code: `Jameel Noori Nastaleeq` (see
`lib/core/constants/app_fonts.dart`). Until this file exists,
`flutter test` / `flutter build` fail with "unable to locate asset
entry". Check the font's licence before distributing the app.

Urdu styles live in `lib/core/constants/app_text_styles.dart`
(`typingTextUr`, `urduBody`, `urduTitle`, `urduHeading`, `urduKey`).

## English / UI (Inter) - NOT configured yet

Inter is a separate future task. Its pubspec block is left commented.
