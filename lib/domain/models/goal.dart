import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walks/domain/models/medal.dart';

part 'goal.freezed.dart';

/// What the user is saving steps for.
///
/// A goal only points at something: the steps stay in the reserve until the
/// user opens the chapter or buys the medal.
@freezed
sealed class Goal with _$Goal {
  /// Saving for a chapter.
  const factory Goal.chapter({
    required String progressionId,
    required String chapterId,
  }) = ChapterGoal;

  /// Saving for the next medal of a finished progression.
  const factory Goal.medal({
    required String progressionId,
    required Medal medal,
  }) = MedalGoal;
}
