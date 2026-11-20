import 'dart:async';

import 'package:flutter/services.dart' show PlatformException;
import 'package:walks/data/repositories/steps/android_steps.g.dart';
import 'package:walks/domain/domain.dart';

/// Reads Health Connect or the hardware step counter through Android JNI.
final class AndroidStepSource implements StepSource {
  /// Creates the historical Health Connect source.
  const AndroidStepSource.healthConnect(this._api)
    : _provider = AndroidStepProvider.healthConnect,
      _refreshInterval = const Duration(seconds: 30);

  /// Creates the source that records deltas from the hardware step counter.
  const AndroidStepSource.sensor(this._api)
    : _provider = AndroidStepProvider.sensor,
      _refreshInterval = const Duration(seconds: 2);

  /// Uses the hardware sensor when the system health store is unavailable.
  static Future<AndroidStepSource> select(AndroidStepsApi api) async {
    try {
      final status = await api.status(AndroidStepProvider.healthConnect);
      return status == AndroidStepPermission.unavailable
          ? AndroidStepSource.sensor(api)
          : AndroidStepSource.healthConnect(api);
    } on PlatformException catch (error) {
      // Let the shell handle transient permission and service errors on
      // the preferred source, including retrying after startup.
      if (error.code == 'step-permission-denied' ||
          error.code == 'step-source-unavailable') {
        return AndroidStepSource.healthConnect(api);
      }
      rethrow;
    }
  }

  final AndroidStepsApi _api;
  final AndroidStepProvider _provider;
  final Duration _refreshInterval;

  @override
  AutoStepOrigin get origin => switch (_provider) {
    AndroidStepProvider.healthConnect => AutoStepOrigin.healthStore,
    AndroidStepProvider.sensor => AutoStepOrigin.deviceSensor,
  };

  @override
  AppPermission get requiredPermission => switch (_provider) {
    AndroidStepProvider.healthConnect => AppPermission.healthSteps,
    AndroidStepProvider.sensor => AppPermission.activityRecognition,
  };

  @override
  Future<List<DayCount>> stepsByDay(Day from, Day to) async {
    if (from.isAfter(to)) {
      throw ArgumentError.value(from, 'from', 'Must be on or before to');
    }
    try {
      final days = await _api.readDays(_provider, from.number, to.number);
      return [
        for (final day in days)
          DayCount(day: Day.fromNumber(day.day), steps: day.steps),
      ];
    } on PlatformException catch (error, stack) {
      final failure = switch (error.code) {
        'step-permission-denied' => const StepPermissionDenied(),
        'step-source-unavailable' => const StepSourceUnavailable(),
        _ => error,
      };
      Error.throwWithStackTrace(failure, stack);
    }
  }

  @override
  Stream<DayCount> watchToday() =>
      _samples().where((count) => count != null).cast<DayCount>().distinct();

  Stream<DayCount?> _samples() async* {
    yield await _readToday();
    yield* Stream<void>.periodic(
      _refreshInterval,
    ).asyncMap((_) => _readToday());
  }

  Future<DayCount?> _readToday() async {
    final today = Day.today();
    final counts = await stepsByDay(today, today);
    return counts.firstOrNull;
  }
}
