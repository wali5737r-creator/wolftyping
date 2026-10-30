import 'dart:math';

import '../model/english_paragraph.dart';
import '../model/paragraph_difficulty.dart';

/// Built-in English paragraphs for the Typing Test (spec section 70/71:
/// "the application should ship with built-in lessons and paragraphs").
///
/// This is a static, in-memory provider for now. Once the Paragraphs Drift
/// table is seeded (a later step), this can be replaced or merged with a
/// database-backed source without the Typing Test screen caring — it only
/// ever sees an [EnglishParagraph].
class EnglishParagraphProvider {
  EnglishParagraphProvider._();

  static const List<EnglishParagraph> _easy = [
    EnglishParagraph(
      title: 'Morning Routine',
      difficulty: ParagraphDifficulty.easy,
      text: 'I wake up early every morning and drink a glass of water. '
          'Then I go for a short walk before breakfast. This simple '
          'routine keeps me fresh and ready for the day.',
    ),
    EnglishParagraph(
      title: 'A Walk in the Park',
      difficulty: ParagraphDifficulty.easy,
      text: 'The park near my house is small but very peaceful. Children '
          'play on the swings while their parents sit on the benches and '
          'talk. Birds sing in the trees above.',
    ),
    EnglishParagraph(
      title: 'Making Tea',
      difficulty: ParagraphDifficulty.easy,
      text: 'First you boil the water in a small pot. Then you add the '
          'tea leaves and let them sit for a few minutes. Finally you '
          'pour the tea into a cup and add milk if you like.',
    ),
  ];

  static const List<EnglishParagraph> _medium = [
    EnglishParagraph(
      title: 'The Value of Practice',
      difficulty: ParagraphDifficulty.medium,
      text: 'Learning any new skill requires consistent practice rather '
          'than occasional bursts of effort. A person who studies for '
          'twenty minutes every single day will usually progress faster '
          'than someone who studies for three hours only once a week. '
          'Small, steady habits build lasting ability.',
    ),
    EnglishParagraph(
      title: 'Cities at Night',
      difficulty: ParagraphDifficulty.medium,
      text: 'When the sun sets, a city changes completely. Office '
          'buildings that were full of noise and movement fall quiet, '
          'while restaurants and markets nearby begin to fill with '
          'people. The streets take on a different rhythm, calmer in '
          'some corners and livelier in others.',
    ),
    EnglishParagraph(
      title: 'Choosing a Career',
      difficulty: ParagraphDifficulty.medium,
      text: 'Deciding what to do for a living is rarely a single moment '
          'of clarity. Most people try a few different paths, discover '
          'what they enjoy and what drains them, and slowly adjust their '
          'direction. Patience with this process matters more than '
          'getting it right immediately.',
    ),
  ];

  static const List<EnglishParagraph> _hard = [
    EnglishParagraph(
      title: 'On Uncertainty',
      difficulty: ParagraphDifficulty.hard,
      text: 'Uncertainty is not the absence of knowledge but the presence '
          'of multiple possibilities, each weighted by evidence that is '
          'itself incomplete. A skilled decision-maker does not wait for '
          'certainty before acting; instead, they learn to act reasonably '
          'well under ambiguity, adjusting course as new information '
          'arrives rather than freezing in place.',
    ),
    EnglishParagraph(
      title: 'The Architecture of Habit',
      difficulty: ParagraphDifficulty.hard,
      text: 'Every habit, however trivial it may appear, is the visible '
          'result of an invisible structure: a cue that triggers it, a '
          'routine that constitutes it, and a reward that reinforces it. '
          'Understanding this three-part loop does not automatically '
          'make change easy, but it does make the mechanics of change '
          'legible, which is often the necessary first step.',
    ),
    EnglishParagraph(
      title: 'Technology and Attention',
      difficulty: ParagraphDifficulty.hard,
      text: 'Modern software is frequently engineered, whether explicitly '
          'or as an emergent consequence of metrics-driven design, to '
          'capture and hold human attention for durations that exceed '
          'what the user themselves would consciously choose. '
          'Recognizing this asymmetry between design intent and user '
          'intent is the first step toward reclaiming deliberate, rather '
          'than reactive, use of technology.',
    ),
  ];

  static List<EnglishParagraph> byDifficulty(ParagraphDifficulty difficulty) {
    switch (difficulty) {
      case ParagraphDifficulty.easy:
        return _easy;
      case ParagraphDifficulty.medium:
        return _medium;
      case ParagraphDifficulty.hard:
        return _hard;
    }
  }

  static final Random _random = Random();

  /// A random paragraph from the given difficulty tier.
  static EnglishParagraph randomOf(ParagraphDifficulty difficulty) {
    final List<EnglishParagraph> list = byDifficulty(difficulty);
    return list[_random.nextInt(list.length)];
  }

  /// A random paragraph from any difficulty (backs the "Random paragraph"
  /// option in the Typing Test setup screen).
  static EnglishParagraph randomAny() {
    final List<EnglishParagraph> all = [..._easy, ..._medium, ..._hard];
    return all[_random.nextInt(all.length)];
  }
}
