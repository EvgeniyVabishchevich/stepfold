import 'package:walks/domain/failures/catalog_failure.dart';
import 'package:walks/domain/models/catalog_index.dart';
import 'package:walks/domain/models/chapter_content.dart';
import 'package:walks/domain/models/progression.dart';
import 'package:walks/domain/repositories/catalog.dart';

/// A [Catalog] in memory, driven by the test.
///
/// Holds an index and the chapter contents for each language; a language it
/// has no index for falls back to [defaultLanguage].
class FakeCatalog implements Catalog {
  /// Creates a catalog with [indexes] and [contents] by language.
  ///
  /// Without arguments holds one short story in Russian.
  FakeCatalog({
    Map<String, CatalogIndex>? indexes,
    Map<String, List<ChapterContent>>? contents,
    this.defaultLanguage = 'ru',
  }) : _indexes = indexes ?? {'ru': _sampleIndex},
       _contents = contents ?? {'ru': _sampleContents} {
    if (!_indexes.containsKey(defaultLanguage)) {
      throw ArgumentError.value(
        defaultLanguage,
        'defaultLanguage',
        'has no index',
      );
    }
  }

  /// The language used when the asked one has no index.
  final String defaultLanguage;

  final Map<String, CatalogIndex> _indexes;
  final Map<String, List<ChapterContent>> _contents;
  CatalogFailure? _failure;
  int _failuresLeft = 0;

  /// Makes the next [times] calls of either method throw [failure].
  void failNext(CatalogFailure failure, {int times = 1}) {
    _failure = failure;
    _failuresLeft = times;
  }

  @override
  Future<CatalogIndex> index(String language) async {
    _throwIfFailing();
    return _indexes[_languageFor(language)]!;
  }

  @override
  Future<ChapterContent> chapterContent(
    String progressionId,
    String chapterId,
    String language,
  ) async {
    _throwIfFailing();
    final chosen = _languageFor(language);
    final progression = _indexes[chosen]!.progressionById(progressionId);
    if (progression?.chapterById(chapterId) == null) {
      throw ChapterNotFound(progressionId, chapterId);
    }
    final content = _contents[chosen]
        ?.where(
          (c) => c.progressionId == progressionId && c.chapterId == chapterId,
        )
        .firstOrNull;
    // A chapter in the index but without content is a broken setup of the
    // test, not a situation of the app.
    if (content == null) {
      throw StateError('no content for $progressionId/$chapterId');
    }
    return content;
  }

  String _languageFor(String language) =>
      _indexes.containsKey(language) ? language : defaultLanguage;

  void _throwIfFailing() {
    final failure = _failure;
    if (failure != null && _failuresLeft > 0) {
      _failuresLeft--;
      throw failure;
    }
  }

  static const _sampleIndex = CatalogIndex(
    kinds: [ProgressionKind(id: 'story', title: 'История')],
    lengthGroups: [
      LengthGroup(id: 'short', title: 'Короткие', maxSteps: 30000),
      LengthGroup(id: 'long', title: 'Длинные'),
    ],
    progressions: [
      Progression(
        id: 'sample',
        kind: 'story',
        order: ChapterOrder.strict,
        title: 'Пробная история',
        chapters: [
          Chapter(id: 'c1', price: 1000, title: 'Начало'),
          Chapter(id: 'c2', price: 5000, title: 'Конец'),
        ],
      ),
    ],
  );

  static const _sampleContents = [
    ChapterContent(
      progressionId: 'sample',
      chapterId: 'c1',
      blocks: [ContentBlock.paragraph(text: 'Первая глава.')],
    ),
    ChapterContent(
      progressionId: 'sample',
      chapterId: 'c2',
      blocks: [ContentBlock.paragraph(text: 'Вторая глава.')],
    ),
  ];
}
