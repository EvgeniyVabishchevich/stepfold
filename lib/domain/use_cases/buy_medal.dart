import 'package:clock/clock.dart';
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
  /// Throws a `ProgressFailure` when the rules refuse it and a
  /// `StorageFailure` when it cannot be saved.
  Future<void> call(Progression progression) async {
    final current = await _progress.watch().first;
    final (:progress, :spending) = buyNextMedal(
      current,
      progression,
      now: clock.now(),
    );
    await _progress.addSpending(spending, goalAfter: progress.goal);
  }
}
