import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/pages/today/bloc/bloc.dart';
import 'package:walks/ui/pages/today/widgets/today_surfaces.dart';
import 'package:walks/ui/theme/theme.dart';

/// Displays the current goal and the action available for it.
class TodayGoalCard extends StatelessWidget {
  /// Creates the card for the current goal.
  const TodayGoalCard({
    required this.progress,
    required this.state,
    required this.onOpenCatalog,
    required this.onRetryCatalog,
    required this.onSpend,
    super.key,
  });

  /// Progress and available steps.
  final Progress progress;

  /// The goal, catalog, and spending state.
  final TodayState state;

  /// Opens the goal catalog.
  final VoidCallback onOpenCatalog;

  /// Reloads the goal catalog.
  final VoidCallback onRetryCatalog;

  /// Spends steps on the displayed goal.
  final ValueChanged<Goal> onSpend;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = StepfoldColors.of(context);
    final reserve = progress.reserve;
    final reserveText = reserve < 0
        ? l10n.todayDebt(l10n.stepCount(-reserve))
        : l10n.todayReserve(l10n.stepCount(reserve));
    final reserveLabel = Text(
      reserveText,
      style: theme.textTheme.labelMedium?.copyWith(
        color: reserve < 0 ? colors.debt : theme.colorScheme.onSurfaceVariant,
      ),
    );

    if (progress.goal == null) {
      return TodayNotice(
        title: l10n.todayChooseGoal,
        message: reserveText,
        actionLabel: l10n.todayToCatalog,
        onAction: onOpenCatalog,
        primary: true,
      );
    }
    if (state.catalogLoading) return const KitStatePlaceholder.loading();
    final target = state.target;
    if (target == null) {
      return TodayNotice(
        title: l10n.todayGoalUnavailable,
        message: state.catalogFailure == null
            ? reserveText
            : l10n.todayCatalogError,
        actionLabel: state.catalogFailure == null
            ? l10n.todayToCatalog
            : l10n.retry,
        onAction: state.catalogFailure == null ? onOpenCatalog : onRetryCatalog,
      );
    }

    final goal = target.goal;
    final ready = target.left == 0;
    final spending = state.spendingGoal == goal;
    final title = switch (goal) {
      ChapterGoal() => target.chapterTitle ?? l10n.chapterReader,
      MedalGoal(:final medal) => switch (medal) {
        Medal.bronze => l10n.todayBronzeMedal,
        Medal.silver => l10n.todaySilverMedal,
        Medal.gold => l10n.todayGoldMedal,
      },
    };
    final error = switch (state.spendingFailure) {
      NotEnoughSteps() => l10n.todayReserveChanged,
      ChapterUnavailable() || MedalUnavailable() => l10n.todayGoalUnavailable,
      null => switch (state.spendingStorageFailure) {
        StorageFull() => l10n.storageFull,
        StorageUnavailable() => l10n.todaySpendingFailed,
        null => null,
      },
    };
    return TodaySurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Spacing.s12,
        children: [
          Text(
            target.progression.title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(title, style: theme.textTheme.headlineMedium),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: Spacing.s12,
              runSpacing: Spacing.s4,
              alignment: WrapAlignment.spaceBetween,
              children: [
                Text(
                  l10n.todayGoalPrice(l10n.stepCount(target.price)),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                reserveLabel,
              ],
            ),
          ),
          Semantics(
            label: ready
                ? l10n.todayReady
                : l10n.todayStepsLeft(l10n.stepCount(target.left)),
            child: KitProgressBar(
              value: target.price == 0
                  ? (ready ? 1 : 0)
                  : reserve / target.price,
              debt: reserve < 0,
            ),
          ),
          Text(
            ready
                ? l10n.todayReady
                : l10n.todayStepsLeft(l10n.stepCount(target.left)),
            style: theme.textTheme.titleLarge?.copyWith(
              color: reserve < 0 ? colors.debt : colors.primaryText,
            ),
          ),
          if (ready || spending)
            KitButton(
              kind: KitButtonKind.primary,
              label: goal is ChapterGoal
                  ? l10n.todayOpenChapter
                  : l10n.todayBuyMedal,
              loading: spending,
              onPressed: state.spendingGoal == null
                  ? () => onSpend(goal)
                  : null,
            ),
          if (error != null)
            Text(
              error,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }
}
