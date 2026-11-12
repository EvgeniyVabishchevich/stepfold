import 'package:freezed_annotation/freezed_annotation.dart';

part 'progression.freezed.dart';

/// Which chapters of a progression can be opened next.
enum ChapterOrder {
  /// Only the first chapter that is not opened yet.
  strict,

  /// Any chapter that is not opened yet.
  free,
}

/// A chapter: one step of a progression, opened for [price] steps.
///
/// Holds only what a list shows. The text and pictures of the chapter are
/// its `ChapterContent`, read from the catalog when the chapter is opened.
@freezed
abstract class Chapter with _$Chapter {
  /// Creates a chapter.
  const factory Chapter({
    required String id,
    required int price,
    @Default('') String title,
  }) = _Chapter;
}

/// A progression: an ordered list of chapters of one kind.
///
/// Finishing every chapter gives the bronze medal of the progression.
@freezed
abstract class Progression with _$Progression {
  /// Creates a progression.
  ///
  /// A [hidden] progression is no longer offered to new users, but stays
  /// for those who started it: published ids are never removed.
  const factory Progression({
    required String id,
    required String kind,
    required ChapterOrder order,
    required List<Chapter> chapters,
    @Default('') String title,
    @Default('') String description,
    @Default(false) bool hidden,
  }) = _Progression;

  const Progression._();

  /// The price of all chapters together. Medal prices are a share of it.
  int get routePrice => chapters.fold(0, (sum, c) => sum + c.price);

  /// The chapter with [chapterId], or `null` if it is not in this progression.
  Chapter? chapterById(String chapterId) {
    for (final chapter in chapters) {
      if (chapter.id == chapterId) return chapter;
    }
    return null;
  }
}
