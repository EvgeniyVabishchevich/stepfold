import 'package:drift/drift.dart';
import 'package:walks/domain/models/models.dart';

part 'progress_database.g.dart';

/// Stores a [Day] as its number of days since 1970-01-01.
class DayConverter extends TypeConverter<Day, int> {
  /// Creates the converter.
  const DayConverter();

  @override
  Day fromSql(int fromDb) => Day.fromNumber(fromDb);

  @override
  int toSql(Day value) => value.number;
}

/// One row: the install day and the goal.
@DataClassName('StateRow')
class ProgressState extends Table {
  /// Always 1: the table has a single row.
  // drift reads the check from the getter itself.
  // ignore: recursive_getters
  IntColumn get id => integer().check(id.equals(1))();

  /// The day the app was installed.
  IntColumn get installDay => integer().map(const DayConverter())();

  /// The progression of the goal; `null` when there is no goal.
  TextColumn get goalProgressionId => text().nullable()();

  /// The chapter when the goal is a chapter.
  TextColumn get goalChapterId => text().nullable()();

  /// The medal when the goal is a medal, by name.
  TextColumn get goalMedal => textEnum<Medal>().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// The steps of each day: one row per day.
@DataClassName('DayRow')
class DayStepsTable extends Table {
  @override
  String get tableName => 'day_steps';

  /// The day.
  IntColumn get day => integer().map(const DayConverter())();

  /// The total from the phone's step source; `null` when it gave none.
  IntColumn get auto => integer().nullable()();

  /// The source allowed to correct the automatic total of the day.
  TextColumn get autoOrigin => textEnum<AutoStepOrigin>().nullable()();

  /// The steps added by hand.
  IntColumn get manual => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {day};
}

/// Opened chapters: a chapter is opened once.
@DataClassName('OpenedChapterRow')
class OpenedChapters extends Table {
  /// The progression.
  TextColumn get progressionId => text()();

  /// The chapter.
  TextColumn get chapterId => text()();

  /// The steps paid.
  IntColumn get price => integer()();

  /// When it was opened, in UTC.
  DateTimeColumn get at => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {progressionId, chapterId};
}

/// Bought medals: each medal of a progression is bought once.
@DataClassName('BoughtMedalRow')
class BoughtMedals extends Table {
  /// The progression.
  TextColumn get progressionId => text()();

  /// The medal, by name, so a new medal in the enum does not shift the
  /// stored ones.
  TextColumn get medal => textEnum<Medal>()();

  /// The steps paid.
  IntColumn get price => integer()();

  /// When it was bought, in UTC.
  DateTimeColumn get at => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {progressionId, medal};
}

/// The SQLite database of the progress.
@DriftDatabase(
  tables: [ProgressState, DayStepsTable, OpenedChapters, BoughtMedals],
)
class ProgressDatabase extends _$ProgressDatabase {
  /// Opens the database on the connection [e]. When it is created, the
  /// install day is [installDay], today by default.
  ProgressDatabase(super.e, {Day Function()? installDay})
    : _installDay = installDay ?? Day.today;

  final Day Function() _installDay;

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await into(progressState).insert(
        ProgressStateCompanion.insert(
          id: const Value(1),
          installDay: _installDay(),
        ),
      );
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.addColumn(dayStepsTable, dayStepsTable.autoOrigin);
    },
  );
}
