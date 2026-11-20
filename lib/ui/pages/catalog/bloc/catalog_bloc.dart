import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/pages/catalog/bloc/catalog_state.dart';

/// An action on the catalog or progression screen.
sealed class CatalogEvent {
  const CatalogEvent();
}

/// Loads the index in the current language.
final class LoadCatalog extends CatalogEvent {
  /// Creates a catalog request.
  const LoadCatalog(this.language);

  /// Language to request from the catalog.
  final String language;
}

/// Subscribes to progress or retries a failed subscription.
final class WatchCatalogProgress extends CatalogEvent {
  /// Creates the event.
  const WatchCatalogProgress();
}

/// Filters the list by progression length.
final class FilterCatalog extends CatalogEvent {
  /// Creates the event for [lengthId].
  const FilterCatalog(this.lengthId);

  /// Selected group from the catalog index.
  final String lengthId;
}

/// Makes an available chapter the active goal.
final class ChooseCatalogGoal extends CatalogEvent {
  /// Creates the event for a chapter in a progression.
  const ChooseCatalogGoal(this.goal);

  /// The chapter to save.
  final ChapterGoal goal;
}

/// Reads catalog data and keeps the selection in sync with saved progress.
class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  /// Creates the bloc for either route of the catalog tab.
  CatalogBloc({
    required this._catalog,
    required this._progress,
    required this._setGoal,
    required this._crashReporter,
  }) : super(const CatalogState()) {
    on<LoadCatalog>(_load);
    on<WatchCatalogProgress>(_watch);
    on<FilterCatalog>((event, emit) {
      if (state.index?.lengthGroups.any((g) => g.id == event.lengthId) ??
          false) {
        emit(state.copyWith(lengthId: event.lengthId));
      }
    });
    on<ChooseCatalogGoal>(_chooseGoal);
  }

  final Catalog _catalog;
  final ProgressRepository _progress;
  final SetGoal _setGoal;
  final CrashReporter _crashReporter;
  var _catalogRequest = 0;
  var _watching = false;

  Future<void> _load(LoadCatalog event, Emitter<CatalogState> emit) async {
    final request = ++_catalogRequest;
    emit(state.copyWith(index: null, catalogFailure: null));
    try {
      final index = await _catalog.index(event.language);
      if (emit.isDone || request != _catalogRequest) return;
      final groups = index.lengthGroups;
      emit(
        state.copyWith(
          index: index,
          lengthId: groups.any((group) => group.id == state.lengthId)
              ? state.lengthId
              : groups.firstOrNull?.id,
        ),
      );
    } on CatalogFailure catch (failure) {
      if (emit.isDone || request != _catalogRequest) return;
      emit(state.copyWith(catalogFailure: failure));
    }
  }

  Future<void> _watch(
    WatchCatalogProgress event,
    Emitter<CatalogState> emit,
  ) async {
    if (_watching) return;
    _watching = true;
    emit(state.copyWith(readFailure: null));
    try {
      await emit.onEach(
        _progress.watch(),
        onData: (progress) => emit(state.copyWith(progress: progress)),
      );
    } on StorageFailure catch (failure, stack) {
      _watching = false;
      if (emit.isDone) return;
      emit(state.copyWith(progress: null, readFailure: failure));
      await _report(failure, stack, 'read catalog progress');
      return;
    }
    _watching = false;
  }

  Future<void> _chooseGoal(
    ChooseCatalogGoal event,
    Emitter<CatalogState> emit,
  ) async {
    final goal = event.goal;
    final progression = state.visibleProgression(goal.progressionId);
    if (progression == null || state.saving || state.progress?.goal == goal) {
      return;
    }
    emit(
      state.copyWith(
        saving: true,
        saveFailure: null,
        chapterUnavailable: false,
      ),
    );
    try {
      await _setGoal(goal, progression);
      if (emit.isDone) return;
      emit(state.copyWith(saving: false));
    } on ChapterUnavailable {
      if (emit.isDone) return;
      emit(state.copyWith(saving: false, chapterUnavailable: true));
    } on StorageFailure catch (failure, stack) {
      if (emit.isDone) return;
      emit(state.copyWith(saving: false, saveFailure: failure));
      await _report(failure, stack, 'save catalog goal');
    }
  }

  Future<void> _report(
    StorageFailure failure,
    StackTrace stack,
    String reason,
  ) async {
    switch (failure) {
      case StorageFull():
        break;
      case StorageUnavailable(:final cause):
        await _crashReporter.recordError(cause, stack, reason: reason);
    }
  }
}
