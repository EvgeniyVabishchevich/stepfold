import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walks/domain/domain.dart';

part 'history_state.freezed.dart';

/// A manual addition awaiting save or confirmation. Zero removes it.
typedef HistoryEdit = ({Day day, int steps});

/// Live history data and feedback for the current operation.
@freezed
abstract class HistoryState with _$HistoryState {
  /// Creates a history state.
  const factory HistoryState({
    required DateTime now,
    Progress? progress,
    CatalogIndex? catalog,
    StorageFailure? readFailure,
    Exception? writeFailure,
    HistoryEdit? confirmation,
    @Default(false) bool busy,
  }) = _HistoryState;

  const HistoryState._();

  /// The device's current calendar day.
  Day get today => Day.fromLocal(now);

  /// Whether the manual entry restriction is currently in effect.
  bool get locked => progress?.manualEntryLock.isLockedAt(now) ?? false;

  /// The oldest day that the manual-entry form may offer.
  Day get firstEditableDay {
    final limit = today - manualEntryDaysBack;
    final installDay = progress?.installDay ?? today;
    return installDay.isAfter(limit) ? installDay : limit;
  }
}
