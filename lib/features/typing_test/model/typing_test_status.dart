/// Lifecycle state of a single typing attempt.
///
/// notStarted -> running -> (paused <-> running) -> completed
///
/// Every mutating method on TypingEngine checks this before doing
/// anything, so "prevent additional typing after completion" and "ignore
/// input while paused" are enforced in exactly one place.
enum TypingTestStatus {
  notStarted,
  running,
  paused,
  completed,
}
