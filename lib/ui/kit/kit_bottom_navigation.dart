import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit_icon.dart';
import 'package:walks/ui/theme/theme.dart';

/// A tab of [KitBottomNavigation].
class KitTab {
  /// Creates the tab.
  const KitTab({required this.icon, required this.label});

  /// Its duotone icon.
  final KitIcons icon;

  /// Its name.
  final String label;
}

/// The bottom bar of the app: duotone icons, the open tab in the accent.
class KitBottomNavigation extends StatelessWidget {
  /// Creates the bar with [tabs], [selectedIndex] open.
  const KitBottomNavigation({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  /// The tabs, left to right.
  final List<KitTab> tabs;

  /// Index of the open tab.
  final int selectedIndex;

  /// Called with the index of the tapped tab.
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final label = theme.textTheme.labelMedium;
    final labelHeight =
        MediaQuery.textScalerOf(context).scale(label?.fontSize ?? 13) *
        (label?.height ?? 18 / 13);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          // At larger text sizes allow two lines below the 24 px icon.
          height: math.max(80, 40 + 2 * labelHeight),
          child: Row(
            children: [
              for (final (index, tab) in tabs.indexed)
                Expanded(
                  child: _NavItem(
                    tab: tab,
                    selected: index == selectedIndex,
                    onTap: () => onSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final KitTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = StepfoldColors.of(context);
    final line = selected ? scheme.primary : scheme.onSurfaceVariant;
    final fill = scheme.primary.withValues(
      alpha: selected ? colors.iconFillSelected : colors.iconFillIdle,
    );
    return Semantics(
      selected: selected,
      button: true,
      label: tab.label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KitIcon(tab.icon, color: line, fillColor: fill),
            const SizedBox(height: 4),
            Text(
              tab.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: selected ? colors.primaryText : scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
