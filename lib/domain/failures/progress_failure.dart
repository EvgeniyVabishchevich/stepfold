/// Why a step of progress, such as opening a chapter, was refused.
sealed class ProgressFailure implements Exception {
  const ProgressFailure();
}

/// The reserve has fewer steps than the price.
final class NotEnoughSteps extends ProgressFailure {
  /// Creates the failure.
  const NotEnoughSteps({required this.price, required this.reserve});

  /// The steps needed.
  final int price;

  /// The steps in the reserve.
  final int reserve;

  @override
  String toString() => 'NotEnoughSteps(price: $price, reserve: $reserve)';
}

/// The chapter is not in the progression, already opened, or locked by
/// the strict chapter order.
final class ChapterUnavailable extends ProgressFailure {
  /// Creates the failure.
  const ChapterUnavailable(this.chapterId);

  /// The chapter that was asked for.
  final String chapterId;

  @override
  String toString() => 'ChapterUnavailable($chapterId)';
}

/// The medal cannot be bought now: the progression is not finished, or the
/// medal is not the next one.
final class MedalUnavailable extends ProgressFailure {
  /// Creates the failure.
  const MedalUnavailable(this.progressionId);

  /// The progression of the medal.
  final String progressionId;

  @override
  String toString() => 'MedalUnavailable($progressionId)';
}
