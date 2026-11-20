import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/l10n/l10n.dart';

/// Formats a calendar date without converting it through a time zone.
DateTime dateOf(Day day) => DateTime.utc(day.year, day.month, day.day);

/// The localized label of a day in the list or form.
String historyDayLabel(BuildContext context, Day day, Day today) {
  final l10n = context.l10n;
  if (day == today) return l10n.historyToday;
  return (day.year == today.year
          ? DateFormat.MMMMd(l10n.localeName)
          : DateFormat.yMMMMd(l10n.localeName))
      .format(dateOf(day));
}

/// Approximate distance formatted in the current locale, without the unit.
String historyDistance(BuildContext context, int steps) =>
    NumberFormat.decimalPatternDigits(
      locale: context.l10n.localeName,
      decimalDigits: 1,
    ).format(estimatedKilometres(steps));
