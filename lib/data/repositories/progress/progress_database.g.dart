// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_database.dart';

// ignore_for_file: type=lint
class $ProgressStateTable extends ProgressState
    with TableInfo<$ProgressStateTable, StateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    check: () => id.equals(1),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Day, int> installDay =
      GeneratedColumn<int>(
        'install_day',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Day>($ProgressStateTable.$converterinstallDay);
  static const VerificationMeta _goalProgressionIdMeta = const VerificationMeta(
    'goalProgressionId',
  );
  @override
  late final GeneratedColumn<String> goalProgressionId =
      GeneratedColumn<String>(
        'goal_progression_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _goalChapterIdMeta = const VerificationMeta(
    'goalChapterId',
  );
  @override
  late final GeneratedColumn<String> goalChapterId = GeneratedColumn<String>(
    'goal_chapter_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Medal?, String> goalMedal =
      GeneratedColumn<String>(
        'goal_medal',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Medal?>($ProgressStateTable.$convertergoalMedaln);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    installDay,
    goalProgressionId,
    goalChapterId,
    goalMedal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<StateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal_progression_id')) {
      context.handle(
        _goalProgressionIdMeta,
        goalProgressionId.isAcceptableOrUnknown(
          data['goal_progression_id']!,
          _goalProgressionIdMeta,
        ),
      );
    }
    if (data.containsKey('goal_chapter_id')) {
      context.handle(
        _goalChapterIdMeta,
        goalChapterId.isAcceptableOrUnknown(
          data['goal_chapter_id']!,
          _goalChapterIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      installDay: $ProgressStateTable.$converterinstallDay.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}install_day'],
        )!,
      ),
      goalProgressionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_progression_id'],
      ),
      goalChapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_chapter_id'],
      ),
      goalMedal: $ProgressStateTable.$convertergoalMedaln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}goal_medal'],
        ),
      ),
    );
  }

  @override
  $ProgressStateTable createAlias(String alias) {
    return $ProgressStateTable(attachedDatabase, alias);
  }

  static TypeConverter<Day, int> $converterinstallDay = const DayConverter();
  static JsonTypeConverter2<Medal, String, String> $convertergoalMedal =
      const EnumNameConverter<Medal>(Medal.values);
  static JsonTypeConverter2<Medal?, String?, String?> $convertergoalMedaln =
      JsonTypeConverter2.asNullable($convertergoalMedal);
}

class StateRow extends DataClass implements Insertable<StateRow> {
  /// Always 1: the table has a single row.
  final int id;

  /// The day the app was installed.
  final Day installDay;

  /// The progression of the goal; `null` when there is no goal.
  final String? goalProgressionId;

  /// The chapter when the goal is a chapter.
  final String? goalChapterId;

  /// The medal when the goal is a medal, by name.
  final Medal? goalMedal;
  const StateRow({
    required this.id,
    required this.installDay,
    this.goalProgressionId,
    this.goalChapterId,
    this.goalMedal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['install_day'] = Variable<int>(
        $ProgressStateTable.$converterinstallDay.toSql(installDay),
      );
    }
    if (!nullToAbsent || goalProgressionId != null) {
      map['goal_progression_id'] = Variable<String>(goalProgressionId);
    }
    if (!nullToAbsent || goalChapterId != null) {
      map['goal_chapter_id'] = Variable<String>(goalChapterId);
    }
    if (!nullToAbsent || goalMedal != null) {
      map['goal_medal'] = Variable<String>(
        $ProgressStateTable.$convertergoalMedaln.toSql(goalMedal),
      );
    }
    return map;
  }

  ProgressStateCompanion toCompanion(bool nullToAbsent) {
    return ProgressStateCompanion(
      id: Value(id),
      installDay: Value(installDay),
      goalProgressionId: goalProgressionId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalProgressionId),
      goalChapterId: goalChapterId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalChapterId),
      goalMedal: goalMedal == null && nullToAbsent
          ? const Value.absent()
          : Value(goalMedal),
    );
  }

  factory StateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StateRow(
      id: serializer.fromJson<int>(json['id']),
      installDay: serializer.fromJson<Day>(json['installDay']),
      goalProgressionId: serializer.fromJson<String?>(
        json['goalProgressionId'],
      ),
      goalChapterId: serializer.fromJson<String?>(json['goalChapterId']),
      goalMedal: $ProgressStateTable.$convertergoalMedaln.fromJson(
        serializer.fromJson<String?>(json['goalMedal']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'installDay': serializer.toJson<Day>(installDay),
      'goalProgressionId': serializer.toJson<String?>(goalProgressionId),
      'goalChapterId': serializer.toJson<String?>(goalChapterId),
      'goalMedal': serializer.toJson<String?>(
        $ProgressStateTable.$convertergoalMedaln.toJson(goalMedal),
      ),
    };
  }

  StateRow copyWith({
    int? id,
    Day? installDay,
    Value<String?> goalProgressionId = const Value.absent(),
    Value<String?> goalChapterId = const Value.absent(),
    Value<Medal?> goalMedal = const Value.absent(),
  }) => StateRow(
    id: id ?? this.id,
    installDay: installDay ?? this.installDay,
    goalProgressionId: goalProgressionId.present
        ? goalProgressionId.value
        : this.goalProgressionId,
    goalChapterId: goalChapterId.present
        ? goalChapterId.value
        : this.goalChapterId,
    goalMedal: goalMedal.present ? goalMedal.value : this.goalMedal,
  );
  StateRow copyWithCompanion(ProgressStateCompanion data) {
    return StateRow(
      id: data.id.present ? data.id.value : this.id,
      installDay: data.installDay.present
          ? data.installDay.value
          : this.installDay,
      goalProgressionId: data.goalProgressionId.present
          ? data.goalProgressionId.value
          : this.goalProgressionId,
      goalChapterId: data.goalChapterId.present
          ? data.goalChapterId.value
          : this.goalChapterId,
      goalMedal: data.goalMedal.present ? data.goalMedal.value : this.goalMedal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StateRow(')
          ..write('id: $id, ')
          ..write('installDay: $installDay, ')
          ..write('goalProgressionId: $goalProgressionId, ')
          ..write('goalChapterId: $goalChapterId, ')
          ..write('goalMedal: $goalMedal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, installDay, goalProgressionId, goalChapterId, goalMedal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StateRow &&
          other.id == this.id &&
          other.installDay == this.installDay &&
          other.goalProgressionId == this.goalProgressionId &&
          other.goalChapterId == this.goalChapterId &&
          other.goalMedal == this.goalMedal);
}

class ProgressStateCompanion extends UpdateCompanion<StateRow> {
  final Value<int> id;
  final Value<Day> installDay;
  final Value<String?> goalProgressionId;
  final Value<String?> goalChapterId;
  final Value<Medal?> goalMedal;
  const ProgressStateCompanion({
    this.id = const Value.absent(),
    this.installDay = const Value.absent(),
    this.goalProgressionId = const Value.absent(),
    this.goalChapterId = const Value.absent(),
    this.goalMedal = const Value.absent(),
  });
  ProgressStateCompanion.insert({
    this.id = const Value.absent(),
    required Day installDay,
    this.goalProgressionId = const Value.absent(),
    this.goalChapterId = const Value.absent(),
    this.goalMedal = const Value.absent(),
  }) : installDay = Value(installDay);
  static Insertable<StateRow> custom({
    Expression<int>? id,
    Expression<int>? installDay,
    Expression<String>? goalProgressionId,
    Expression<String>? goalChapterId,
    Expression<String>? goalMedal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (installDay != null) 'install_day': installDay,
      if (goalProgressionId != null) 'goal_progression_id': goalProgressionId,
      if (goalChapterId != null) 'goal_chapter_id': goalChapterId,
      if (goalMedal != null) 'goal_medal': goalMedal,
    });
  }

  ProgressStateCompanion copyWith({
    Value<int>? id,
    Value<Day>? installDay,
    Value<String?>? goalProgressionId,
    Value<String?>? goalChapterId,
    Value<Medal?>? goalMedal,
  }) {
    return ProgressStateCompanion(
      id: id ?? this.id,
      installDay: installDay ?? this.installDay,
      goalProgressionId: goalProgressionId ?? this.goalProgressionId,
      goalChapterId: goalChapterId ?? this.goalChapterId,
      goalMedal: goalMedal ?? this.goalMedal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (installDay.present) {
      map['install_day'] = Variable<int>(
        $ProgressStateTable.$converterinstallDay.toSql(installDay.value),
      );
    }
    if (goalProgressionId.present) {
      map['goal_progression_id'] = Variable<String>(goalProgressionId.value);
    }
    if (goalChapterId.present) {
      map['goal_chapter_id'] = Variable<String>(goalChapterId.value);
    }
    if (goalMedal.present) {
      map['goal_medal'] = Variable<String>(
        $ProgressStateTable.$convertergoalMedaln.toSql(goalMedal.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressStateCompanion(')
          ..write('id: $id, ')
          ..write('installDay: $installDay, ')
          ..write('goalProgressionId: $goalProgressionId, ')
          ..write('goalChapterId: $goalChapterId, ')
          ..write('goalMedal: $goalMedal')
          ..write(')'))
        .toString();
  }
}

class $DayStepsTableTable extends DayStepsTable
    with TableInfo<$DayStepsTableTable, DayRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayStepsTableTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumnWithTypeConverter<Day, int> day =
      GeneratedColumn<int>(
        'day',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<Day>($DayStepsTableTable.$converterday);
  static const VerificationMeta _autoMeta = const VerificationMeta('auto');
  @override
  late final GeneratedColumn<int> auto = GeneratedColumn<int>(
    'auto',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AutoStepOrigin?, String>
  autoOrigin = GeneratedColumn<String>(
    'auto_origin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<AutoStepOrigin?>($DayStepsTableTable.$converterautoOriginn);
  static const VerificationMeta _manualMeta = const VerificationMeta('manual');
  @override
  late final GeneratedColumn<int> manual = GeneratedColumn<int>(
    'manual',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [day, auto, autoOrigin, manual];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('auto')) {
      context.handle(
        _autoMeta,
        auto.isAcceptableOrUnknown(data['auto']!, _autoMeta),
      );
    }
    if (data.containsKey('manual')) {
      context.handle(
        _manualMeta,
        manual.isAcceptableOrUnknown(data['manual']!, _manualMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  DayRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayRow(
      day: $DayStepsTableTable.$converterday.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}day'],
        )!,
      ),
      auto: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}auto'],
      ),
      autoOrigin: $DayStepsTableTable.$converterautoOriginn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}auto_origin'],
        ),
      ),
      manual: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}manual'],
      ),
    );
  }

  @override
  $DayStepsTableTable createAlias(String alias) {
    return $DayStepsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Day, int> $converterday = const DayConverter();
  static JsonTypeConverter2<AutoStepOrigin, String, String>
  $converterautoOrigin = const EnumNameConverter<AutoStepOrigin>(
    AutoStepOrigin.values,
  );
  static JsonTypeConverter2<AutoStepOrigin?, String?, String?>
  $converterautoOriginn = JsonTypeConverter2.asNullable($converterautoOrigin);
}

class DayRow extends DataClass implements Insertable<DayRow> {
  /// The day.
  final Day day;

  /// The total from the phone's step source; `null` when it gave none.
  final int? auto;

  /// The source allowed to correct the automatic total of the day.
  final AutoStepOrigin? autoOrigin;

  /// The steps added by hand.
  final int? manual;
  const DayRow({required this.day, this.auto, this.autoOrigin, this.manual});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      map['day'] = Variable<int>($DayStepsTableTable.$converterday.toSql(day));
    }
    if (!nullToAbsent || auto != null) {
      map['auto'] = Variable<int>(auto);
    }
    if (!nullToAbsent || autoOrigin != null) {
      map['auto_origin'] = Variable<String>(
        $DayStepsTableTable.$converterautoOriginn.toSql(autoOrigin),
      );
    }
    if (!nullToAbsent || manual != null) {
      map['manual'] = Variable<int>(manual);
    }
    return map;
  }

  DayStepsTableCompanion toCompanion(bool nullToAbsent) {
    return DayStepsTableCompanion(
      day: Value(day),
      auto: auto == null && nullToAbsent ? const Value.absent() : Value(auto),
      autoOrigin: autoOrigin == null && nullToAbsent
          ? const Value.absent()
          : Value(autoOrigin),
      manual: manual == null && nullToAbsent
          ? const Value.absent()
          : Value(manual),
    );
  }

  factory DayRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayRow(
      day: serializer.fromJson<Day>(json['day']),
      auto: serializer.fromJson<int?>(json['auto']),
      autoOrigin: $DayStepsTableTable.$converterautoOriginn.fromJson(
        serializer.fromJson<String?>(json['autoOrigin']),
      ),
      manual: serializer.fromJson<int?>(json['manual']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<Day>(day),
      'auto': serializer.toJson<int?>(auto),
      'autoOrigin': serializer.toJson<String?>(
        $DayStepsTableTable.$converterautoOriginn.toJson(autoOrigin),
      ),
      'manual': serializer.toJson<int?>(manual),
    };
  }

  DayRow copyWith({
    Day? day,
    Value<int?> auto = const Value.absent(),
    Value<AutoStepOrigin?> autoOrigin = const Value.absent(),
    Value<int?> manual = const Value.absent(),
  }) => DayRow(
    day: day ?? this.day,
    auto: auto.present ? auto.value : this.auto,
    autoOrigin: autoOrigin.present ? autoOrigin.value : this.autoOrigin,
    manual: manual.present ? manual.value : this.manual,
  );
  DayRow copyWithCompanion(DayStepsTableCompanion data) {
    return DayRow(
      day: data.day.present ? data.day.value : this.day,
      auto: data.auto.present ? data.auto.value : this.auto,
      autoOrigin: data.autoOrigin.present
          ? data.autoOrigin.value
          : this.autoOrigin,
      manual: data.manual.present ? data.manual.value : this.manual,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayRow(')
          ..write('day: $day, ')
          ..write('auto: $auto, ')
          ..write('autoOrigin: $autoOrigin, ')
          ..write('manual: $manual')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(day, auto, autoOrigin, manual);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayRow &&
          other.day == this.day &&
          other.auto == this.auto &&
          other.autoOrigin == this.autoOrigin &&
          other.manual == this.manual);
}

class DayStepsTableCompanion extends UpdateCompanion<DayRow> {
  final Value<Day> day;
  final Value<int?> auto;
  final Value<AutoStepOrigin?> autoOrigin;
  final Value<int?> manual;
  const DayStepsTableCompanion({
    this.day = const Value.absent(),
    this.auto = const Value.absent(),
    this.autoOrigin = const Value.absent(),
    this.manual = const Value.absent(),
  });
  DayStepsTableCompanion.insert({
    this.day = const Value.absent(),
    this.auto = const Value.absent(),
    this.autoOrigin = const Value.absent(),
    this.manual = const Value.absent(),
  });
  static Insertable<DayRow> custom({
    Expression<int>? day,
    Expression<int>? auto,
    Expression<String>? autoOrigin,
    Expression<int>? manual,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (auto != null) 'auto': auto,
      if (autoOrigin != null) 'auto_origin': autoOrigin,
      if (manual != null) 'manual': manual,
    });
  }

  DayStepsTableCompanion copyWith({
    Value<Day>? day,
    Value<int?>? auto,
    Value<AutoStepOrigin?>? autoOrigin,
    Value<int?>? manual,
  }) {
    return DayStepsTableCompanion(
      day: day ?? this.day,
      auto: auto ?? this.auto,
      autoOrigin: autoOrigin ?? this.autoOrigin,
      manual: manual ?? this.manual,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<int>(
        $DayStepsTableTable.$converterday.toSql(day.value),
      );
    }
    if (auto.present) {
      map['auto'] = Variable<int>(auto.value);
    }
    if (autoOrigin.present) {
      map['auto_origin'] = Variable<String>(
        $DayStepsTableTable.$converterautoOriginn.toSql(autoOrigin.value),
      );
    }
    if (manual.present) {
      map['manual'] = Variable<int>(manual.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayStepsTableCompanion(')
          ..write('day: $day, ')
          ..write('auto: $auto, ')
          ..write('autoOrigin: $autoOrigin, ')
          ..write('manual: $manual')
          ..write(')'))
        .toString();
  }
}

class $OpenedChaptersTable extends OpenedChapters
    with TableInfo<$OpenedChaptersTable, OpenedChapterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OpenedChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _progressionIdMeta = const VerificationMeta(
    'progressionId',
  );
  @override
  late final GeneratedColumn<String> progressionId = GeneratedColumn<String>(
    'progression_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [progressionId, chapterId, price, at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'opened_chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<OpenedChapterRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('progression_id')) {
      context.handle(
        _progressionIdMeta,
        progressionId.isAcceptableOrUnknown(
          data['progression_id']!,
          _progressionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_progressionIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {progressionId, chapterId};
  @override
  OpenedChapterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OpenedChapterRow(
      progressionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}progression_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $OpenedChaptersTable createAlias(String alias) {
    return $OpenedChaptersTable(attachedDatabase, alias);
  }
}

class OpenedChapterRow extends DataClass
    implements Insertable<OpenedChapterRow> {
  /// The progression.
  final String progressionId;

  /// The chapter.
  final String chapterId;

  /// The steps paid.
  final int price;

  /// When it was opened, in UTC.
  final DateTime at;
  const OpenedChapterRow({
    required this.progressionId,
    required this.chapterId,
    required this.price,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['progression_id'] = Variable<String>(progressionId);
    map['chapter_id'] = Variable<String>(chapterId);
    map['price'] = Variable<int>(price);
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  OpenedChaptersCompanion toCompanion(bool nullToAbsent) {
    return OpenedChaptersCompanion(
      progressionId: Value(progressionId),
      chapterId: Value(chapterId),
      price: Value(price),
      at: Value(at),
    );
  }

  factory OpenedChapterRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OpenedChapterRow(
      progressionId: serializer.fromJson<String>(json['progressionId']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      price: serializer.fromJson<int>(json['price']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'progressionId': serializer.toJson<String>(progressionId),
      'chapterId': serializer.toJson<String>(chapterId),
      'price': serializer.toJson<int>(price),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  OpenedChapterRow copyWith({
    String? progressionId,
    String? chapterId,
    int? price,
    DateTime? at,
  }) => OpenedChapterRow(
    progressionId: progressionId ?? this.progressionId,
    chapterId: chapterId ?? this.chapterId,
    price: price ?? this.price,
    at: at ?? this.at,
  );
  OpenedChapterRow copyWithCompanion(OpenedChaptersCompanion data) {
    return OpenedChapterRow(
      progressionId: data.progressionId.present
          ? data.progressionId.value
          : this.progressionId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      price: data.price.present ? data.price.value : this.price,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OpenedChapterRow(')
          ..write('progressionId: $progressionId, ')
          ..write('chapterId: $chapterId, ')
          ..write('price: $price, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(progressionId, chapterId, price, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OpenedChapterRow &&
          other.progressionId == this.progressionId &&
          other.chapterId == this.chapterId &&
          other.price == this.price &&
          other.at == this.at);
}

class OpenedChaptersCompanion extends UpdateCompanion<OpenedChapterRow> {
  final Value<String> progressionId;
  final Value<String> chapterId;
  final Value<int> price;
  final Value<DateTime> at;
  final Value<int> rowid;
  const OpenedChaptersCompanion({
    this.progressionId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.price = const Value.absent(),
    this.at = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OpenedChaptersCompanion.insert({
    required String progressionId,
    required String chapterId,
    required int price,
    required DateTime at,
    this.rowid = const Value.absent(),
  }) : progressionId = Value(progressionId),
       chapterId = Value(chapterId),
       price = Value(price),
       at = Value(at);
  static Insertable<OpenedChapterRow> custom({
    Expression<String>? progressionId,
    Expression<String>? chapterId,
    Expression<int>? price,
    Expression<DateTime>? at,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (progressionId != null) 'progression_id': progressionId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (price != null) 'price': price,
      if (at != null) 'at': at,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OpenedChaptersCompanion copyWith({
    Value<String>? progressionId,
    Value<String>? chapterId,
    Value<int>? price,
    Value<DateTime>? at,
    Value<int>? rowid,
  }) {
    return OpenedChaptersCompanion(
      progressionId: progressionId ?? this.progressionId,
      chapterId: chapterId ?? this.chapterId,
      price: price ?? this.price,
      at: at ?? this.at,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (progressionId.present) {
      map['progression_id'] = Variable<String>(progressionId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OpenedChaptersCompanion(')
          ..write('progressionId: $progressionId, ')
          ..write('chapterId: $chapterId, ')
          ..write('price: $price, ')
          ..write('at: $at, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BoughtMedalsTable extends BoughtMedals
    with TableInfo<$BoughtMedalsTable, BoughtMedalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BoughtMedalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _progressionIdMeta = const VerificationMeta(
    'progressionId',
  );
  @override
  late final GeneratedColumn<String> progressionId = GeneratedColumn<String>(
    'progression_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Medal, String> medal =
      GeneratedColumn<String>(
        'medal',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Medal>($BoughtMedalsTable.$convertermedal);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [progressionId, medal, price, at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bought_medals';
  @override
  VerificationContext validateIntegrity(
    Insertable<BoughtMedalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('progression_id')) {
      context.handle(
        _progressionIdMeta,
        progressionId.isAcceptableOrUnknown(
          data['progression_id']!,
          _progressionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_progressionIdMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {progressionId, medal};
  @override
  BoughtMedalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BoughtMedalRow(
      progressionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}progression_id'],
      )!,
      medal: $BoughtMedalsTable.$convertermedal.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}medal'],
        )!,
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $BoughtMedalsTable createAlias(String alias) {
    return $BoughtMedalsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Medal, String, String> $convertermedal =
      const EnumNameConverter<Medal>(Medal.values);
}

class BoughtMedalRow extends DataClass implements Insertable<BoughtMedalRow> {
  /// The progression.
  final String progressionId;

  /// The medal, by name, so a new medal in the enum does not shift the
  /// stored ones.
  final Medal medal;

  /// The steps paid.
  final int price;

  /// When it was bought, in UTC.
  final DateTime at;
  const BoughtMedalRow({
    required this.progressionId,
    required this.medal,
    required this.price,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['progression_id'] = Variable<String>(progressionId);
    {
      map['medal'] = Variable<String>(
        $BoughtMedalsTable.$convertermedal.toSql(medal),
      );
    }
    map['price'] = Variable<int>(price);
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  BoughtMedalsCompanion toCompanion(bool nullToAbsent) {
    return BoughtMedalsCompanion(
      progressionId: Value(progressionId),
      medal: Value(medal),
      price: Value(price),
      at: Value(at),
    );
  }

  factory BoughtMedalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BoughtMedalRow(
      progressionId: serializer.fromJson<String>(json['progressionId']),
      medal: $BoughtMedalsTable.$convertermedal.fromJson(
        serializer.fromJson<String>(json['medal']),
      ),
      price: serializer.fromJson<int>(json['price']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'progressionId': serializer.toJson<String>(progressionId),
      'medal': serializer.toJson<String>(
        $BoughtMedalsTable.$convertermedal.toJson(medal),
      ),
      'price': serializer.toJson<int>(price),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  BoughtMedalRow copyWith({
    String? progressionId,
    Medal? medal,
    int? price,
    DateTime? at,
  }) => BoughtMedalRow(
    progressionId: progressionId ?? this.progressionId,
    medal: medal ?? this.medal,
    price: price ?? this.price,
    at: at ?? this.at,
  );
  BoughtMedalRow copyWithCompanion(BoughtMedalsCompanion data) {
    return BoughtMedalRow(
      progressionId: data.progressionId.present
          ? data.progressionId.value
          : this.progressionId,
      medal: data.medal.present ? data.medal.value : this.medal,
      price: data.price.present ? data.price.value : this.price,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BoughtMedalRow(')
          ..write('progressionId: $progressionId, ')
          ..write('medal: $medal, ')
          ..write('price: $price, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(progressionId, medal, price, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BoughtMedalRow &&
          other.progressionId == this.progressionId &&
          other.medal == this.medal &&
          other.price == this.price &&
          other.at == this.at);
}

class BoughtMedalsCompanion extends UpdateCompanion<BoughtMedalRow> {
  final Value<String> progressionId;
  final Value<Medal> medal;
  final Value<int> price;
  final Value<DateTime> at;
  final Value<int> rowid;
  const BoughtMedalsCompanion({
    this.progressionId = const Value.absent(),
    this.medal = const Value.absent(),
    this.price = const Value.absent(),
    this.at = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BoughtMedalsCompanion.insert({
    required String progressionId,
    required Medal medal,
    required int price,
    required DateTime at,
    this.rowid = const Value.absent(),
  }) : progressionId = Value(progressionId),
       medal = Value(medal),
       price = Value(price),
       at = Value(at);
  static Insertable<BoughtMedalRow> custom({
    Expression<String>? progressionId,
    Expression<String>? medal,
    Expression<int>? price,
    Expression<DateTime>? at,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (progressionId != null) 'progression_id': progressionId,
      if (medal != null) 'medal': medal,
      if (price != null) 'price': price,
      if (at != null) 'at': at,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BoughtMedalsCompanion copyWith({
    Value<String>? progressionId,
    Value<Medal>? medal,
    Value<int>? price,
    Value<DateTime>? at,
    Value<int>? rowid,
  }) {
    return BoughtMedalsCompanion(
      progressionId: progressionId ?? this.progressionId,
      medal: medal ?? this.medal,
      price: price ?? this.price,
      at: at ?? this.at,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (progressionId.present) {
      map['progression_id'] = Variable<String>(progressionId.value);
    }
    if (medal.present) {
      map['medal'] = Variable<String>(
        $BoughtMedalsTable.$convertermedal.toSql(medal.value),
      );
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BoughtMedalsCompanion(')
          ..write('progressionId: $progressionId, ')
          ..write('medal: $medal, ')
          ..write('price: $price, ')
          ..write('at: $at, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ProgressDatabase extends GeneratedDatabase {
  _$ProgressDatabase(QueryExecutor e) : super(e);
  $ProgressDatabaseManager get managers => $ProgressDatabaseManager(this);
  late final $ProgressStateTable progressState = $ProgressStateTable(this);
  late final $DayStepsTableTable dayStepsTable = $DayStepsTableTable(this);
  late final $OpenedChaptersTable openedChapters = $OpenedChaptersTable(this);
  late final $BoughtMedalsTable boughtMedals = $BoughtMedalsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    progressState,
    dayStepsTable,
    openedChapters,
    boughtMedals,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ProgressStateTableCreateCompanionBuilder =
    ProgressStateCompanion Function({
      Value<int> id,
      required Day installDay,
      Value<String?> goalProgressionId,
      Value<String?> goalChapterId,
      Value<Medal?> goalMedal,
    });
typedef $$ProgressStateTableUpdateCompanionBuilder =
    ProgressStateCompanion Function({
      Value<int> id,
      Value<Day> installDay,
      Value<String?> goalProgressionId,
      Value<String?> goalChapterId,
      Value<Medal?> goalMedal,
    });

class $$ProgressStateTableFilterComposer
    extends Composer<_$ProgressDatabase, $ProgressStateTable> {
  $$ProgressStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Day, Day, int> get installDay =>
      $composableBuilder(
        column: $table.installDay,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get goalProgressionId => $composableBuilder(
    column: $table.goalProgressionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalChapterId => $composableBuilder(
    column: $table.goalChapterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Medal?, Medal, String> get goalMedal =>
      $composableBuilder(
        column: $table.goalMedal,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$ProgressStateTableOrderingComposer
    extends Composer<_$ProgressDatabase, $ProgressStateTable> {
  $$ProgressStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get installDay => $composableBuilder(
    column: $table.installDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalProgressionId => $composableBuilder(
    column: $table.goalProgressionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalChapterId => $composableBuilder(
    column: $table.goalChapterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalMedal => $composableBuilder(
    column: $table.goalMedal,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgressStateTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $ProgressStateTable> {
  $$ProgressStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Day, int> get installDay =>
      $composableBuilder(
        column: $table.installDay,
        builder: (column) => column,
      );

  GeneratedColumn<String> get goalProgressionId => $composableBuilder(
    column: $table.goalProgressionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalChapterId => $composableBuilder(
    column: $table.goalChapterId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Medal?, String> get goalMedal =>
      $composableBuilder(column: $table.goalMedal, builder: (column) => column);
}

class $$ProgressStateTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $ProgressStateTable,
          StateRow,
          $$ProgressStateTableFilterComposer,
          $$ProgressStateTableOrderingComposer,
          $$ProgressStateTableAnnotationComposer,
          $$ProgressStateTableCreateCompanionBuilder,
          $$ProgressStateTableUpdateCompanionBuilder,
          (
            StateRow,
            BaseReferences<_$ProgressDatabase, $ProgressStateTable, StateRow>,
          ),
          StateRow,
          PrefetchHooks Function()
        > {
  $$ProgressStateTableTableManager(
    _$ProgressDatabase db,
    $ProgressStateTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<Day> installDay = const Value.absent(),
                Value<String?> goalProgressionId = const Value.absent(),
                Value<String?> goalChapterId = const Value.absent(),
                Value<Medal?> goalMedal = const Value.absent(),
              }) => ProgressStateCompanion(
                id: id,
                installDay: installDay,
                goalProgressionId: goalProgressionId,
                goalChapterId: goalChapterId,
                goalMedal: goalMedal,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required Day installDay,
                Value<String?> goalProgressionId = const Value.absent(),
                Value<String?> goalChapterId = const Value.absent(),
                Value<Medal?> goalMedal = const Value.absent(),
              }) => ProgressStateCompanion.insert(
                id: id,
                installDay: installDay,
                goalProgressionId: goalProgressionId,
                goalChapterId: goalChapterId,
                goalMedal: goalMedal,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProgressStateTable, StateRow>(table),
                  BaseReferences<
                    _$ProgressDatabase,
                    $ProgressStateTable,
                    StateRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgressStateTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $ProgressStateTable,
      StateRow,
      $$ProgressStateTableFilterComposer,
      $$ProgressStateTableOrderingComposer,
      $$ProgressStateTableAnnotationComposer,
      $$ProgressStateTableCreateCompanionBuilder,
      $$ProgressStateTableUpdateCompanionBuilder,
      (
        StateRow,
        BaseReferences<_$ProgressDatabase, $ProgressStateTable, StateRow>,
      ),
      StateRow,
      PrefetchHooks Function()
    >;
typedef $$DayStepsTableTableCreateCompanionBuilder =
    DayStepsTableCompanion Function({
      Value<Day> day,
      Value<int?> auto,
      Value<AutoStepOrigin?> autoOrigin,
      Value<int?> manual,
    });
typedef $$DayStepsTableTableUpdateCompanionBuilder =
    DayStepsTableCompanion Function({
      Value<Day> day,
      Value<int?> auto,
      Value<AutoStepOrigin?> autoOrigin,
      Value<int?> manual,
    });

class $$DayStepsTableTableFilterComposer
    extends Composer<_$ProgressDatabase, $DayStepsTableTable> {
  $$DayStepsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<Day, Day, int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get auto => $composableBuilder(
    column: $table.auto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AutoStepOrigin?, AutoStepOrigin, String>
  get autoOrigin => $composableBuilder(
    column: $table.autoOrigin,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get manual => $composableBuilder(
    column: $table.manual,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DayStepsTableTableOrderingComposer
    extends Composer<_$ProgressDatabase, $DayStepsTableTable> {
  $$DayStepsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get auto => $composableBuilder(
    column: $table.auto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get autoOrigin => $composableBuilder(
    column: $table.autoOrigin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get manual => $composableBuilder(
    column: $table.manual,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DayStepsTableTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $DayStepsTableTable> {
  $$DayStepsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<Day, int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get auto =>
      $composableBuilder(column: $table.auto, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AutoStepOrigin?, String> get autoOrigin =>
      $composableBuilder(
        column: $table.autoOrigin,
        builder: (column) => column,
      );

  GeneratedColumn<int> get manual =>
      $composableBuilder(column: $table.manual, builder: (column) => column);
}

class $$DayStepsTableTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $DayStepsTableTable,
          DayRow,
          $$DayStepsTableTableFilterComposer,
          $$DayStepsTableTableOrderingComposer,
          $$DayStepsTableTableAnnotationComposer,
          $$DayStepsTableTableCreateCompanionBuilder,
          $$DayStepsTableTableUpdateCompanionBuilder,
          (
            DayRow,
            BaseReferences<_$ProgressDatabase, $DayStepsTableTable, DayRow>,
          ),
          DayRow,
          PrefetchHooks Function()
        > {
  $$DayStepsTableTableTableManager(
    _$ProgressDatabase db,
    $DayStepsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayStepsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayStepsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayStepsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<Day> day = const Value.absent(),
                Value<int?> auto = const Value.absent(),
                Value<AutoStepOrigin?> autoOrigin = const Value.absent(),
                Value<int?> manual = const Value.absent(),
              }) => DayStepsTableCompanion(
                day: day,
                auto: auto,
                autoOrigin: autoOrigin,
                manual: manual,
              ),
          createCompanionCallback:
              ({
                Value<Day> day = const Value.absent(),
                Value<int?> auto = const Value.absent(),
                Value<AutoStepOrigin?> autoOrigin = const Value.absent(),
                Value<int?> manual = const Value.absent(),
              }) => DayStepsTableCompanion.insert(
                day: day,
                auto: auto,
                autoOrigin: autoOrigin,
                manual: manual,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DayStepsTableTable, DayRow>(table),
                  BaseReferences<
                    _$ProgressDatabase,
                    $DayStepsTableTable,
                    DayRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DayStepsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $DayStepsTableTable,
      DayRow,
      $$DayStepsTableTableFilterComposer,
      $$DayStepsTableTableOrderingComposer,
      $$DayStepsTableTableAnnotationComposer,
      $$DayStepsTableTableCreateCompanionBuilder,
      $$DayStepsTableTableUpdateCompanionBuilder,
      (DayRow, BaseReferences<_$ProgressDatabase, $DayStepsTableTable, DayRow>),
      DayRow,
      PrefetchHooks Function()
    >;
typedef $$OpenedChaptersTableCreateCompanionBuilder =
    OpenedChaptersCompanion Function({
      required String progressionId,
      required String chapterId,
      required int price,
      required DateTime at,
      Value<int> rowid,
    });
typedef $$OpenedChaptersTableUpdateCompanionBuilder =
    OpenedChaptersCompanion Function({
      Value<String> progressionId,
      Value<String> chapterId,
      Value<int> price,
      Value<DateTime> at,
      Value<int> rowid,
    });

class $$OpenedChaptersTableFilterComposer
    extends Composer<_$ProgressDatabase, $OpenedChaptersTable> {
  $$OpenedChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get progressionId => $composableBuilder(
    column: $table.progressionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OpenedChaptersTableOrderingComposer
    extends Composer<_$ProgressDatabase, $OpenedChaptersTable> {
  $$OpenedChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get progressionId => $composableBuilder(
    column: $table.progressionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OpenedChaptersTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $OpenedChaptersTable> {
  $$OpenedChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get progressionId => $composableBuilder(
    column: $table.progressionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$OpenedChaptersTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $OpenedChaptersTable,
          OpenedChapterRow,
          $$OpenedChaptersTableFilterComposer,
          $$OpenedChaptersTableOrderingComposer,
          $$OpenedChaptersTableAnnotationComposer,
          $$OpenedChaptersTableCreateCompanionBuilder,
          $$OpenedChaptersTableUpdateCompanionBuilder,
          (
            OpenedChapterRow,
            BaseReferences<
              _$ProgressDatabase,
              $OpenedChaptersTable,
              OpenedChapterRow
            >,
          ),
          OpenedChapterRow,
          PrefetchHooks Function()
        > {
  $$OpenedChaptersTableTableManager(
    _$ProgressDatabase db,
    $OpenedChaptersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OpenedChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OpenedChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OpenedChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> progressionId = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OpenedChaptersCompanion(
                progressionId: progressionId,
                chapterId: chapterId,
                price: price,
                at: at,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String progressionId,
                required String chapterId,
                required int price,
                required DateTime at,
                Value<int> rowid = const Value.absent(),
              }) => OpenedChaptersCompanion.insert(
                progressionId: progressionId,
                chapterId: chapterId,
                price: price,
                at: at,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OpenedChaptersTable, OpenedChapterRow>(table),
                  BaseReferences<
                    _$ProgressDatabase,
                    $OpenedChaptersTable,
                    OpenedChapterRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OpenedChaptersTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $OpenedChaptersTable,
      OpenedChapterRow,
      $$OpenedChaptersTableFilterComposer,
      $$OpenedChaptersTableOrderingComposer,
      $$OpenedChaptersTableAnnotationComposer,
      $$OpenedChaptersTableCreateCompanionBuilder,
      $$OpenedChaptersTableUpdateCompanionBuilder,
      (
        OpenedChapterRow,
        BaseReferences<
          _$ProgressDatabase,
          $OpenedChaptersTable,
          OpenedChapterRow
        >,
      ),
      OpenedChapterRow,
      PrefetchHooks Function()
    >;
typedef $$BoughtMedalsTableCreateCompanionBuilder =
    BoughtMedalsCompanion Function({
      required String progressionId,
      required Medal medal,
      required int price,
      required DateTime at,
      Value<int> rowid,
    });
typedef $$BoughtMedalsTableUpdateCompanionBuilder =
    BoughtMedalsCompanion Function({
      Value<String> progressionId,
      Value<Medal> medal,
      Value<int> price,
      Value<DateTime> at,
      Value<int> rowid,
    });

class $$BoughtMedalsTableFilterComposer
    extends Composer<_$ProgressDatabase, $BoughtMedalsTable> {
  $$BoughtMedalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get progressionId => $composableBuilder(
    column: $table.progressionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Medal, Medal, String> get medal =>
      $composableBuilder(
        column: $table.medal,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BoughtMedalsTableOrderingComposer
    extends Composer<_$ProgressDatabase, $BoughtMedalsTable> {
  $$BoughtMedalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get progressionId => $composableBuilder(
    column: $table.progressionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medal => $composableBuilder(
    column: $table.medal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BoughtMedalsTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $BoughtMedalsTable> {
  $$BoughtMedalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get progressionId => $composableBuilder(
    column: $table.progressionId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Medal, String> get medal =>
      $composableBuilder(column: $table.medal, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$BoughtMedalsTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $BoughtMedalsTable,
          BoughtMedalRow,
          $$BoughtMedalsTableFilterComposer,
          $$BoughtMedalsTableOrderingComposer,
          $$BoughtMedalsTableAnnotationComposer,
          $$BoughtMedalsTableCreateCompanionBuilder,
          $$BoughtMedalsTableUpdateCompanionBuilder,
          (
            BoughtMedalRow,
            BaseReferences<
              _$ProgressDatabase,
              $BoughtMedalsTable,
              BoughtMedalRow
            >,
          ),
          BoughtMedalRow,
          PrefetchHooks Function()
        > {
  $$BoughtMedalsTableTableManager(
    _$ProgressDatabase db,
    $BoughtMedalsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BoughtMedalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BoughtMedalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BoughtMedalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> progressionId = const Value.absent(),
                Value<Medal> medal = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BoughtMedalsCompanion(
                progressionId: progressionId,
                medal: medal,
                price: price,
                at: at,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String progressionId,
                required Medal medal,
                required int price,
                required DateTime at,
                Value<int> rowid = const Value.absent(),
              }) => BoughtMedalsCompanion.insert(
                progressionId: progressionId,
                medal: medal,
                price: price,
                at: at,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BoughtMedalsTable, BoughtMedalRow>(table),
                  BaseReferences<
                    _$ProgressDatabase,
                    $BoughtMedalsTable,
                    BoughtMedalRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BoughtMedalsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $BoughtMedalsTable,
      BoughtMedalRow,
      $$BoughtMedalsTableFilterComposer,
      $$BoughtMedalsTableOrderingComposer,
      $$BoughtMedalsTableAnnotationComposer,
      $$BoughtMedalsTableCreateCompanionBuilder,
      $$BoughtMedalsTableUpdateCompanionBuilder,
      (
        BoughtMedalRow,
        BaseReferences<_$ProgressDatabase, $BoughtMedalsTable, BoughtMedalRow>,
      ),
      BoughtMedalRow,
      PrefetchHooks Function()
    >;

class $ProgressDatabaseManager {
  final _$ProgressDatabase _db;
  $ProgressDatabaseManager(this._db);
  $$ProgressStateTableTableManager get progressState =>
      $$ProgressStateTableTableManager(_db, _db.progressState);
  $$DayStepsTableTableTableManager get dayStepsTable =>
      $$DayStepsTableTableTableManager(_db, _db.dayStepsTable);
  $$OpenedChaptersTableTableManager get openedChapters =>
      $$OpenedChaptersTableTableManager(_db, _db.openedChapters);
  $$BoughtMedalsTableTableManager get boughtMedals =>
      $$BoughtMedalsTableTableManager(_db, _db.boughtMedals);
}
