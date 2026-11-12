import 'package:freezed_annotation/freezed_annotation.dart';

part 'manual_entry_lock.freezed.dart';

/// How long it takes for an unlock of manual entry to take effect.
const manualEntryUnlockDelay = Duration(hours: 2);

/// The user's own lock on manual entry.
///
/// Locking works at once. Unlocking waits [manualEntryUnlockDelay], so the
/// lock cannot be lifted on a whim.
@freezed
abstract class ManualEntryLock with _$ManualEntryLock {
  /// Creates a lock state.
  const factory ManualEntryLock({
    @Default(false) bool locked,
    DateTime? unlockAt,
  }) = _ManualEntryLock;

  const ManualEntryLock._();

  /// Whether manual entry is locked at [now].
  bool isLockedAt(DateTime now) {
    if (!locked) return false;
    final unlockAt = this.unlockAt;
    return unlockAt == null || now.isBefore(unlockAt);
  }

  /// Locks manual entry and cancels a pending unlock.
  ManualEntryLock lock() => const ManualEntryLock(locked: true);

  /// Starts the unlock at [now]; it takes effect after
  /// [manualEntryUnlockDelay]. A second request does not restart the wait.
  ManualEntryLock requestUnlock(DateTime now) {
    if (!isLockedAt(now) || unlockAt != null) return this;
    return copyWith(unlockAt: now.toUtc().add(manualEntryUnlockDelay));
  }
}
