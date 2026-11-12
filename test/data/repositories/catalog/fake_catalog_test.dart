import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/catalog/fake_catalog.dart';
import 'package:walks/domain/failures/catalog_failure.dart';

import '../../../contracts/catalog_contract.dart';

void main() {
  catalogContract(
    () => FakeCatalog(
      indexes: {'ru': contractIndexRu, 'en': contractIndexEn},
      contents: {'ru': contractContentsRu, 'en': contractContentsEn},
    ),
  );

  group('FakeCatalog', () {
    test('without arguments holds a sample story with content for every '
        'chapter', () async {
      final catalog = FakeCatalog();
      final index = await catalog.index('ru');

      expect(index.progressions, isNotEmpty);
      for (final p in index.progressions) {
        for (final c in p.chapters) {
          await expectLater(
            catalog.chapterContent(p.id, c.id, 'ru'),
            completes,
          );
        }
      }
    });

    test('failNext makes only the next call throw', () async {
      final catalog = FakeCatalog()..failNext(const CatalogUnavailable());

      await expectLater(
        catalog.index('ru'),
        throwsA(isA<CatalogUnavailable>()),
      );
      await expectLater(catalog.index('ru'), completes);
    });

    test('failNext with times fails that many calls of either '
        'method', () async {
      final catalog = FakeCatalog()
        ..failNext(const CatalogUnavailable(), times: 2);

      await expectLater(
        catalog.index('ru'),
        throwsA(isA<CatalogUnavailable>()),
      );
      await expectLater(
        catalog.chapterContent('sample', 'c1', 'ru'),
        throwsA(isA<CatalogUnavailable>()),
      );
      await expectLater(
        catalog.chapterContent('sample', 'c1', 'ru'),
        completes,
      );
    });

    test('refuses a default language without an index', () {
      expect(
        () => FakeCatalog(indexes: {'en': contractIndexEn}),
        throwsArgumentError,
      );
    });

    test('a chapter in the index without content is a broken test '
        'setup', () {
      final catalog = FakeCatalog(
        indexes: {'ru': contractIndexRu},
        contents: {'ru': const []},
      );

      return expectLater(
        catalog.chapterContent('lighthouse', 'c1', 'ru'),
        throwsStateError,
      );
    });
  });
}
