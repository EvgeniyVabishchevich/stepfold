// The shape of the catalog files. Only the asset catalog reads these; the
// rest of the app sees the domain models they turn into.
import 'package:json_annotation/json_annotation.dart';
import 'package:walks/domain/models/progression.dart';

part 'catalog_dto.g.dart';

/// `catalog.json`: the structure, the same for every language.
@JsonSerializable(createToJson: false)
class CatalogStructureDto {
  /// Creates the structure.
  CatalogStructureDto({
    required this.formatVersion,
    required this.defaultLanguage,
    required this.languages,
    required this.kinds,
    required this.lengthGroups,
    required this.progressions,
  });

  /// Reads the structure from decoded JSON.
  factory CatalogStructureDto.fromJson(Map<String, dynamic> json) =>
      _$CatalogStructureDtoFromJson(json);

  /// The version of this file format. Grows when an older app could not
  /// read the file any more.
  final int formatVersion;

  /// The language used when the asked one has no texts.
  final String defaultLanguage;

  /// Every language with a full set of texts.
  final List<String> languages;

  /// The ids of kinds.
  final List<String> kinds;

  /// From the shortest up; the last one has no `maxSteps`.
  final List<LengthGroupDto> lengthGroups;

  /// Every progression, hidden ones included.
  final List<ProgressionDto> progressions;
}

/// A length group in `catalog.json`.
@JsonSerializable(createToJson: false)
class LengthGroupDto {
  /// Creates a group.
  LengthGroupDto({required this.id, this.maxSteps});

  /// Reads a group from decoded JSON.
  factory LengthGroupDto.fromJson(Map<String, dynamic> json) =>
      _$LengthGroupDtoFromJson(json);

  /// The id.
  final String id;

  /// The longest route in the group, `null` for no limit.
  final int? maxSteps;
}

/// A progression in `catalog.json`.
@JsonSerializable(createToJson: false)
class ProgressionDto {
  /// Creates a progression.
  ProgressionDto({
    required this.id,
    required this.kind,
    required this.order,
    required this.chapters,
    this.hidden = false,
  });

  /// Reads a progression from decoded JSON.
  factory ProgressionDto.fromJson(Map<String, dynamic> json) =>
      _$ProgressionDtoFromJson(json);

  /// The id, never changed or reused once published.
  final String id;

  /// The id of its kind.
  final String kind;

  /// `strict` or `free`.
  final ChapterOrder order;

  /// The chapters in order.
  final List<ChapterDto> chapters;

  /// Not offered to new users any more.
  final bool hidden;
}

/// A chapter in `catalog.json`.
@JsonSerializable(createToJson: false)
class ChapterDto {
  /// Creates a chapter.
  ChapterDto({required this.id, required this.price});

  /// Reads a chapter from decoded JSON.
  factory ChapterDto.fromJson(Map<String, dynamic> json) =>
      _$ChapterDtoFromJson(json);

  /// The id inside its progression.
  final String id;

  /// The price in steps.
  final int price;
}

/// `<language>/index.json`: the short texts of one language.
@JsonSerializable(createToJson: false)
class LanguageIndexDto {
  /// Creates the texts.
  LanguageIndexDto({
    required this.kinds,
    required this.lengthGroups,
    required this.progressions,
  });

  /// Reads the texts from decoded JSON.
  factory LanguageIndexDto.fromJson(Map<String, dynamic> json) =>
      _$LanguageIndexDtoFromJson(json);

  /// Kind id → title.
  final Map<String, String> kinds;

  /// Length group id → title.
  final Map<String, String> lengthGroups;

  /// Progression id → its texts.
  final Map<String, ProgressionTextsDto> progressions;
}

/// The short texts of a progression in `<language>/index.json`.
@JsonSerializable(createToJson: false)
class ProgressionTextsDto {
  /// Creates the texts.
  ProgressionTextsDto({
    required this.title,
    required this.chapters,
    this.description = '',
  });

  /// Reads the texts from decoded JSON.
  factory ProgressionTextsDto.fromJson(Map<String, dynamic> json) =>
      _$ProgressionTextsDtoFromJson(json);

  /// The title.
  final String title;

  /// A line or two under the title.
  final String description;

  /// Chapter id → title.
  final Map<String, String> chapters;
}

/// `<language>/<progression id>.json`: the content of every chapter.
@JsonSerializable(createToJson: false)
class ProgressionContentDto {
  /// Creates the content.
  ProgressionContentDto({required this.chapters});

  /// Reads the content from decoded JSON.
  factory ProgressionContentDto.fromJson(Map<String, dynamic> json) =>
      _$ProgressionContentDtoFromJson(json);

  /// Chapter id → its blocks.
  final Map<String, List<BlockDto>> chapters;
}

/// A block of chapter content, told apart by its `type` field.
sealed class BlockDto {
  const BlockDto();

  /// Reads a block from decoded JSON.
  ///
  /// Throws an [ArgumentError] for an unknown `type`: the file is broken.
  factory BlockDto.fromJson(Map<String, dynamic> json) =>
      switch (json['type']) {
        'paragraph' => ParagraphDto.fromJson(json),
        'image' => ImageDto.fromJson(json),
        'mapPoint' => MapPointDto.fromJson(json),
        final type => throw ArgumentError.value(type, 'type', 'unknown block'),
      };
}

/// `{"type": "paragraph", "text": "…"}`
@JsonSerializable(createToJson: false)
class ParagraphDto extends BlockDto {
  /// Creates a paragraph.
  const ParagraphDto({required this.text});

  /// Reads a paragraph from decoded JSON.
  factory ParagraphDto.fromJson(Map<String, dynamic> json) =>
      _$ParagraphDtoFromJson(json);

  /// Plain text.
  final String text;
}

/// `{"type": "image", "source": "images/…", "caption": "…"}`
@JsonSerializable(createToJson: false)
class ImageDto extends BlockDto {
  /// Creates an image.
  const ImageDto({required this.source, this.caption = ''});

  /// Reads an image from decoded JSON.
  factory ImageDto.fromJson(Map<String, dynamic> json) =>
      _$ImageDtoFromJson(json);

  /// A path relative to the catalog folder, or a full URL.
  final String source;

  /// A line under the picture.
  final String caption;
}

/// `{"type": "mapPoint", "latitude": …, "longitude": …, "label": "…"}`
@JsonSerializable(createToJson: false)
class MapPointDto extends BlockDto {
  /// Creates a point.
  const MapPointDto({
    required this.latitude,
    required this.longitude,
    this.label = '',
  });

  /// Reads a point from decoded JSON.
  factory MapPointDto.fromJson(Map<String, dynamic> json) =>
      _$MapPointDtoFromJson(json);

  /// Degrees north.
  final double latitude;

  /// Degrees east.
  final double longitude;

  /// The name of the place.
  final String label;
}
