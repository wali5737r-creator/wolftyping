/// Non-web implementation of the cross-tab database-change signal.
///
/// BroadcastChannel does not exist here, and it is not needed: on
/// desktop/mobile the database is a real SQLite file, so every read
/// already sees every other tab's/process's writes — there is no stale
/// in-memory snapshot to heal. Both functions are deliberate no-ops
/// (also the implementation `flutter test` uses on the VM).
void postDbChanged(String channelName) {}

void listenDbChanged(String channelName, void Function() onDbChanged) {}
