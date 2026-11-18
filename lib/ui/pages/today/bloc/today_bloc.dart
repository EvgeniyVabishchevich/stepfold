import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/pages/today/bloc/today_state.dart';

/// A screen action, a lifecycle update, or a change from storage.
sealed class TodayEvent {
  const TodayEvent();
}

/// Starts the page or changes the catalog language.
final class LoadToday extends TodayEvent {
  /// Creates the event for [language].
  const LoadToday(this.language);

  /// Language used by the catalog.
  final String language;
}

/// Updates the local day on resume or at midnight.
final class RefreshTodayDate extends TodayEvent {
  /// Creates the event.
  const RefreshTodayDate();
}

/// Reopens the progress subscription.
final class RetryTodayProgress extends TodayEvent {
  /// Creates the event.
  const RetryTodayProgress();
}

/// Reloads the catalog independently of the progress stream.
final class RetryTodayCatalog extends TodayEvent {
  /// Creates the event.
  const RetryTodayCatalog();
}

/// Spends steps on the exact goal displayed on the button.
final class SpendOnTodayGoal extends TodayEvent {
  /// Creates the event for [goal].
  const SpendOnTodayGoal(this.goal);

  /// The goal selected when the button was built.
  final Goal goal;
}

final class _ProgressUpdated extends TodayEvent {
  const _ProgressUpdated(this.version, this.progress);

  final int version;
  final Progress progress;
}

final class _ProgressReadFailed extends TodayEvent {
  const _ProgressReadFailed(this.version, this.failure, this.stack);

  final int version;
  final StorageFailure failure;
  final StackTrace stack;
}

/// Reads progress from storage and carries out a tap on the current goal.
class TodayBloc extends Bloc<TodayEvent, TodayState> {
  /// Creates the bloc. The page supplies the language via [LoadToday].
  TodayBloc({
    required ProgressRepository progress,
    required this._catalog,
    required this._openChapter,
    required this._buyMedal,
    required this._crashReporter,
  }) : _repository = progress,
       super(TodayState(day: Day.today())) {
    on<TodayEvent>(_onEvent);
  }

  final ProgressRepository _repository;
  final Catalog _catalog;
  final OpenChapter _openChapter;
  final BuyMedal _buyMedal;
  final CrashReporter _crashReporter;
  StreamSubscription<Progress>? _watch;
  Timer? _midnight;
  String? _language;
  var _watchVersion = 0;
  var _catalogVersion = 0;
  var _closing = false;
  CatalogIndex? _index;
  var _spendCommitted = false;

  Future<void> _onEvent(TodayEvent event, Emitter<TodayState> emit) async {
    if (_closing) return;
    switch (event) {
      case LoadToday(:final language):
        if (_language == language) return;
        if (_language == null) {
          _refreshDay(emit);
          add(const RetryTodayProgress());
        }
        _language = language;
        await _reloadCatalog(language, emit);
      case RefreshTodayDate():
        _refreshDay(emit);
      case RetryTodayProgress():
        await _watchProgress(emit);
      case RetryTodayCatalog():
        if (_language case final language?) {
          await _reloadCatalog(language, emit);
        }
      case SpendOnTodayGoal(:final goal):
        await _spend(goal, emit);
      case _ProgressUpdated(:final version, :final progress):
        if (version != _watchVersion) return;
        emit(
          state.copyWith(
            progress: progress,
            progressFailure: null,
            target: _target(progress),
            spendingGoal: _waitingForProgress(progress),
          ),
        );
      case _ProgressReadFailed(:final version, :final failure, :final stack):
        if (version != _watchVersion) return;
        emit(state.copyWith(progressFailure: failure));
        await _reportStorage(failure, stack, 'read progress');
    }
  }

  void _refreshDay(Emitter<TodayState> emit) {
    _midnight?.cancel();
    final now = clock.now().toLocal();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    _midnight = Timer(midnight.difference(now), () {
      if (!_closing) add(const RefreshTodayDate());
    });
    emit(state.copyWith(day: Day.fromLocal(now)));
  }

  Future<void> _watchProgress(Emitter<TodayState> emit) async {
    final version = ++_watchVersion;
    final previous = _watch;
    _watch = null;
    emit(state.copyWith(progressFailure: null));
    await previous?.cancel();
    if (_closing || version != _watchVersion) return;
    _watch = _repository.watch().listen(
      (progress) {
        if (!_closing) add(_ProgressUpdated(version, progress));
      },
      onError: (Object error, StackTrace stack) {
        if (_closing) return;
        if (error is! StorageFailure) Error.throwWithStackTrace(error, stack);
        add(_ProgressReadFailed(version, error, stack));
      },
    );
  }

  Future<void> _reloadCatalog(String language, Emitter<TodayState> emit) async {
    final version = ++_catalogVersion;
    _index = null;
    emit(
      state.copyWith(target: null, catalogFailure: null, catalogLoading: true),
    );
    try {
      final index = await _catalog.index(language);
      if (_closing || version != _catalogVersion) return;
      _index = index;
      emit(
        state.copyWith(target: _target(state.progress), catalogLoading: false),
      );
    } on CatalogFailure catch (failure) {
      if (_closing || version != _catalogVersion) return;
      emit(state.copyWith(catalogFailure: failure, catalogLoading: false));
    }
  }

  Future<void> _spend(Goal goal, Emitter<TodayState> emit) async {
    final target = state.target;
    if (state.spendingGoal != null ||
        target == null ||
        target.goal != goal ||
        target.left > 0) {
      return;
    }
    emit(
      state.copyWith(
        spendingGoal: goal,
        spendingFailure: null,
        spendingStorageFailure: null,
      ),
    );
    try {
      switch (goal) {
        case ChapterGoal(:final chapterId):
          await _openChapter(target.progression, chapterId);
        case MedalGoal(:final medal):
          await _buyMedal(target.progression, expected: medal);
      }
      if (_closing) return;
      _spendCommitted = true;
      emit(
        state.copyWith(
          openedChapter: goal is ChapterGoal ? goal : state.openedChapter,
          spendingGoal: _waitingForProgress(state.progress),
        ),
      );
    } on ProgressFailure catch (failure) {
      if (_closing) return;
      emit(state.copyWith(spendingFailure: failure, spendingGoal: null));
    } on StorageFailure catch (failure, stack) {
      if (!_closing) {
        emit(
          state.copyWith(spendingStorageFailure: failure, spendingGoal: null),
        );
      }
      await _reportStorage(failure, stack, 'spend steps');
    }
  }

  Goal? _waitingForProgress(Progress? progress) {
    final spending = state.spendingGoal;
    if (_spendCommitted && progress?.goal != spending) {
      _spendCommitted = false;
      return null;
    }
    return spending;
  }

  Future<void> _reportStorage(
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

  TodayGoal? _target(Progress? progress) {
    final goal = progress?.goal;
    if (progress == null || goal == null) return null;
    final id = switch (goal) {
      ChapterGoal(:final progressionId) ||
      MedalGoal(:final progressionId) => progressionId,
    };
    final progression = _index?.progressionById(id);
    if (progression == null) return null;
    String? chapterTitle;
    switch (goal) {
      case ChapterGoal(:final chapterId):
        if (!isChapterAvailable(progress, progression, chapterId)) return null;
        chapterTitle = progression.chapterById(chapterId)?.title;
      case MedalGoal(:final medal):
        if (medalOf(progress, progression)?.next != medal) return null;
    }
    return (
      goal: goal,
      progression: progression,
      chapterTitle: chapterTitle,
      price: priceOf(goal, progression),
      left: stepsLeft(progress, progression),
    );
  }

  @override
  Future<void> close() async {
    _closing = true;
    _midnight?.cancel();
    await _watch?.cancel();
    await super.close();
  }
}
