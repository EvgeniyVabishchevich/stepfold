part of '../today_page.dart';

class _DailySummary extends StatelessWidget {
  const _DailySummary({required this.progress, required this.day});

  final Progress progress;
  final Day day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final record = progress.stepsOf(day);
    final count = record.auto == null && !record.isManual
        ? l10n.todayUnknownSteps
        : NumberFormat.decimalPattern(l10n.localeName).format(record.counted);
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Spacing.s12,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final steps = _Metric(
                label: l10n.todaySteps,
                value: count,
                style: theme.textTheme.displayMedium,
              );
              final series = _Metric(
                label: l10n.todayStreak,
                value: l10n.todayStreakDays(streak(progress, day)),
                style: theme.textTheme.headlineMedium,
              );
              final scale = MediaQuery.textScalerOf(context).scale(48) / 48;
              if (constraints.maxWidth < 260 * scale) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Spacing.s12,
                  children: [steps, series],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Spacing.s16,
                children: [
                  Expanded(child: steps),
                  Expanded(child: series),
                ],
              );
            },
          ),
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
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.style,
  });

  final String label;
  final String value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
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
    final colors = StepfoldColors.of(context);
    final date = _calendarDate(day);
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
                    ? colors.primaryText
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox.square(
            dimension: 24,
            child: Center(
              child: Container(
                width: today ? 24 : 20,
                height: today ? 24 : 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: reached ? theme.colorScheme.primary : null,
                  border: reached
                      ? null
                      : Border.all(color: theme.colorScheme.outline),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
