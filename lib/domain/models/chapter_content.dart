import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_content.freezed.dart';

/// One piece of a chapter, shown top to bottom.
@freezed
sealed class ContentBlock with _$ContentBlock {
  /// A paragraph of plain text, without markup.
  const factory ContentBlock.paragraph({required String text}) = Paragraph;

  /// A picture.
  ///
  /// [source] has a scheme the screen knows how to load: `asset:` for a file
  /// inside the app, later `https:` or `file:`.
  const factory ContentBlock.image({
    required Uri source,
    @Default('') String caption,
  }) = ImageBlock;

  /// A point on the real route of a journey.
  const factory ContentBlock.mapPoint({
    required double latitude,
    required double longitude,
    @Default('') String label,
  }) = MapPoint;
}

/// The heavy part of a chapter: what the user reads after opening it.
@freezed
abstract class ChapterContent with _$ChapterContent {
  /// Creates the content of [chapterId] in [progressionId].
  const factory ChapterContent({
    required String progressionId,
    required String chapterId,
    required List<ContentBlock> blocks,
  }) = _ChapterContent;
}
