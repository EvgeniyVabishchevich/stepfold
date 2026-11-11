import 'dart:collection';
import 'dart:developer' as developer;

import 'package:walks/domain/repositories/crash_reporter.dart';

/// One error recorded by [FakeCrashReporter], with the context it was sent
/// with.
class RecordedError {
  /// Creates a record.
  const RecordedError({
    required this.error,
    required this.stack,
    required this.fatal,
    required this.reason,
    required this.trail,
    required this.userId,
    required this.keys,
  });

  /// The error itself.
  final Object error;

  /// Where it happened.
  final StackTrace? stack;

  /// Whether it was recorded as fatal.
  final bool fatal;

  /// The caller's note.
  final String? reason;

  /// The trail of [CrashReporter.log] messages at the moment of the error.
  final List<String> trail;

  /// The user at the moment of the error.
  final String? userId;

  /// The context keys at the moment of the error.
  final Map<String, Object> keys;
}

/// A [CrashReporter] that keeps everything in memory and prints it to the
/// console.
///
/// Like the real services, it attaches the trail, the user and the keys to
/// each error, and keeps only the last [maxTrailLength] trail messages.
class FakeCrashReporter implements CrashReporter {
  /// Creates a reporter with an empty history.
  FakeCrashReporter({this.maxTrailLength = 100});

  /// How many trail messages are kept; older ones are dropped.
  final int maxTrailLength;

  final List<RecordedError> _errors = [];
  final Queue<String> _trail = Queue();
  final Map<String, Object> _keys = {};
  String? _userId;

  /// Every error recorded so far, oldest first.
  List<RecordedError> get errors => List.unmodifiable(_errors);

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
    String? reason,
  }) async {
    _errors.add(
      RecordedError(
        error: error,
        stack: stack,
        fatal: fatal,
        reason: reason,
        trail: List.unmodifiable(_trail),
        userId: _userId,
        keys: Map.unmodifiable(_keys),
      ),
    );
    developer.log(
      '${fatal ? 'FATAL' : 'non-fatal'}${reason == null ? '' : ' ($reason)'}',
      name: 'crash',
      error: error,
      stackTrace: stack,
    );
  }

  @override
  void log(String message) {
    _trail.addLast(message);
    while (_trail.length > maxTrailLength) {
      _trail.removeFirst();
    }
  }

  @override
  Future<void> setUserId(String? id) async => _userId = id;

  @override
  Future<void> setKey(String key, Object value) async => _keys[key] = value;
}
