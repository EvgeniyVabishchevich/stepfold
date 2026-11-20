import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/pages/history/widgets/history_labels.dart';
import 'package:walks/ui/theme/theme.dart';

/// The calendar week's statistics and seven daily bars.
class HistoryWeekCard extends StatelessWidget {
  /// Creates the summary card.
  const HistoryWeekCard({
    required this.week,
    required this.today,
    required this.catalog,
    super.key,
  });

  /// The weekly data from progress.
  final HistoryWeek week;

  /// The last day with possible readings.
  final Day today;

  /// Localized titles, when the catalog could be loaded.
  final CatalogIndex? catalog;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final dailyMax = week.days
        .where((day) => !day.day.isAfter(today))
        .fold(1, (max, day) => math.max(max, day.counted));
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Spacing.s8,
          children: [
            Text(l10n.historyThisWeek, style: theme.textTheme.titleMedium),
            Text(
              l10n.historyCountAndDistance(
                l10n.stepCount(week.steps),
                historyDistance(context, week.steps),
              ),
              style: theme.textTheme.headlineMedium,
            ),
            Row(
              children: [
                for (final day in week.days)
                  Expanded(
                    child: _WeekBar(day: day, today: today, dailyMax: dailyMax),
                  ),
              ],
            ),
            if (week.bestDay case final best?)
              Text(
                l10n.historyBestDay(
                  historyDayLabel(context, best.day, today),
                  l10n.stepCount(best.counted),
                ),
              ),
            for (final opening in _openings(context)) Text(opening),
            if (week.improvement case final improvement?)
              Text(l10n.historyImprovement(l10n.stepCount(improvement))),
            if (week.steps > 0)
              Text(
                _distanceFact(context),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Iterable<String> _openings(BuildContext context) sync* {
    final l10n = context.l10n;
    var unnamedChapters = 0;
    var unnamedMedals = 0;
    for (final opening in week.openings) {
      final progression = catalog?.progressionById(opening.progressionId);
      switch (opening) {
        case ChapterOpened(:final chapterId):
          final chapter = progression?.chapterById(chapterId);
          if (chapter == null || chapter.title.isEmpty) {
            unnamedChapters++;
          } else {
            yield l10n.historyOpenedTitle(chapter.title);
          }
        case MedalBought(:final medal):
          if (progression == null || progression.title.isEmpty) {
            unnamedMedals++;
          } else {
            final name = switch (medal) {
              Medal.bronze => l10n.historyBronze,
              Medal.silver => l10n.historySilver,
              Medal.gold => l10n.historyGold,
            };
            yield l10n.historyBoughtTitle(name, progression.title);
          }
      }
    }
    if (unnamedChapters > 0) yield l10n.historyOpenedChapters(unnamedChapters);
    if (unnamedMedals > 0) yield l10n.historyBoughtMedals(unnamedMedals);
  }

  String _distanceFact(BuildContext context) {
    final l10n = context.l10n;
    final km = estimatedKilometres(week.steps);
    // Stable comparisons from docs/distance-facts.md, in ascending order.
    final (reference, label) = km <= 4.5
        ? (4.5, l10n.historyNevsky)
        : km <= 42.195
        ? (42.195, l10n.historyMarathon)
        : (108.9, l10n.historyMkad);
    final ratio = km / reference;
    final number = NumberFormat.decimalPatternDigits(
      locale: l10n.localeName,
      decimalDigits: ratio < 0.001 ? 2 : 1,
    );
    if (ratio < 0.0001) return l10n.historyFactUnder(label);
    return ratio > 1
        ? l10n.historyFactMultiple(number.format(ratio), label)
        : l10n.historyFactPercent(number.format(ratio * 100), label);
  }
}

class _WeekBar extends StatelessWidget {
  const _WeekBar({
    required this.day,
    required this.today,
    required this.dailyMax,
  });

  final DaySteps day;
  final Day today;
  final int dailyMax;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final date = dateOf(day.day);
    final weekday = DateFormat.EEEE(l10n.localeName).format(date);
    final future = day.day.isAfter(today);
    final count = future ? 0 : day.counted;
    return Semantics(
      label: future ? weekday : '$weekday, ${l10n.stepCount(count)}',
      excludeSemantics: true,
      child: Column(
        spacing: Spacing.s4,
        children: [
          SizedBox(
            height: 68,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 22,
                height: math.max(3, 68 * count / dailyMax),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: count == 0
                      ? theme.colorScheme.surfaceContainerHighest
                      : theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              DateFormat.E(l10n.localeName).format(date),
              style: theme.textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
