import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/models/models.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/theme/theme.dart';

/// Displays the date and title of the Today screen.
class TodayHeading extends StatelessWidget {
  /// Creates the heading for the given [day].
  const TodayHeading({required this.day, required this.onLongPress, super.key});

  /// The date to display.
  final Day day;

  /// Opens the developer menu when available.
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final date = DateFormat(
      'EEEE, d MMMM',
      l10n.localeName,
    ).format(DateTime.utc(day.year, day.month, day.day));
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: Spacing.s4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date[0].toUpperCase() + date.substring(1),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                GestureDetector(
                  onLongPress: onLongPress,
                  child: Semantics(
                    header: true,
                    child: Text(
                      l10n.tabToday,
                      style: theme.textTheme.displayLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.s8),
          ExcludeSemantics(
            child: SizedBox(
              width: 64,
              height: 56,
              child: Stack(
                children: [
                  for (var i = 0; i < 3; i++)
                    Positioned(
                      left: i * 22,
                      bottom: 8 + i * 12,
                      child: Transform.rotate(
                        angle: -math.pi * 28 / 180,
                        child: Container(
                          width: 20,
                          height: 8,
                          decoration: ShapeDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: const <double>[0.32, 0.55, 1][i],
                            ),
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: Spacing.s4),
        ],
      ),
    );
  }
}
