/// Crashes the native side of the app on purpose, to check that crash
/// reporting catches real native crashes. A debug tool, not for production
/// code.
abstract interface class NativeCrasher {
  /// Makes the native side crash shortly after the call returns.
  Future<void> crash();
}
