import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/failures/catalog_failure.dart';
import 'package:walks/domain/models/catalog_index.dart';
import 'package:walks/domain/models/chapter_content.dart';
import 'package:walks/domain/models/progression.dart';
import 'package:walks/domain/repositories/catalog.dart';

/// The behaviour every [Catalog] must share.
///
/// [create] builds a catalog that holds exactly the contract catalog: the
/// indexes [contractIndexRu] and [contractIndexEn], the contents
/// [contractContentsRu] and [contractContentsEn], with `ru` as the default
/// language.
void catalogContract(Catalog Function() create) {
  group('Catalog contract', () {
    late Catalog catalog;

    setUp(() => catalog = create());

    test('index returns the catalog in the asked language', () async {
      expect(await catalog.index('ru'), contractIndexRu);
      expect(await catalog.index('en'), contractIndexEn);
    });

    test('index falls back to the default language', () async {
      expect(await catalog.index('de'), contractIndexRu);
    });

    test('index keeps hidden progressions: users who started them still '
        'need them', () async {
      final index = await catalog.index('ru');

      expect(index.progressionById('old')?.hidden, isTrue);
    });

    test('index gives the same answer every time', () async {
      expect(await catalog.index('ru'), await catalog.index('ru'));
    });

    test('chapterContent returns the content in the asked language', () async {
      expect(
        await catalog.chapterContent('lighthouse', 'c1', 'ru'),
        contractContentsRu.first,
      );
      expect(
        await catalog.chapterContent('lighthouse', 'c1', 'en'),
        contractContentsEn.first,
      );
    });

    test('chapterContent falls back to the default language', () async {
      expect(
        await catalog.chapterContent('lighthouse', 'c2', 'de'),
        contractContentsRu[1],
      );
    });

    test('chapterContent has content for every chapter of the index, '
        'hidden progressions included', () async {
      final index = await catalog.index('ru');

      for (final progression in index.progressions) {
        for (final chapter in progression.chapters) {
          final content = await catalog.chapterContent(
            progression.id,
            chapter.id,
            'ru',
          );
          expect(content.progressionId, progression.id);
          expect(content.chapterId, chapter.id);
          expect(content.blocks, isNotEmpty);
        }
      }
    });

    test('chapterContent throws ChapterNotFound for an unknown chapter', () {
      return expectLater(
        catalog.chapterContent('lighthouse', 'c9', 'ru'),
        throwsA(
          isA<ChapterNotFound>()
              .having((f) => f.progressionId, 'progressionId', 'lighthouse')
              .having((f) => f.chapterId, 'chapterId', 'c9'),
        ),
      );
    });

    test('chapterContent throws ChapterNotFound for an unknown '
        'progression', () {
      return expectLater(
        catalog.chapterContent('nowhere', 'c1', 'ru'),
        throwsA(isA<ChapterNotFound>()),
      );
    });

    test('chapterContent throws ChapterNotFound for a chapter of another '
        'progression: chapter ids are unique only inside one', () {
      return expectLater(
        catalog.chapterContent('lighthouse', 'o1', 'ru'),
        throwsA(isA<ChapterNotFound>()),
      );
    });
  });
}

/// The index of the contract catalog in Russian.
const contractIndexRu = CatalogIndex(
  kinds: [ProgressionKind(id: 'story', title: 'История')],
  lengthGroups: [
    LengthGroup(id: 'short', title: 'Короткие', maxSteps: 10000),
    LengthGroup(id: 'long', title: 'Длинные'),
  ],
  progressions: [
    Progression(
      id: 'lighthouse',
      kind: 'story',
      order: ChapterOrder.strict,
      title: 'Маяк',
      description: 'Ночь на острове',
      chapters: [
        Chapter(id: 'c1', price: 1000, title: 'Остров'),
        Chapter(id: 'c2', price: 5000, title: 'Шторм'),
      ],
    ),
    Progression(
      id: 'old',
      kind: 'story',
      order: ChapterOrder.free,
      title: 'Старое',
      hidden: true,
      chapters: [Chapter(id: 'o1', price: 2000, title: 'Единственная')],
    ),
  ],
);

/// The index of the contract catalog in English.
const contractIndexEn = CatalogIndex(
  kinds: [ProgressionKind(id: 'story', title: 'Story')],
  lengthGroups: [
    LengthGroup(id: 'short', title: 'Short', maxSteps: 10000),
    LengthGroup(id: 'long', title: 'Long'),
  ],
  progressions: [
    Progression(
      id: 'lighthouse',
      kind: 'story',
      order: ChapterOrder.strict,
      title: 'Lighthouse',
      description: 'A night on an island',
      chapters: [
        Chapter(id: 'c1', price: 1000, title: 'Island'),
        Chapter(id: 'c2', price: 5000, title: 'Storm'),
      ],
    ),
    Progression(
      id: 'old',
      kind: 'story',
      order: ChapterOrder.free,
      title: 'Old',
      hidden: true,
      chapters: [Chapter(id: 'o1', price: 2000, title: 'The only one')],
    ),
  ],
);

/// The picture of chapter `lighthouse/c1`, the same in every language.
final Uri contractImage = Uri.parse('asset:assets/catalog/images/island.png');

/// The chapter contents of the contract catalog in Russian.
final List<ChapterContent> contractContentsRu = [
  ChapterContent(
    progressionId: 'lighthouse',
    chapterId: 'c1',
    blocks: [
      const ContentBlock.paragraph(text: 'Остров в тумане.'),
      ContentBlock.image(source: contractImage, caption: 'Остров'),
    ],
  ),
  const ChapterContent(
    progressionId: 'lighthouse',
    chapterId: 'c2',
    blocks: [
      ContentBlock.mapPoint(latitude: 60, longitude: 30.5, label: 'Мыс'),
    ],
  ),
  const ChapterContent(
    progressionId: 'old',
    chapterId: 'o1',
    blocks: [ContentBlock.paragraph(text: 'Старая глава.')],
  ),
];

/// The chapter contents of the contract catalog in English.
final List<ChapterContent> contractContentsEn = [
  ChapterContent(
    progressionId: 'lighthouse',
    chapterId: 'c1',
    blocks: [
      const ContentBlock.paragraph(text: 'An island in fog.'),
      ContentBlock.image(source: contractImage, caption: 'Island'),
    ],
  ),
  const ChapterContent(
    progressionId: 'lighthouse',
    chapterId: 'c2',
    blocks: [
      ContentBlock.mapPoint(latitude: 60, longitude: 30.5, label: 'Cape'),
    ],
  ),
  const ChapterContent(
    progressionId: 'old',
    chapterId: 'o1',
    blocks: [ContentBlock.paragraph(text: 'An old chapter.')],
  ),
];
