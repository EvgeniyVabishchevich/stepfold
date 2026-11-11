/// Sends errors from the app to a crash reporting service.
///
/// [log], [setUserId] and [setKey] send nothing by themselves: they are
/// attached to every later [recordError].
///
/// Never throws. A failure inside the reporter is printed to the console and
/// swallowed, because it is called while handling another error, and a throw
/// here would skip the code that handles that error.
abstract interface class CrashReporter {
  /// Records [error] with its [stack].
  ///
  /// [fatal] is true when the error broke what the user was doing. [reason]
  /// is a short note from the caller, for example `unlock chapter`.
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
    String? reason,
  });

  /// Adds [message] to the trail of events sent with the next error.
  ///
  /// Starts with the source in brackets, for example `[steps] synced +350`.
  void log(String message);

  /// Sets the internal id of the signed-in user, or `null` after sign-out.
  ///
  /// Never pass an email or a name.
  Future<void> setUserId(String? id);

  /// Sets a context [key] to [value]: a [String], [num] or [bool].
  Future<void> setKey(String key, Object value);
}
