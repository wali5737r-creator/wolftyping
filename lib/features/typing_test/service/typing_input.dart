import '../../settings/controller/settings_controller.dart';
import 'typing_engine.dart';

/// The single place raw key input is handed to a [TypingEngine] by every
/// controller (English, Urdu, PPSC, Lessons, Mistake Practice). Doing it
/// here means the "Allow backspace" setting behaves identically
/// everywhere without each controller repeating the logic.
///
/// The engine stays pure Dart.
class TypingInput {
  TypingInput._();

  static void character(TypingEngine? engine, String character) {
    if (engine == null) return;
    // One key press can deliver more than one code point (some Urdu
    // layouts, IME output). The engine compares one Unicode character at
    // a time, so feed each code point separately.
    for (final int rune in character.runes) {
      engine.typeCharacter(String.fromCharCode(rune));
    }
  }

  static void space(TypingEngine? engine) {
    if (engine == null) return;
    engine.handleSpace();
  }

  static void backspace(TypingEngine? engine) {
    if (engine == null) return;
    if (SettingsController.currentOrNull?.allowBackspace == false) return;
    engine.handleBackspace();
  }
}
