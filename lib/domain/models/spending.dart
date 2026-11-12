import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walks/domain/models/medal.dart';

part 'spending.freezed.dart';

/// Steps taken out of the reserve.
///
/// Keeps the [price] paid, so a later change of a price in the catalog does
/// not change the reserve.
@freezed
sealed class Spending with _$Spending {
  /// A chapter was opened.
  const factory Spending.chapter({
    required String progressionId,
    required String chapterId,
    required int price,
    required DateTime at,
  }) = ChapterOpened;

  /// A silver or gold medal was bought.
  const factory Spending.medal({
    required String progressionId,
    required Medal medal,
    required int price,
    required DateTime at,
  }) = MedalBought;
}
