// Checks the catalog files shipped in `assets/catalog/`, not the code that
// reads them: a broken file fails here, before release.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/catalog/asset_catalog.dart';
import 'package:walks/domain/models/chapter_content.dart';

/// Every progression and chapter ever published, as `progression` and
/// `progression/chapter`.
const _publishedIdsFile = 'test/data/repositories/catalog/published_ids.json';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AssetCatalog catalog;
  late List<String> languages;

  setUp(() async {
    catalog = AssetCatalog(rootBundle);
    final structure =
        jsonDecode(await rootBundle.loadString('assets/catalog/catalog.json'))
            as Map<String, dynamic>;
    languages = (structure['languages'] as List).cast<String>();
  });

  test('every language reads in full: index, every chapter, every '
      'picture', () async {
    for (final language in languages) {
      final index = await catalog.index(language);
      for (final progression in index.progressions) {
        for (final chapter in progression.chapters) {
          final content = await catalog.chapterContent(
            progression.id,
            chapter.id,
            language,
          );
          for (final block in content.blocks.whereType<ImageBlock>()) {
            if (block.source.scheme != 'asset') continue;
            await expectLater(
              rootBundle.load(block.source.path),
              completes,
              reason:
                  'picture ${block.source} of ${progression.id}/'
                  '${chapter.id}',
            );
          }
        }
      }
    }
  });

  test('every language has the same titles filled in: no empty '
      'text', () async {
    for (final language in languages) {
      final index = await catalog.index(language);
      for (final p in index.progressions) {
        expect(p.title, isNotEmpty, reason: '${p.id} in $language');
        for (final c in p.chapters) {
          expect(c.title, isNotEmpty, reason: '${p.id}/${c.id} in $language');
        }
      }
    }
  });

  // Progress is tied to these ids. Removing one would lose what users have
  // opened; hide the progression with `hidden` instead.
  test('no published id is removed', () async {
    final published = await _publishedIds();

    expect(
      published.difference(await _currentIds(catalog)),
      isEmpty,
      reason: 'published ids are gone from the catalog',
    );
  });

  test('every id in the catalog is recorded as published', () async {
    final published = await _publishedIds();

    expect(
      (await _currentIds(catalog)).difference(published),
      isEmpty,
      reason: 'add new ids to $_publishedIdsFile',
    );
  });
}

Future<Set<String>> _publishedIds() async =>
    (jsonDecode(await File(_publishedIdsFile).readAsString()) as List)
        .cast<String>()
        .toSet();

Future<Set<String>> _currentIds(AssetCatalog catalog) async {
  final index = await catalog.index('ru');
  return {
    for (final p in index.progressions) ...[
      p.id,
      for (final c in p.chapters) '${p.id}/${c.id}',
    ],
  };
}
