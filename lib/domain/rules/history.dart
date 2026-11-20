import 'package:walks/domain/models/models.dart';

/// Summary of the current calendar week, to the current local day.
typedef HistoryWeek = ({
  List<DaySteps> days,
  int steps,
  DaySteps? bestDay,
  List<Spending> openings,
  int? improvement,
});

/// An estimate using 75 centimetres per step.
double estimatedKilometres(int steps) => steps * 0.00075;

/// Summarizes the week starting Monday, comparing the same number of days
/// in the previous week when the app was installed for both periods.
HistoryWeek historyWeek(Progress progress, Day today) {
  // 1970-01-01 (day 0) was a Thursday.
  final elapsed = (today.number + 3) % 7;
  final start = today - elapsed;
  final previousStart = start - 7;
  final compare = !previousStart.isBefore(progress.installDay);
  final days = [for (var i = 0; i < 7; i++) progress.stepsOf(start + i)];
  var steps = 0;
  var previousSteps = 0;
  DaySteps? best;
  for (var i = 0; i <= elapsed; i++) {
    final day = days[i];
    steps += day.counted;
    if (day.counted > (best?.counted ?? 0)) best = day;
    if (compare) previousSteps += progress.stepsOf(previousStart + i).counted;
  }
  return (
    days: days,
    steps: steps,
    bestDay: best,
    openings: progress.spendings.where((spending) {
      final day = Day.fromLocal(spending.at);
      return !day.isBefore(start) && !day.isAfter(today);
    }).toList(),
    improvement: compare && steps > previousSteps
        ? steps - previousSteps
        : null,
  );
}
