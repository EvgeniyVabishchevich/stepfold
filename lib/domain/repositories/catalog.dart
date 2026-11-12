import 'package:walks/domain/models/catalog_index.dart';
import 'package:walks/domain/models/chapter_content.dart';

/// Everything the user can open: kinds, progressions, chapters.
///
/// Read only. The answer depends on `language` (a language code such as
/// `ru`); a language the catalog has no texts for falls back to its default
/// one. A newer version of the catalog shows up at the next call, not while
/// a screen is open.
///
/// Published ids are never removed, so whatever the user has opened stays
/// in the catalog. Calls fail with a `CatalogFailure`.
abstract interface class Catalog {
  /// The kinds, length groups and progressions, hidden ones included.
  Future<CatalogIndex> index(String language);

  /// The content of [chapterId] in [progressionId].
  ///
  /// Throws `ChapterNotFound` when the catalog has no such chapter.
  Future<ChapterContent> chapterContent(
    String progressionId,
    String chapterId,
    String language,
  );
}
