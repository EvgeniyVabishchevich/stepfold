import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/pages/history/bloc/history_state.dart';

/// An action in the step history.
sealed class HistoryEvent {
  const HistoryEvent();
}

/// Starts or retries the progress subscription.
final class WatchHistory extends HistoryEvent {
  /// Creates the event.
  const WatchHistory();
}

/// Loads localized titles for the week's opened chapters and medals.
final class LoadHistoryCatalog extends HistoryEvent {
  /// Creates the request for the active language.
  const LoadHistoryCatalog(this.language);

  /// The catalog language.
  final String language;
}

/// Updates the date and effective lock after a timer or app resume.
final class RefreshHistoryTime extends HistoryEvent {
  /// Creates the event.
  const RefreshHistoryTime();
}

/// Saves or removes a day's manual addition.
final class SaveHistoryEdit extends HistoryEvent {
  /// Creates the event. Confirmed edits are checked again before writing.
  const SaveHistoryEdit(this.edit, {this.confirmed = false});

  /// The selected day and replacement amount.
  final HistoryEdit edit;

  /// Whether the user accepted the large addition.
  final bool confirmed;
}

/// Dismisses a confirmation without writing.
final class CancelHistoryEdit extends HistoryEvent {
  /// Creates the event.
  const CancelHistoryEdit();
}

/// Enables the lock or starts a delayed unlock.
final class ChangeHistoryLock extends HistoryEvent {
  /// Creates the event.
  const ChangeHistoryLock({required this.locked});

  /// True to lock, false to request an unlock.
  final bool locked;
}

/// Watches stored steps and edits manual additions and the entry lock.
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  /// Creates the bloc for a progress repository.
  HistoryBloc({
    required this._progress,
    required this._catalog,
    required this._addManualSteps,
    required this._updateLock,
    required this._crashReporter,
  }) : super(HistoryState(now: clock.now())) {
    on<WatchHistory>(_watch);
    on<LoadHistoryCatalog>(_loadCatalog);
    on<RefreshHistoryTime>((_, emit) {
      emit(state.copyWith(now: clock.now()));
      _scheduleRefresh();
    });
    on<SaveHistoryEdit>(_save);
    on<CancelHistoryEdit>(
      (_, emit) => emit(state.copyWith(confirmation: null)),
    );
    on<ChangeHistoryLock>(_changeLock);
  }

  final ProgressRepository _progress;
  final Catalog _catalog;
  final AddManualSteps _addManualSteps;
  final UpdateManualEntryLock _updateLock;
  final CrashReporter _crashReporter;
  var _watching = false;
  String? _language;
  Timer? _refresh;

  Future<void> _loadCatalog(
    LoadHistoryCatalog event,
    Emitter<HistoryState> emit,
  ) async {
    final language = event.language;
    if (language == _language) return;
    _language = language;
    emit(state.copyWith(catalog: null));
    try {
      final catalog = await _catalog.index(language);
      if (!emit.isDone && language == _language) {
        emit(state.copyWith(catalog: catalog));
      }
    } on CatalogFailure {
      // History can still show the number of openings without their titles.
      if (language == _language) _language = null;
    }
  }

  Future<void> _watch(WatchHistory event, Emitter<HistoryState> emit) async {
    if (_watching) return;
    _watching = true;
    emit(state.copyWith(readFailure: null));
    try {
      await emit.onEach(
        _progress.watch(),
        onData: (progress) {
          emit(state.copyWith(progress: progress, now: clock.now()));
          _scheduleRefresh();
        },
      );
    } on StorageFailure catch (failure, stack) {
      _watching = false;
      if (emit.isDone) return;
      emit(state.copyWith(progress: null, readFailure: failure));
      await _report(failure, stack, 'read step history');
      return;
    }
    _watching = false;
  }

  Future<void> _save(SaveHistoryEdit event, Emitter<HistoryState> emit) async {
    await _write(emit, () async {
      final result = await _addManualSteps(
        event.edit.day,
        event.edit.steps,
        confirmed: event.confirmed,
      );
      return result == ManualEntryCheck.needsConfirmation ? event.edit : null;
    });
  }

  Future<void> _changeLock(
    ChangeHistoryLock event,
    Emitter<HistoryState> emit,
  ) async {
    await _write(emit, () async {
      await _updateLock(locked: event.locked);
      return null;
    });
  }

  Future<void> _write(
    Emitter<HistoryState> emit,
    Future<HistoryEdit?> Function() action,
  ) async {
    if (state.busy) return;
    emit(state.copyWith(busy: true, confirmation: null, writeFailure: null));
    try {
      final confirmation = await action();
      if (emit.isDone) return;
      emit(state.copyWith(busy: false, confirmation: confirmation));
    } on ManualEntryFailure catch (failure) {
      if (emit.isDone) return;
      emit(
        state.copyWith(busy: false, writeFailure: failure, now: clock.now()),
      );
    } on StorageFailure catch (failure, stack) {
      if (emit.isDone) return;
      emit(state.copyWith(busy: false, writeFailure: failure));
      await _report(failure, stack, 'write step history');
    }
  }

  void _scheduleRefresh() {
    _refresh?.cancel();
    final now = state.now.toLocal();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final unlockAt = state.progress?.manualEntryLock.unlockAt;
    final next = state.locked && unlockAt != null && unlockAt.isBefore(midnight)
        ? unlockAt
        : midnight;
    _refresh = Timer(next.difference(now), () {
      if (!isClosed) add(const RefreshHistoryTime());
    });
  }

  Future<void> _report(
    StorageFailure failure,
    StackTrace stack,
    String reason,
  ) {
    return switch (failure) {
      StorageFull() => Future<void>.value(),
      StorageUnavailable(:final cause) => _crashReporter.recordError(
        cause,
        stack,
        reason: reason,
      ),
    };
  }

  @override
  Future<void> close() {
    _refresh?.cancel();
    return super.close();
  }
}
