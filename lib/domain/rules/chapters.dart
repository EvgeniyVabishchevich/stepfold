import 'package:walks/domain/failures/progress_failure.dart';
import 'package:walks/domain/models/goal.dart';
import 'package:walks/domain/models/progress.dart';
import 'package:walks/domain/models/progression.dart';
import 'package:walks/domain/models/spending.dart';

/// Chapters of [progression] that can be opened next.
///
/// With the strict order it is the first chapter not opened yet; with the
/// free order, every chapter not opened yet.
List<Chapter> availableChapters(Progress progress, Progression progression) {
  final closed = progression.chapters
      .where((c) => !progress.isOpened(progression.id, c.id))
      .toList();
  return switch (progression.order) {
    ChapterOrder.strict => closed.take(1).toList(),
    ChapterOrder.free => closed,
  };
}

/// Whether [chapterId] can be opened next in [progression].
bool isChapterAvailable(
  Progress progress,
  Progression progression,
  String chapterId,
) => availableChapters(progress, progression).any((c) => c.id == chapterId);

/// Whether every chapter of [progression] is opened.
bool isFinished(Progress progress, Progression progression) =>
    progression.chapters.every((c) => progress.isOpened(progression.id, c.id));

/// Opens [chapterId] of [progression] at [now], paying its price from the
/// reserve.
///
/// If it was the goal, the goal moves to the next chapter with the strict
/// order and is removed with the free order or after the last chapter.
///
/// Throws [ChapterUnavailable] if the chapter cannot be opened next, and
/// [NotEnoughSteps] if the reserve is short.
Progress openChapter(
  Progress progress,
  Progression progression,
  String chapterId, {
  required DateTime now,
}) {
  final chapter = progression.chapterById(chapterId);
  if (chapter == null ||
      !isChapterAvailable(progress, progression, chapterId)) {
    throw ChapterUnavailable(chapterId);
  }
  if (progress.reserve < chapter.price) {
    throw NotEnoughSteps(price: chapter.price, reserve: progress.reserve);
  }

  final opened = progress.copyWith(
    spendings: [
      ...progress.spendings,
      Spending.chapter(
        progressionId: progression.id,
        chapterId: chapterId,
        price: chapter.price,
        at: now.toUtc(),
      ),
    ],
  );

  final wasGoal =
      progress.goal ==
      Goal.chapter(progressionId: progression.id, chapterId: chapterId);
  if (!wasGoal) return opened;
  return opened.copyWith(goal: _goalAfterChapter(opened, progression));
}

Goal? _goalAfterChapter(Progress progress, Progression progression) {
  if (progression.order == ChapterOrder.free) return null;
  final next = availableChapters(progress, progression);
  if (next.isEmpty) return null;
  return Goal.chapter(progressionId: progression.id, chapterId: next.first.id);
}
