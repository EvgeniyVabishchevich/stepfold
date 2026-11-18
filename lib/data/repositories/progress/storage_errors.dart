import 'package:drift/isolate.dart' show DriftRemoteException;
import 'package:sqlite3/common.dart' show SqlError, SqliteException;
import 'package:walks/domain/failures/failures.dart';

/// Translates an [error] of SQLite into a [StorageFailure].
///
/// A database in a background isolate wraps the error in a
/// [DriftRemoteException]. A broken constraint is a bug and becomes a
/// [StateError]. Anything not from SQLite is returned as it is.
Object translateStorageError(Object error) {
  final cause = error is DriftRemoteException ? error.remoteCause : error;
  if (cause is! SqliteException) return error;
  // The primary code: the extended one, such as SQLITE_CORRUPT_INDEX, is a
  // variant of it.
  return switch (cause.resultCode) {
    SqlError.SQLITE_FULL => const StorageFull(),
    SqlError.SQLITE_CONSTRAINT => StateError('constraint failed: $cause'),
    _ => StorageUnavailable(cause),
  };
}

/// Runs [body], translating its errors with [translateStorageError].
Future<T> guardStorage<T>(Future<T> Function() body) async {
  try {
    return await body();
  } on Object catch (error, stackTrace) {
    final translated = translateStorageError(error);
    if (identical(translated, error)) rethrow;
    Error.throwWithStackTrace(translated, stackTrace);
  }
}
