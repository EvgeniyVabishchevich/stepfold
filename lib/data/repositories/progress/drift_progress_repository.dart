import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:walks/data/repositories/progress/progress_database.dart';
import 'package:walks/data/repositories/progress/storage_errors.dart';
import 'package:walks/domain/domain.dart';

/// A [ProgressRepository] in a SQLite database, through drift.
class DriftProgressRepository implements ProgressRepository {
  /// Creates a repository on the given database.
  DriftProgressRepository(this._db);

  /// Opens the database file of the app. Queries run in a background
  /// isolate.
  factory DriftProgressRepository.onDevice() => DriftProgressRepository(
    ProgressDatabase(driftDatabase(name: 'progress')),
  );

  /// Opens a database in memory, created on [installDay]: for tests.
  factory DriftProgressRepository.memory({
    Day? installDay,
    List<DayCount> initialDays = const [],
  }) => DriftProgressRepository(
    ProgressDatabase(
      NativeDatabase.memory(),
      installDay: installDay == null ? null : () => installDay,
      initialDays: initialDays,
    ),
  );

  final ProgressDatabase _db;

  /// Closes the database.
  Future<void> close() => _db.close();

  @override
  Stream<Progress> watch() => _db
      // Emits on listen and after every change of these tables; the rows of
      // `SELECT 1` are only the signal.
      .customSelect(
        'SELECT 1',
        readsFrom: {
          _db.progressState,
          _db.dayStepsTable,
          _db.openedChapters,
          _db.boughtMedals,
        },
      )
      .watch()
      .asyncMap((_) => _db.transaction(_read))
      .transform(
        StreamTransformer.fromHandlers(
          handleError: (error, stackTrace, sink) =>
              sink.addError(translateStorageError(error), stackTrace),
        ),
      );

  @override
  Future<void> saveAutoSteps(
    Day day,
    int steps, {
    AutoStepOrigin? origin,
  }) async {
    await _saveDay(
      day,
      steps,
      insert: DayStepsTableCompanion.insert(
        day: Value(day),
        auto: Value(steps),
        autoOrigin: Value(origin),
      ),
      update: DayStepsTableCompanion(
        auto: Value(steps),
        autoOrigin: Value(origin),
      ),
      accepts: (previous) => previous.acceptsAutoTotal(steps, origin),
    );
  }

  @override
  Future<bool> saveManualSteps(
    Day day,
    int steps, {
    bool Function(Day installDay, ManualEntryLock lock)? allow,
  }) => _saveDay(
    day,
    steps,
    insert: DayStepsTableCompanion.insert(
      day: Value(day),
      manual: Value(steps),
    ),
    update: DayStepsTableCompanion(manual: Value(steps)),
    allow: allow,
  );

  @override
  Future<bool> increaseManualSteps(Day day, int steps) => _saveDay(
    day,
    steps,
    insert: DayStepsTableCompanion.insert(
      day: Value(day),
      manual: Value(steps),
    ),
    update: DayStepsTableCompanion.custom(
      manual:
          ifNull(_db.dayStepsTable.manual, const Variable(0)) + Variable(steps),
    ),
  );

  @override
  Future<void> updateManualEntryLock(
    ManualEntryLock Function(ManualEntryLock current) update,
  ) => guardStorage(
    () => _db.transaction(() async {
      final current = _manualEntryLockOf(
        await _db.select(_db.progressState).getSingle(),
      );
      final next = update(current);
      if (next == current) return;
      await _db
          .update(_db.progressState)
          .write(
            ProgressStateCompanion(
              manualEntryLocked: Value(next.locked),
              manualEntryUnlockAt: Value(next.unlockAt?.toUtc()),
            ),
          );
    }),
  );

  @override
  Future<void> addSpending(
    ({Spending spending, Goal? goalAfter}) Function(Progress current) decide,
  ) => guardStorage(
    () => _db.transaction(() async {
      final (:spending, :goalAfter) = decide(await _read());
      switch (spending) {
        case ChapterOpened():
          await _db
              .into(_db.openedChapters)
              .insert(
                OpenedChaptersCompanion.insert(
                  progressionId: spending.progressionId,
                  chapterId: spending.chapterId,
                  price: spending.price,
                  at: spending.at,
                ),
              );
        case MedalBought():
          await _db
              .into(_db.boughtMedals)
              .insert(
                BoughtMedalsCompanion.insert(
                  progressionId: spending.progressionId,
                  medal: spending.medal,
                  price: spending.price,
                  at: spending.at,
                ),
              );
      }
      await _writeGoal(goalAfter);
    }),
  );

  @override
  Future<void> saveGoal(
    Goal? goal, {
    void Function(Progress current)? validate,
  }) => guardStorage(() {
    if (validate == null) return _writeGoal(goal);
    return _db.transaction(() async {
      validate(await _read());
      await _writeGoal(goal);
    });
  });

  Future<bool> _saveDay(
    Day day,
    int steps, {
    required DayStepsTableCompanion insert,
    required Insertable<DayRow> update,
    bool Function(DaySteps previous)? accepts,
    bool Function(Day installDay, ManualEntryLock lock)? allow,
  }) => guardStorage(
    () => _db.transaction(() async {
      final state = await _db.select(_db.progressState).getSingle();
      if (allow?.call(state.installDay, _manualEntryLockOf(state)) == false) {
        return false;
      }
      if (steps < 0) throw ArgumentError.value(steps, 'steps', 'is negative');
      if (day.isBefore(state.installDay)) return false;
      if (accepts != null) {
        final previous = await (_db.select(
          _db.dayStepsTable,
        )..where((row) => row.day.equalsValue(day))).getSingleOrNull();
        if (previous != null && !accepts(_stepsOfRow(previous))) return false;
      }
      await _db
          .into(_db.dayStepsTable)
          .insert(insert, onConflict: DoUpdate((_) => update));
      return true;
    }),
  );

  Future<void> _writeGoal(Goal? goal) =>
      _db.update(_db.progressState).write(switch (goal) {
        null => const ProgressStateCompanion(
          goalProgressionId: Value(null),
          goalChapterId: Value(null),
          goalMedal: Value(null),
        ),
        ChapterGoal(:final progressionId, :final chapterId) =>
          ProgressStateCompanion(
            goalProgressionId: Value(progressionId),
            goalChapterId: Value(chapterId),
            goalMedal: const Value(null),
          ),
        MedalGoal(:final progressionId, :final medal) => ProgressStateCompanion(
          goalProgressionId: Value(progressionId),
          goalChapterId: const Value(null),
          goalMedal: Value(medal),
        ),
      });

  // Called inside a transaction so the parts come from the same moment.
  Future<Progress> _read() async {
    final state = await _db.select(_db.progressState).getSingle();
    final days = await _db.select(_db.dayStepsTable).get();
    final chapters = await _db.select(_db.openedChapters).get();
    final medals = await _db.select(_db.boughtMedals).get();
    final spendings = <Spending>[
      for (final c in chapters)
        Spending.chapter(
          progressionId: c.progressionId,
          chapterId: c.chapterId,
          price: c.price,
          at: c.at.toUtc(),
        ),
      for (final m in medals)
        Spending.medal(
          progressionId: m.progressionId,
          medal: m.medal,
          price: m.price,
          at: m.at.toUtc(),
        ),
    ]..sort((a, b) => a.at.compareTo(b.at));
    return Progress(
      installDay: state.installDay,
      days: {for (final day in days) day.day: _stepsOfRow(day)},
      spendings: spendings,
      goal: _goalOf(state),
      manualEntryLock: _manualEntryLockOf(state),
    );
  }

  static DaySteps _stepsOfRow(DayRow row) => DaySteps(
    day: row.day,
    auto: row.auto,
    manual: row.manual,
    autoOrigin: row.autoOrigin,
  );

  static Goal? _goalOf(StateRow state) {
    final progressionId = state.goalProgressionId;
    if (progressionId == null) return null;
    final chapterId = state.goalChapterId;
    if (chapterId != null) {
      return Goal.chapter(progressionId: progressionId, chapterId: chapterId);
    }
    return Goal.medal(progressionId: progressionId, medal: state.goalMedal!);
  }

  static ManualEntryLock _manualEntryLockOf(StateRow state) => ManualEntryLock(
    locked: state.manualEntryLocked,
    unlockAt: state.manualEntryUnlockAt?.toUtc(),
  );
}
