import 'package:walks/domain/failures/manual_entry_failure.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/manual_entry_lock.dart';

/// Adding more steps by hand than this asks the user to confirm it.
const manualEntryConfirmAbove = 50000;

/// How many days back, before today, steps can be added.
const manualEntryDaysBack = 7;

/// What to do with an addition that passed the checks.
enum ManualEntryCheck {
  /// Save it.
  ok,

  /// Ask the user to confirm the unusually large addition, then save it.
  needsConfirmation,
}

/// Checks [steps] added by hand to [day]; zero removes the addition.
///
/// The day must be between [installDay] and [today], and at most
/// [manualEntryDaysBack] days back. Throws a [ManualEntryFailure] when the
/// entry is refused.
ManualEntryCheck checkManualEntry({
  required Day day,
  required int steps,
  required Day installDay,
  required Day today,
  required ManualEntryLock lock,
  required DateTime now,
}) {
  if (lock.isLockedAt(now)) throw const ManualEntryLocked();
  if (day.isAfter(today) ||
      day.isBefore(installDay) ||
      today.difference(day) > manualEntryDaysBack) {
    throw const ManualEntryDayOutOfRange();
  }
  if (steps < 0) throw const ManualEntryNegative();
  return steps > manualEntryConfirmAbove
      ? ManualEntryCheck.needsConfirmation
      : ManualEntryCheck.ok;
}
