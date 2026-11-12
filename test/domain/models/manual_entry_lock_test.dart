import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/models/manual_entry_lock.dart';

void main() {
  final now = DateTime.utc(2026, 11, 12, 15);

  group('ManualEntryLock', () {
    test('is open by default', () {
      expect(const ManualEntryLock().isLockedAt(now), isFalse);
    });

    test('locks at once', () {
      expect(const ManualEntryLock().lock().isLockedAt(now), isTrue);
    });

    test('unlocks only 2 hours after the request', () {
      final requested = const ManualEntryLock().lock().requestUnlock(now);

      expect(requested.isLockedAt(now), isTrue);
      expect(
        requested.isLockedAt(now.add(const Duration(hours: 1, minutes: 59))),
        isTrue,
      );
      expect(requested.isLockedAt(now.add(const Duration(hours: 2))), isFalse);
    });

    test('a second unlock request does not restart the wait', () {
      final first = const ManualEntryLock().lock().requestUnlock(now);
      final second = first.requestUnlock(now.add(const Duration(hours: 1)));

      expect(second.unlockAt, first.unlockAt);
    });

    test('locking again cancels a pending unlock', () {
      final relocked = const ManualEntryLock().lock().requestUnlock(now).lock();

      expect(relocked.isLockedAt(now.add(const Duration(days: 2))), isTrue);
    });
  });
}
