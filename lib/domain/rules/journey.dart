import 'package:walks/domain/models/models.dart';

/// The last reached stop and the steps available for the next leg, if active.
typedef JourneyPosition = ({int reachedStop, int? previewSteps});

/// Locates the user on a journey using opened chapters and the step reserve.
/// Returns null when the route has no reached stop to display.
JourneyPosition? journeyPosition(Progression progression, Progress progress) {
  if (progression.journeyLegs.isEmpty) return null;

  final chapters = progression.chapters;
  final reached = chapters.lastIndexWhere(
    (chapter) => progress.isOpened(progression.id, chapter.id),
  );
  if (reached < 0) return null;
  if (reached == chapters.length - 1) {
    return (reachedStop: reached, previewSteps: null);
  }

  final next = chapters[reached + 1];
  final isTarget =
      progress.goal ==
      Goal.chapter(progressionId: progression.id, chapterId: next.id);
  return (
    reachedStop: reached,
    previewSteps: isTarget ? progress.reserve.clamp(0, next.price) : null,
  );
}
