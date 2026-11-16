import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/common.dart';
import 'package:walks/data/repositories/progress/storage_errors.dart';
import 'package:walks/domain/failures/storage_failure.dart';

void main() {
  SqliteException sqlite(int code) =>
      SqliteException(extendedResultCode: code, message: 'test');

  group('translateStorageError', () {
    test('a full disk is StorageFull', () {
      expect(
        translateStorageError(sqlite(SqlError.SQLITE_FULL)),
        isA<StorageFull>(),
      );
    });

    test('a damaged or unopenable file is StorageUnavailable', () {
      expect(
        translateStorageError(sqlite(SqlError.SQLITE_CORRUPT)),
        isA<StorageUnavailable>(),
      );
      expect(
        translateStorageError(sqlite(SqlError.SQLITE_CANTOPEN)),
        isA<StorageUnavailable>(),
      );
    });

    test('an extended code is read by its primary code', () {
      expect(
        translateStorageError(sqlite(SqlExtendedError.SQLITE_CORRUPT_INDEX)),
        isA<StorageUnavailable>(),
      );
      expect(
        translateStorageError(
          sqlite(SqlExtendedError.SQLITE_CONSTRAINT_PRIMARYKEY),
        ),
        isA<StateError>(),
      );
    });

    test('a broken constraint is a StateError: a bug', () {
      expect(
        translateStorageError(sqlite(SqlError.SQLITE_CONSTRAINT)),
        isA<StateError>(),
      );
    });

    test('an error not from SQLite is left as it is', () {
      const error = FormatException('x');

      expect(translateStorageError(error), same(error));
    });
  });
}
