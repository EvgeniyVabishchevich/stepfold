import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/theme/theme.dart';

/// Compares the accumulated walking distance with the height of Everest.
class TodayMilestone extends StatelessWidget {
  /// Creates a milestone based on all counted steps.
  const TodayMilestone({required this.steps, super.key});

  /// The accumulated steps before subtracting spending.
  final int steps;

  // Measured in kilometres, see docs/distance-facts.md.
  static const _everest = 8.84886;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final ratio = estimatedKilometres(steps) / _everest;
    final percent = ratio * 100;
    final number = NumberFormat.decimalPatternDigits(
      locale: l10n.localeName,
      decimalDigits: ratio < 1 && percent < 0.1 ? 2 : 1,
    );
    final detail = switch (ratio) {
      < 0.0001 => l10n.todayMilestoneUnder,
      < 1 => l10n.todayMilestonePercent(number.format(percent)),
      _ => l10n.todayMilestoneMultiple(number.format(ratio)),
    };
    return KitSurface(
      child: Row(
        spacing: Spacing.s12,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Spacing.s4,
              children: [
                Text(
                  l10n.todayMilestone,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(detail, style: theme.textTheme.titleMedium),
              ],
            ),
          ),
          KitIcon(KitIcons.milestonePeak, color: KitRelief.of(context).accent),
        ],
      ),
    );
  }
}
