import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/catalog/asset_catalog.dart';
import 'package:walks/data/repositories/catalog/catalog_format_error.dart';
import 'package:walks/domain/models/chapter_content.dart';

import '../../../contracts/catalog_contract.dart';
import 'map_asset_bundle.dart';

const _root = 'assets/catalog';

/// The contract catalog as files. Each test may change a copy.
Map<String, Object> _structure() => {
  'formatVersion': 1,
  'defaultLanguage': 'ru',
  'languages': ['ru', 'en'],
  'kinds': ['story'],
  'lengthGroups': [
    {'id': 'short', 'maxSteps': 10000},
    {'id': 'long'},
  ],
  'progressions': [
    {
      'id': 'lighthouse',
      'kind': 'story',
      'order': 'strict',
      'chapters': [
        {'id': 'c1', 'price': 1000},
        {'id': 'c2', 'price': 5000},
      ],
    },
    {
      'id': 'old',
      'kind': 'story',
      'order': 'free',
      'hidden': true,
      'chapters': [
        {'id': 'o1', 'price': 2000},
      ],
    },
  ],
};

Map<String, Object> _indexRu() => {
  'kinds': {'story': 'История'},
  'lengthGroups': {'short': 'Короткие', 'long': 'Длинные'},
  'progressions': {
    'lighthouse': {
      'title': 'Маяк',
      'description': 'Ночь на острове',
      'chapters': {'c1': 'Остров', 'c2': 'Шторм'},
    },
    'old': {
      'title': 'Старое',
      'chapters': {'o1': 'Единственная'},
    },
  },
};

const Map<String, Object> _indexEn = {
  'kinds': {'story': 'Story'},
  'lengthGroups': {'short': 'Short', 'long': 'Long'},
  'progressions': {
    'lighthouse': {
      'title': 'Lighthouse',
      'description': 'A night on an island',
      'chapters': {'c1': 'Island', 'c2': 'Storm'},
    },
    'old': {
      'title': 'Old',
      'chapters': {'o1': 'The only one'},
    },
  },
};

Map<String, Object> _lighthouseRu() => {
  'chapters': {
    'c1': [
      {'type': 'paragraph', 'text': 'Остров в тумане.'},
      {'type': 'image', 'source': 'images/island.png', 'caption': 'Остров'},
    ],
    'c2': [
      {'type': 'mapPoint', 'latitude': 60, 'longitude': 30.5, 'label': 'Мыс'},
    ],
  },
};

const Map<String, Object> _lighthouseEn = {
  'chapters': {
    'c1': [
      {'type': 'paragraph', 'text': 'An island in fog.'},
      {'type': 'image', 'source': 'images/island.png', 'caption': 'Island'},
    ],
    'c2': [
      {'type': 'mapPoint', 'latitude': 60, 'longitude': 30.5, 'label': 'Cape'},
    ],
  },
};

Map<String, String> _files({
  Map<String, Object>? structure,
  Map<String, Object>? indexRu,
  Map<String, Object>? lighthouseRu,
}) => {
  '$_root/catalog.json': jsonEncode(structure ?? _structure()),
  '$_root/ru/index.json': jsonEncode(indexRu ?? _indexRu()),
  '$_root/en/index.json': jsonEncode(_indexEn),
  '$_root/ru/lighthouse.json': jsonEncode(lighthouseRu ?? _lighthouseRu()),
  '$_root/en/lighthouse.json': jsonEncode(_lighthouseEn),
  '$_root/ru/old.json': jsonEncode({
    'chapters': {
      'o1': [
        {'type': 'paragraph', 'text': 'Старая глава.'},
      ],
    },
  }),
  '$_root/en/old.json': jsonEncode({
    'chapters': {
      'o1': [
        {'type': 'paragraph', 'text': 'An old chapter.'},
      ],
    },
  }),
};

AssetCatalog _catalog(Map<String, String> files) =>
    AssetCatalog(MapAssetBundle(files));

Matcher _formatError(String message) => throwsA(
  isA<CatalogFormatError>().having(
    (e) => e.message,
    'message',
    contains(message),
  ),
);

void main() {
  catalogContract(() => _catalog(_files()));

  group('AssetCatalog', () {
    test('reads the structure and each index once, chapter content every '
        'time', () async {
      final bundle = MapAssetBundle(_files());
      final catalog = AssetCatalog(bundle);

      await catalog.index('ru');
      await catalog.index('ru');
      await catalog.index('de');
      await catalog.chapterContent('lighthouse', 'c1', 'ru');
      await catalog.chapterContent('lighthouse', 'c2', 'ru');

      expect(bundle.reads, {
        '$_root/catalog.json': 1,
        '$_root/ru/index.json': 1,
        '$_root/ru/lighthouse.json': 2,
      });
    });

    test('keeps a full URL of an image as it is', () async {
      final lighthouse = _lighthouseRu();
      (lighthouse['chapters']! as Map)['c1'] = [
        {'type': 'image', 'source': 'https://example.com/a.png'},
      ];
      final catalog = _catalog(_files(lighthouseRu: lighthouse));

      final content = await catalog.chapterContent('lighthouse', 'c1', 'ru');

      expect(
        content.blocks.single,
        ContentBlock.image(source: Uri.parse('https://example.com/a.png')),
      );
    });

    group('a broken file throws CatalogFormatError', () {
      Future<void> expectBrokenIndex(
        Map<String, String> files,
        String message,
      ) => expectLater(_catalog(files).index('ru'), _formatError(message));

      test('not JSON', () {
        final files = _files()..['$_root/catalog.json'] = '{"kinds": [';

        return expectBrokenIndex(files, 'not JSON');
      });

      test('an unknown format version', () {
        return expectBrokenIndex(
          _files(structure: _structure()..['formatVersion'] = 2),
          'format version 2',
        );
      });

      test('a default language without texts', () {
        return expectBrokenIndex(
          _files(structure: _structure()..['defaultLanguage'] = 'de'),
          'default language de',
        );
      });

      test('a duplicate progression id', () {
        final structure = _structure();
        final progressions = structure['progressions']! as List;
        progressions.add(progressions.first);

        return expectBrokenIndex(
          _files(structure: structure),
          'duplicate progression lighthouse',
        );
      });

      test('a duplicate chapter id inside a progression', () {
        final structure = _structure();
        final first = (structure['progressions']! as List).first as Map;
        (first['chapters'] as List).add({'id': 'c1', 'price': 1});

        return expectBrokenIndex(
          _files(structure: structure),
          'duplicate chapter of lighthouse c1',
        );
      });

      test('a progression of an unknown kind', () {
        final structure = _structure();
        ((structure['progressions']! as List).first as Map)['kind'] = 'opera';

        return expectBrokenIndex(
          _files(structure: structure),
          'unknown kind opera',
        );
      });

      test('a chapter that costs nothing', () {
        final structure = _structure();
        final first = (structure['progressions']! as List).first as Map;
        ((first['chapters'] as List).first as Map)['price'] = 0;

        return expectBrokenIndex(
          _files(structure: structure),
          'lighthouse/c1 has price 0',
        );
      });

      test('a last length group with a limit', () {
        return expectBrokenIndex(
          _files(
            structure: _structure()
              ..['lengthGroups'] = [
                {'id': 'short', 'maxSteps': 10000},
              ],
          ),
          'last length group',
        );
      });

      test('length groups out of order', () {
        return expectBrokenIndex(
          _files(
            structure: _structure()
              ..['lengthGroups'] = [
                {'id': 'medium', 'maxSteps': 80000},
                {'id': 'short', 'maxSteps': 10000},
                {'id': 'long'},
              ],
          ),
          'shortest up',
        );
      });

      test('a missing title of a chapter', () {
        final index = _indexRu();
        final progressions = index['progressions']! as Map;
        ((progressions['lighthouse'] as Map)['chapters'] as Map).remove('c2');

        return expectBrokenIndex(
          _files(indexRu: index),
          'no title for lighthouse/c2',
        );
      });

      test('a missing texts of a progression', () {
        final index = _indexRu();
        (index['progressions']! as Map).remove('old');

        return expectBrokenIndex(_files(indexRu: index), 'no texts for old');
      });

      test('a chapter without content', () {
        final lighthouse = _lighthouseRu();
        (lighthouse['chapters']! as Map).remove('c2');

        return expectLater(
          _catalog(
            _files(lighthouseRu: lighthouse),
          ).chapterContent('lighthouse', 'c2', 'ru'),
          _formatError('no content for chapter c2'),
        );
      });
    });

    test('an unknown block type is a bug too', () {
      final lighthouse = _lighthouseRu();
      (lighthouse['chapters']! as Map)['c1'] = [
        {'type': 'video', 'source': 'a.mp4'},
      ];

      return expectLater(
        _catalog(
          _files(lighthouseRu: lighthouse),
        ).chapterContent('lighthouse', 'c1', 'ru'),
        throwsArgumentError,
      );
    });
  });
}
