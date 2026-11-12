import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:walks/data/repositories/catalog/catalog_dto.dart';
import 'package:walks/data/repositories/catalog/catalog_format_error.dart';
import 'package:walks/domain/failures/catalog_failure.dart';
import 'package:walks/domain/models/catalog_index.dart';
import 'package:walks/domain/models/chapter_content.dart';
import 'package:walks/domain/models/progression.dart';
import 'package:walks/domain/repositories/catalog.dart';

/// The [Catalog] built into the app, read from JSON files in [root].
///
/// Files:
/// - `catalog.json` — ids, kinds, length groups, order and prices, one for
///   every language;
/// - `<language>/index.json` — titles of kinds, groups, progressions and
///   chapters;
/// - `<language>/<progression id>.json` — the content of its chapters.
///
/// The structure and the index of each language are read once and kept in
/// memory; chapter content is read on every call. A broken file throws a
/// [CatalogFormatError]: it is a bug, never a `CatalogFailure`.
class AssetCatalog implements Catalog {
  /// Creates a catalog that reads `bundle` under [root].
  AssetCatalog(this._bundle, {this.root = 'assets/catalog'});

  final AssetBundle _bundle;

  /// The folder of the catalog in the bundle.
  final String root;

  Future<CatalogStructureDto>? _structure;
  final Map<String, Future<CatalogIndex>> _indexes = {};

  @override
  Future<CatalogIndex> index(String language) async {
    final structure = await _readStructure();
    final chosen = _languageFor(structure, language);
    return await (_indexes[chosen] ??= _readIndex(structure, chosen));
  }

  @override
  Future<ChapterContent> chapterContent(
    String progressionId,
    String chapterId,
    String language,
  ) async {
    final structure = await _readStructure();
    final progression = structure.progressions
        .where((p) => p.id == progressionId)
        .firstOrNull;
    if (progression == null ||
        !progression.chapters.any((c) => c.id == chapterId)) {
      throw ChapterNotFound(progressionId, chapterId);
    }

    final path =
        '$root/${_languageFor(structure, language)}/$progressionId.json';
    final content = ProgressionContentDto.fromJson(await _readJson(path));
    final blocks = content.chapters[chapterId];
    if (blocks == null) {
      throw CatalogFormatError(path, 'no content for chapter $chapterId');
    }
    return ChapterContent(
      progressionId: progressionId,
      chapterId: chapterId,
      blocks: List.unmodifiable(blocks.map(_toBlock)),
    );
  }

  Future<CatalogStructureDto> _readStructure() => _structure ??= () async {
    final path = '$root/catalog.json';
    final structure = CatalogStructureDto.fromJson(await _readJson(path));
    _checkStructure(path, structure);
    return structure;
  }();

  String _languageFor(CatalogStructureDto structure, String language) =>
      structure.languages.contains(language)
      ? language
      : structure.defaultLanguage;

  Future<CatalogIndex> _readIndex(
    CatalogStructureDto structure,
    String language,
  ) async {
    final path = '$root/$language/index.json';
    final texts = LanguageIndexDto.fromJson(await _readJson(path));

    String textOf(Map<String, String> texts, String id, String what) =>
        texts[id] ?? (throw CatalogFormatError(path, 'no title for $what $id'));

    return CatalogIndex(
      kinds: List.unmodifiable([
        for (final id in structure.kinds)
          ProgressionKind(id: id, title: textOf(texts.kinds, id, 'kind')),
      ]),
      lengthGroups: List.unmodifiable([
        for (final group in structure.lengthGroups)
          LengthGroup(
            id: group.id,
            title: textOf(texts.lengthGroups, group.id, 'length group'),
            maxSteps: group.maxSteps,
          ),
      ]),
      progressions: List.unmodifiable([
        for (final p in structure.progressions)
          _toProgression(
            p,
            texts.progressions[p.id] ??
                (throw CatalogFormatError(path, 'no texts for ${p.id}')),
            path,
          ),
      ]),
    );
  }

  Progression _toProgression(
    ProgressionDto dto,
    ProgressionTextsDto texts,
    String path,
  ) => Progression(
    id: dto.id,
    kind: dto.kind,
    order: dto.order,
    title: texts.title,
    description: texts.description,
    hidden: dto.hidden,
    chapters: List.unmodifiable([
      for (final c in dto.chapters)
        Chapter(
          id: c.id,
          price: c.price,
          title:
              texts.chapters[c.id] ??
              (throw CatalogFormatError(
                path,
                'no title for ${dto.id}/${c.id}',
              )),
        ),
    ]),
  );

  ContentBlock _toBlock(BlockDto dto) => switch (dto) {
    ParagraphDto(:final text) => ContentBlock.paragraph(text: text),
    ImageDto(:final source, :final caption) => ContentBlock.image(
      source: _resolve(source),
      caption: caption,
    ),
    MapPointDto(:final latitude, :final longitude, :final label) =>
      ContentBlock.mapPoint(
        latitude: latitude,
        longitude: longitude,
        label: label,
      ),
  };

  /// A path relative to the catalog becomes `asset:<root>/<path>`; a full
  /// URL stays as it is.
  Uri _resolve(String source) {
    final uri = Uri.parse(source);
    return uri.hasScheme ? uri : Uri(scheme: 'asset', path: '$root/$source');
  }

  Future<Map<String, dynamic>> _readJson(String path) async {
    final text = await _bundle.loadString(path);
    try {
      return jsonDecode(text) as Map<String, dynamic>;
    } on FormatException catch (e) {
      throw CatalogFormatError(path, 'not JSON: ${e.message}');
    }
  }

  /// Checks what the DTOs cannot: ids are unique and point at each other,
  /// and the length groups cover every price.
  static void _checkStructure(String path, CatalogStructureDto structure) {
    Never fail(String message) => throw CatalogFormatError(path, message);

    if (structure.formatVersion != 1) {
      fail('format version ${structure.formatVersion}, expected 1');
    }
    if (!structure.languages.contains(structure.defaultLanguage)) {
      fail('default language ${structure.defaultLanguage} is not in languages');
    }
    _checkUnique(path, 'kind', structure.kinds);
    _checkUnique(path, 'length group', [
      for (final g in structure.lengthGroups) g.id,
    ]);
    _checkUnique(path, 'progression', [
      for (final p in structure.progressions) p.id,
    ]);

    final groups = structure.lengthGroups;
    if (groups.isEmpty || groups.last.maxSteps != null) {
      fail('the last length group must have no maxSteps');
    }
    var previous = 0;
    for (final group in groups.take(groups.length - 1)) {
      final max = group.maxSteps;
      if (max == null) fail('only the last length group has no maxSteps');
      if (max <= previous) fail('length groups must go from the shortest up');
      previous = max;
    }

    for (final p in structure.progressions) {
      if (!structure.kinds.contains(p.kind)) {
        fail('progression ${p.id} has unknown kind ${p.kind}');
      }
      if (p.chapters.isEmpty) fail('progression ${p.id} has no chapters');
      _checkUnique(path, 'chapter of ${p.id}', [
        for (final c in p.chapters) c.id,
      ]);
      for (final c in p.chapters) {
        if (c.price <= 0) fail('chapter ${p.id}/${c.id} has price ${c.price}');
      }
    }
  }

  static void _checkUnique(String path, String what, List<String> ids) {
    final seen = <String>{};
    for (final id in ids) {
      if (!seen.add(id)) throw CatalogFormatError(path, 'duplicate $what $id');
    }
  }
}
