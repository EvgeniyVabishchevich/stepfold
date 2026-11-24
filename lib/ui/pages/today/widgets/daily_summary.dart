import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/theme/theme.dart';

/// Displays the day's step count and the seven-day streak.
class TodayDailySummary extends StatelessWidget {
  /// Creates the summary for the given [day].
  const TodayDailySummary({
    required this.progress,
    required this.day,
    super.key,
  });

  /// Progress used to count steps and streak days.
  final Progress progress;

  /// The last day shown in the streak.
  final Day day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final record = progress.stepsOf(day);
    final count = record.auto == null && !record.isManual
        ? l10n.todayUnknownSteps
        : NumberFormat.decimalPattern(l10n.localeName).format(record.counted);
    final numberStyle = theme.textTheme.displayMedium!;
    final labelStyle = theme.textTheme.labelMedium!.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final seriesStyle = theme.textTheme.titleLarge!.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final seriesText = l10n.todayStreakDays(streak(progress, day));
    return KitSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Spacing.s12,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final stepsWidth = math.max(
                _width(context, l10n.todaySteps, labelStyle),
                _width(context, count, numberStyle),
              );
              final seriesWidth = math.max(
                _width(context, l10n.todayStreak, labelStyle),
                _width(context, seriesText, seriesStyle),
              );
              const gap = Spacing.s12 * 2 + 1;
              final inline =
                  constraints.maxWidth >= 288 &&
                  stepsWidth + seriesWidth + gap <= constraints.maxWidth;
              final steps = _Metric(
                label: l10n.todaySteps,
                labelStyle: labelStyle,
                value: count,
                style: numberStyle,
                singleLine: true,
              );
              if (!inline) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Spacing.s8,
                  children: [
                    steps,
                    Wrap(
                      spacing: Spacing.s8,
                      runSpacing: Spacing.s4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(l10n.todayStreak, style: labelStyle),
                        Text(seriesText, style: seriesStyle),
                      ],
                    ),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Spacing.s12,
                children: [
                  Expanded(child: steps),
                  SizedBox(
                    height: 52,
                    child: VerticalDivider(
                      width: 1,
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  SizedBox(
                    width: seriesWidth,
                    child: _Metric(
                      label: l10n.todayStreak,
                      labelStyle: labelStyle,
                      value: seriesText,
                      style: seriesStyle,
                    ),
                  ),
                ],
              );
            },
          ),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          Text(
            l10n.todayStreakThreshold(streakDayThreshold),
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Row(
            children: [
              for (var offset = 6; offset >= 0; offset--)
                Expanded(
                  child: _StreakDay(
                    day: day - offset,
                    reached: progress.stepsOf(day - offset).countsForStreak,
                    today: offset == 0,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static double _width(BuildContext context, String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.labelStyle,
    required this.value,
    required this.style,
    this.singleLine = false,
  });

  final String label;
  final TextStyle labelStyle;
  final String value;
  final TextStyle? style;
  final bool singleLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        if (singleLine)
          FittedBox(
            alignment: AlignmentDirectional.centerStart,
            fit: BoxFit.scaleDown,
            child: Text(value, style: style),
          )
        else
          Text(value, style: style),
      ],
    );
  }
}

class _StreakDay extends StatelessWidget {
  const _StreakDay({
    required this.day,
    required this.reached,
    required this.today,
  });

  final Day day;
  final bool reached;
  final bool today;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = KitRelief.of(context);
    final date = DateTime.utc(day.year, day.month, day.day);
    final dayLabel = DateFormat.EEEE(l10n.localeName).format(date);
    return Semantics(
      label: reached
          ? l10n.todayStreakReached(dayLabel)
          : l10n.todayStreakMissed(dayLabel),
      selected: today,
      excludeSemantics: true,
      child: Column(
        spacing: Spacing.s8,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              DateFormat.E(l10n.localeName).format(date),
              style: theme.textTheme.labelMedium?.copyWith(
                color: today
                    ? colors.accent
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox.square(
            dimension: 24,
            child: Center(
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: reached ? colors.accent : null,
                  border: reached
                      ? null
                      : Border.all(color: theme.colorScheme.outline),
                ),
                child: today && reached
                    ? Icon(Icons.check, size: 10, color: colors.onAction)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
