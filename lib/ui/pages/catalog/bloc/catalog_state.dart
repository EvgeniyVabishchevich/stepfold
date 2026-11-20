import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walks/domain/domain.dart';

part 'catalog_state.freezed.dart';

/// Data shared by the catalog list and the progression screen.
@freezed
abstract class CatalogState with _$CatalogState {
  /// Creates the state of a catalog screen.
  const factory CatalogState({
    CatalogIndex? index,
    Progress? progress,
    String? lengthId,
    CatalogFailure? catalogFailure,
    StorageFailure? readFailure,
    StorageFailure? saveFailure,
    @Default(false) bool chapterUnavailable,
    @Default(false) bool saving,
  }) = _CatalogState;

  const CatalogState._();

  /// Progressions available to this user before filtering by length.
  Iterable<Progression> get visibleProgressions {
    final progress = this.progress;
    final index = this.index;
    if (progress == null || index == null) return const [];
    return index.progressions.where(
      (progression) =>
          !progression.hidden ||
          progress.goal?.progressionId == progression.id ||
          progression.chapters.any(
            (chapter) => progress.isOpened(progression.id, chapter.id),
          ),
    );
  }

  /// A progression that can be visited, including through a direct link.
  Progression? visibleProgression(String id) =>
      visibleProgressions.where((item) => item.id == id).firstOrNull;
}
