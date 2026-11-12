// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CatalogStructureDto _$CatalogStructureDtoFromJson(Map<String, dynamic> json) =>
    CatalogStructureDto(
      formatVersion: (json['formatVersion'] as num).toInt(),
      defaultLanguage: json['defaultLanguage'] as String,
      languages: (json['languages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      kinds: (json['kinds'] as List<dynamic>).map((e) => e as String).toList(),
      lengthGroups: (json['lengthGroups'] as List<dynamic>)
          .map((e) => LengthGroupDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      progressions: (json['progressions'] as List<dynamic>)
          .map((e) => ProgressionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

LengthGroupDto _$LengthGroupDtoFromJson(Map<String, dynamic> json) =>
    LengthGroupDto(
      id: json['id'] as String,
      maxSteps: (json['maxSteps'] as num?)?.toInt(),
    );

ProgressionDto _$ProgressionDtoFromJson(Map<String, dynamic> json) =>
    ProgressionDto(
      id: json['id'] as String,
      kind: json['kind'] as String,
      order: $enumDecode(_$ChapterOrderEnumMap, json['order']),
      chapters: (json['chapters'] as List<dynamic>)
          .map((e) => ChapterDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      hidden: json['hidden'] as bool? ?? false,
    );

const _$ChapterOrderEnumMap = {
  ChapterOrder.strict: 'strict',
  ChapterOrder.free: 'free',
};

ChapterDto _$ChapterDtoFromJson(Map<String, dynamic> json) =>
    ChapterDto(id: json['id'] as String, price: (json['price'] as num).toInt());

LanguageIndexDto _$LanguageIndexDtoFromJson(Map<String, dynamic> json) =>
    LanguageIndexDto(
      kinds: Map<String, String>.from(json['kinds'] as Map),
      lengthGroups: Map<String, String>.from(json['lengthGroups'] as Map),
      progressions: (json['progressions'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          ProgressionTextsDto.fromJson(e as Map<String, dynamic>),
        ),
      ),
    );

ProgressionTextsDto _$ProgressionTextsDtoFromJson(Map<String, dynamic> json) =>
    ProgressionTextsDto(
      title: json['title'] as String,
      chapters: Map<String, String>.from(json['chapters'] as Map),
      description: json['description'] as String? ?? '',
    );

ProgressionContentDto _$ProgressionContentDtoFromJson(
  Map<String, dynamic> json,
) => ProgressionContentDto(
  chapters: (json['chapters'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => BlockDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
);

ParagraphDto _$ParagraphDtoFromJson(Map<String, dynamic> json) =>
    ParagraphDto(text: json['text'] as String);

ImageDto _$ImageDtoFromJson(Map<String, dynamic> json) => ImageDto(
  source: json['source'] as String,
  caption: json['caption'] as String? ?? '',
);

MapPointDto _$MapPointDtoFromJson(Map<String, dynamic> json) => MapPointDto(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  label: json['label'] as String? ?? '',
);
