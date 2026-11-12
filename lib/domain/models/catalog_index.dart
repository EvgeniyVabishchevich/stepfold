import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walks/domain/models/progression.dart';

part 'catalog_index.freezed.dart';

/// A kind of progressions: story, journey, collection, picture…
///
/// Kinds are data: a new kind comes with the catalog, not with the code.
@freezed
abstract class ProgressionKind with _$ProgressionKind {
  /// Creates a kind.
  const factory ProgressionKind({required String id, required String title}) =
      _ProgressionKind;
}

/// A group of progressions by length, for the catalog filter: short, medium,
/// long…
///
/// A progression belongs to the first group whose [maxSteps] its route price
/// fits, see `lengthOf`. A group without [maxSteps] takes everything longer.
@freezed
abstract class LengthGroup with _$LengthGroup {
  /// Creates a group.
  const factory LengthGroup({
    required String id,
    required String title,
    int? maxSteps,
  }) = _LengthGroup;
}

/// The light part of the catalog in one language: what lists and filters
/// show, without the content of chapters.
@freezed
abstract class CatalogIndex with _$CatalogIndex {
  /// Creates an index.
  ///
  /// [lengthGroups] go from the shortest up; the last one has no
  /// `maxSteps`.
  const factory CatalogIndex({
    required List<ProgressionKind> kinds,
    required List<LengthGroup> lengthGroups,
    required List<Progression> progressions,
  }) = _CatalogIndex;

  const CatalogIndex._();

  /// The progression with [id], or `null` if the catalog has none.
  Progression? progressionById(String id) {
    for (final progression in progressions) {
      if (progression.id == id) return progression;
    }
    return null;
  }
}
