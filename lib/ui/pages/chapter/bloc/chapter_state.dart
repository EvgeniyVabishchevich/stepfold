import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walks/domain/models/models.dart';

part 'chapter_state.freezed.dart';

/// The content and status of the reader.
@freezed
abstract class ChapterState with _$ChapterState {
  /// Creates the reader state, initially loading.
  const factory ChapterState({
    @Default(true) bool loading,
    @Default(false) bool unavailable,
    @Default(false) bool retryable,
    @Default(false) bool storageFull,
    String? progressionTitle,
    String? chapterTitle,
    ChapterContent? content,
  }) = _ChapterState;
}
