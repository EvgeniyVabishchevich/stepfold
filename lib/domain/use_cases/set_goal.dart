import 'package:walks/domain/models/goal.dart';
import 'package:walks/domain/models/progression.dart';
import 'package:walks/domain/repositories/progress_repository.dart';
import 'package:walks/domain/rules/goal.dart';

/// Chooses or removes the goal and saves it.
class SetGoal {
  /// Creates the use case on the given progress.
  SetGoal(this._progress);

  final ProgressRepository _progress;

  /// Sets [goal], which belongs to [progression].
  ///
  /// Throws a `ProgressFailure` when the goal cannot be opened or bought
  /// next, and a `StorageFailure` when it cannot be saved.
  Future<void> call(Goal goal, Progression progression) async {
    final progress = await _progress.watch().first;
    final next = selectGoal(progress, goal, progression);
    await _progress.saveGoal(next.goal);
  }

  /// Removes the goal.
  ///
  /// Throws a `StorageFailure` when it cannot be saved.
  Future<void> clear() => _progress.saveGoal(null);
}
