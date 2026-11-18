import 'package:clock/clock.dart';
import 'package:walks/domain/models/progression.dart';
import 'package:walks/domain/repositories/progress_repository.dart';
import 'package:walks/domain/rules/chapters.dart';

/// Opens a chapter, paying from the reserve, and saves it.
class OpenChapter {
  /// Creates the use case on the given progress.
  OpenChapter(this._progress);

  final ProgressRepository _progress;

  /// Opens [chapterId] of [progression] now.
  ///
  /// Throws a `ProgressFailure` when the rules refuse it and a
  /// `StorageFailure` when it cannot be saved.
  Future<void> call(Progression progression, String chapterId) =>
      _progress.addSpending((current) {
        final (:progress, :spending) = openChapter(
          current,
          progression,
          chapterId,
          now: clock.now(),
        );
        return (spending: spending, goalAfter: progress.goal);
      });
}
