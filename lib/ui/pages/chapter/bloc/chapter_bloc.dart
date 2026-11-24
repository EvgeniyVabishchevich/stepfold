import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/pages/chapter/bloc/chapter_state.dart';

/// An event in the chapter reader.
sealed class ChapterEvent {
  const ChapterEvent();
}

/// The chapter that the reader should load.
final class LoadChapter extends ChapterEvent {
  /// Creates a request by catalog identity and language.
  const LoadChapter(this.progressionId, this.chapterId, this.language);

  /// The progression that owns the chapter.
  final String progressionId;

  /// The ID unique within the progression.
  final String chapterId;

  /// The language of the catalog content.
  final String language;
}

final class _JourneyProgressUpdated extends ChapterEvent {
  const _JourneyProgressUpdated(this.version, this.progression, this.progress);

  final int version;
  final Progression progression;
  final Progress progress;
}

final class _JourneyProgressFailed extends ChapterEvent {
  const _JourneyProgressFailed(this.version, this.error, this.stack);

  final int version;
  final Object error;
  final StackTrace stack;
}

/// Reports whether the map tile at the center of the reader has failed.
final class JourneyTilesChanged extends ChapterEvent {
  /// Creates a report for the current journey.
  const JourneyTilesChanged(this.progressionId, {required this.unavailable});

  /// The progression being shown.
  final String progressionId;

  /// Whether the tile failed to render.
  final bool unavailable;
}

/// Loads content for a chapter the user has already opened.
class ChapterBloc extends Bloc<ChapterEvent, ChapterState> {
  /// Creates the bloc.
  ChapterBloc({
    required this._catalog,
    required this._progress,
    required this._crashReporter,
  }) : super(const ChapterState()) {
    on<LoadChapter>(_load);
    on<_JourneyProgressUpdated>((event, emit) {
      if (event.version == _version) {
        emit(
          state.copyWith(journey: _journey(event.progression, event.progress)),
        );
      }
    });
    on<_JourneyProgressFailed>(_onJourneyProgressFailed);
    on<JourneyTilesChanged>((event, emit) {
      if (state.journey?.progression.id == event.progressionId) {
        emit(state.copyWith(journeyTilesUnavailable: event.unavailable));
      }
    });
  }

  final Catalog _catalog;
  final ProgressRepository _progress;
  final CrashReporter _crashReporter;
  StreamSubscription<Progress>? _watch;
  var _version = 0;
  var _closing = false;

  Future<void> _load(LoadChapter event, Emitter<ChapterState> emit) async {
    final LoadChapter(:progressionId, :chapterId, :language) = event;
    final version = ++_version;
    final previous = _watch;
    _watch = null;
    emit(const ChapterState());
    await previous?.cancel();
    if (_closing || version != _version) return;
    String? progressionTitle;
    String? chapterTitle;
    ChapterContent? content;
    Progression? journeyProgression;
    ChapterJourney? journey;
    var unavailable = false;
    var retryable = false;
    var storageFull = false;
    try {
      final progress = await _progress.watch().first;
      if (!progress.isOpened(progressionId, chapterId)) {
        unavailable = true;
      } else {
        final index = await _catalog.index(language);
        final progression = index.progressionById(progressionId);
        final chapter = progression?.chapterById(chapterId);
        if (chapter == null) {
          unavailable = true;
        } else {
          progressionTitle = progression!.title;
          chapterTitle = chapter.title;
          content = await _catalog.chapterContent(
            progressionId,
            chapterId,
            language,
          );
          journey = _journey(progression, progress);
          if (journey != null) journeyProgression = progression;
        }
      }
    } on CatalogFailure catch (failure) {
      switch (failure) {
        case CatalogUnavailable():
          retryable = true;
        case ChapterNotFound():
          unavailable = true;
      }
    } on StorageFailure catch (failure, stack) {
      retryable = true;
      switch (failure) {
        case StorageFull():
          storageFull = true;
        case StorageUnavailable(:final cause):
          await _crashReporter.recordError(
            cause,
            stack,
            reason: 'read chapter',
          );
      }
    }
    if (_closing || emit.isDone || version != _version) return;
    emit(
      ChapterState(
        loading: false,
        unavailable: unavailable,
        retryable: retryable,
        storageFull: storageFull,
        progressionTitle: progressionTitle,
        chapterTitle: chapterTitle,
        content: content,
        journey: journey,
      ),
    );
    if (journeyProgression != null) {
      final route = journeyProgression;
      _watch = _progress.watch().listen(
        (progress) {
          if (!_closing) add(_JourneyProgressUpdated(version, route, progress));
        },
        onError: (Object error, StackTrace stack) {
          if (!_closing) add(_JourneyProgressFailed(version, error, stack));
        },
      );
    }
  }

  ChapterJourney? _journey(Progression progression, Progress progress) {
    final position = journeyPosition(progression, progress);
    return position == null
        ? null
        : (progression: progression, position: position);
  }

  Future<void> _onJourneyProgressFailed(
    _JourneyProgressFailed event,
    Emitter<ChapterState> emit,
  ) async {
    if (event.version != _version) return;
    switch (event.error) {
      case StorageUnavailable(:final cause):
        await _crashReporter.recordError(
          cause,
          event.stack,
          reason: 'watch journey progress',
        );
      case StorageFull():
        break;
      default:
        addError(event.error, event.stack);
    }
  }

  @override
  Future<void> close() async {
    _closing = true;
    await _watch?.cancel();
    await super.close();
  }
}
