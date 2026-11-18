import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/pages/chapter/bloc/chapter_state.dart';

/// The chapter that the reader should load.
final class LoadChapter {
  /// Creates a request by catalog identity and language.
  const LoadChapter(this.progressionId, this.chapterId, this.language);

  /// The progression that owns the chapter.
  final String progressionId;

  /// The ID unique within the progression.
  final String chapterId;

  /// The language of the catalog content.
  final String language;
}

/// Loads content for a chapter the user has already opened.
class ChapterBloc extends Bloc<LoadChapter, ChapterState> {
  /// Creates the bloc.
  ChapterBloc({
    required this._catalog,
    required this._progress,
    required this._crashReporter,
  }) : super(const ChapterState()) {
    on<LoadChapter>(_load);
  }

  final Catalog _catalog;
  final ProgressRepository _progress;
  final CrashReporter _crashReporter;
  var _version = 0;

  Future<void> _load(LoadChapter event, Emitter<ChapterState> emit) async {
    final LoadChapter(:progressionId, :chapterId, :language) = event;
    final version = ++_version;
    emit(const ChapterState());
    String? progressionTitle;
    String? chapterTitle;
    ChapterContent? content;
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
    if (emit.isDone || version != _version) return;
    emit(
      ChapterState(
        loading: false,
        unavailable: unavailable,
        retryable: retryable,
        storageFull: storageFull,
        progressionTitle: progressionTitle,
        chapterTitle: chapterTitle,
        content: content,
      ),
    );
  }
}
