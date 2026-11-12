import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/day_steps.dart';
import 'package:walks/domain/models/goal.dart';
import 'package:walks/domain/models/spending.dart';

part 'progress.freezed.dart';

/// Everything the user has walked and opened.
///
/// Steps work like a wallet: every counted step goes to the [reserve], and
/// opening a chapter or buying a medal spends from it. The reserve is not
/// stored: it is all counted steps minus all spendings. It goes below zero
/// (a debt) when steps disappear after they were spent; opened things stay
/// opened, and new steps pay the debt first.
///
/// Holds only what needs no catalog. Rules that need a progression live in
/// `domain/rules/`.
@freezed
abstract class Progress with _$Progress {
  /// Creates the progress of a user who installed the app on [installDay].
  const factory Progress({
    required Day installDay,
    @Default(<Day, DaySteps>{}) Map<Day, DaySteps> days,
    @Default(<Spending>[]) List<Spending> spendings,
    Goal? goal,
  }) = _Progress;

  const Progress._();

  /// All counted steps since the install day.
  int get totalSteps => days.values.fold(0, (sum, d) => sum + d.counted);

  /// All steps spent on chapters and medals.
  int get spent => spendings.fold(0, (sum, s) => sum + s.price);

  /// Steps that can be spent. Negative is a debt: steps were removed or a
  /// day total shrank after they were spent.
  int get reserve => totalSteps - spent;

  /// The steps of [day], empty if nothing was recorded.
  DaySteps stepsOf(Day day) => days[day] ?? DaySteps(day: day);

  /// Whether [chapterId] of [progressionId] is opened.
  bool isOpened(String progressionId, String chapterId) => spendings.any(
    (s) =>
        s is ChapterOpened &&
        s.progressionId == progressionId &&
        s.chapterId == chapterId,
  );

  /// Records the total of [day] from the phone's step source.
  ///
  /// Replaces the earlier total of that day, even with a smaller one.
  /// Days before [installDay] are ignored.
  Progress recordAutoSteps(Day day, int steps) {
    if (day.isBefore(installDay)) return this;
    return _withDay(stepsOf(day).copyWith(auto: steps));
  }

  /// Sets the steps of [day] added by hand: walked without the phone.
  ///
  /// Replaces the earlier addition; zero removes it. Checks are in
  /// `checkManualEntry`; this only stores the value.
  Progress recordManualSteps(Day day, int steps) {
    if (day.isBefore(installDay)) return this;
    return _withDay(stepsOf(day).copyWith(manual: steps));
  }

  Progress _withDay(DaySteps steps) =>
      copyWith(days: {...days, steps.day: steps});
}
