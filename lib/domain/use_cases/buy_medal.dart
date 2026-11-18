import 'package:clock/clock.dart';
import 'package:walks/domain/failures/progress_failure.dart';
import 'package:walks/domain/models/medal.dart';
import 'package:walks/domain/models/progression.dart';
import 'package:walks/domain/repositories/progress_repository.dart';
import 'package:walks/domain/rules/medals.dart';

/// Buys the next medal of a finished progression and saves it.
class BuyMedal {
  /// Creates the use case on the given progress.
  BuyMedal(this._progress);

  final ProgressRepository _progress;

  /// Buys the next medal of [progression] now.
  ///
  /// If [expected] is supplied, refuses a stale selection of the next medal.
  ///
  /// Throws a `ProgressFailure` when the rules refuse it and a
  /// `StorageFailure` when it cannot be saved.
  Future<void> call(Progression progression, {Medal? expected}) =>
      _progress.addSpending((current) {
        if (expected != null &&
            medalOf(current, progression)?.next != expected) {
          throw MedalUnavailable(progression.id);
        }
        final (:progress, :spending) = buyNextMedal(
          current,
          progression,
          now: clock.now(),
        );
        return (spending: spending, goalAfter: progress.goal);
      });
}
