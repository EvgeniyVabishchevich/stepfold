import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walks/domain/domain.dart';

part 'today_state.freezed.dart';

/// A goal resolved against the catalog and current progress.
typedef TodayGoal = ({
  Goal goal,
  Progression progression,
  String? chapterTitle,
  int price,
  int left,
});

/// The progress snapshot and the transient state of Today.
@freezed
abstract class TodayState with _$TodayState {
  /// Creates a Today snapshot.
  const factory TodayState({
    required Day day,
    Progress? progress,
    StorageFailure? progressFailure,
    TodayGoal? target,
    @Default(true) bool catalogLoading,
    CatalogFailure? catalogFailure,
    Goal? spendingGoal,
    ProgressFailure? spendingFailure,
    StorageFailure? spendingStorageFailure,
    ChapterGoal? openedChapter,
  }) = _TodayState;
}
