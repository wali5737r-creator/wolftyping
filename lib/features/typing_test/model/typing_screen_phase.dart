/// Which panel of a typing screen is currently shown — distinct from
/// `TypingTestStatus` (the engine's own running/paused/completed state).
/// [result] is only reached once the engine reaches
/// `TypingTestStatus.completed`.
///
/// Shared by `UrduTypingController` and `PpscTypingController` so the two
/// don't each redeclare an identical enum. The English `TypingController`
/// keeps its own private copy from before this feature existed — left
/// untouched so the working English Typing Test is never modified.
enum TypingScreenPhase { setup, test, result }
