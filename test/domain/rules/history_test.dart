import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/domain.dart';

void main() {
  final friday = Day(2026, 11, 20);
  final monday = friday - 4;

  test('calendar week includes manual steps and compares equal weekdays', () {
    final progress = Progress(
      installDay: monday - 8,
      days: {
        monday - 7: DaySteps(day: monday - 7, auto: 1200),
        monday - 2: DaySteps(day: monday - 2, auto: 10000),
        monday: DaySteps(day: monday, auto: 2500, manual: 500),
        friday: DaySteps(day: friday, auto: 2000),
        friday + 1: DaySteps(day: friday + 1, auto: 20000),
      },
      spendings: [
        Spending.chapter(
          progressionId: 'story',
          chapterId: 'first',
          price: 1000,
          at: DateTime(2026, 11, 16, 0, 1).toUtc(),
        ),
        Spending.medal(
          progressionId: 'story',
          medal: Medal.silver,
          price: 1000,
          at: DateTime(2026, 11, 21, 0, 1).toUtc(),
        ),
      ],
    );
    final week = historyWeek(progress, friday);

    expect(week.days.first.day, monday);
    expect(week.days.last.day, friday + 2);
    expect(week.steps, 5000);
    expect(week.bestDay?.day, monday);
    expect(week.openings, [progress.spendings.first]);
    expect(week.improvement, 3800);
    expect(estimatedKilometres(week.steps), 3.75);
  });

  test('no comparison before a full baseline or when the week is worse', () {
    final lateInstall = Progress(
      installDay: monday - 1,
      days: {monday: DaySteps(day: monday, auto: 2000)},
    );
    expect(historyWeek(lateInstall, friday).improvement, isNull);
    final previousWeek = lateInstall.copyWith(
      installDay: monday - 7,
      days: {monday - 7: DaySteps(day: monday - 7, auto: 4000)},
    );
    expect(historyWeek(previousWeek, friday).improvement, isNull);
    expect(historyWeek(previousWeek, friday).bestDay, isNull);
  });
}
