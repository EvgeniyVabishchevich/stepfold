part of '../today_page.dart';

DateTime _calendarDate(Day day) => DateTime.utc(day.year, day.month, day.day);

class _Heading extends StatelessWidget {
  const _Heading({required this.day, required this.onLongPress});

  final Day day;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final date = DateFormat(
      'EEEE, d MMMM',
      l10n.localeName,
    ).format(_calendarDate(day));
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
