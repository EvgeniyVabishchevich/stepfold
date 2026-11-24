import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit_icon.dart';
import 'package:walks/ui/kit/kit_surface.dart';
import 'package:walks/ui/theme/theme.dart';

const _labelSize = 11.0;

/// An icon and label for one destination in [KitBottomNavigation].
class KitTab {
  /// Creates the tab.
  const KitTab({required this.icon, required this.label});

  /// Its symbol.
  final KitIcons icon;

  /// Its accessible label.
  final String label;
}

/// A raised bar with the current tab recessed into its surface.
class KitBottomNavigation extends StatelessWidget {
  /// Creates the bar with [selectedIndex] open.
  const KitBottomNavigation({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  /// The destinations in navigation order.
  final List<KitTab> tabs;

  /// Index of the open tab.
  final int selectedIndex;

  /// Called with the index of the tapped tab.
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final singleLine =
        MediaQuery.textScalerOf(context).scale(_labelSize) <= _labelSize;
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, tab) in tabs.indexed)
          Expanded(
            child: _NavItem(
              tab: tab,
              selected: index == selectedIndex,
              singleLine: singleLine,
              onTap: () => onSelected(index),
            ),
          ),
      ],
    );
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(10, 4, 10, 2),
      child: KitSurface(
        padding: const EdgeInsets.fromLTRB(
          Spacing.s4,
          Spacing.s4,
          Spacing.s4,
          2,
        ),
        // The fitted labels use one line. Intrinsic measurement can reserve
        // space for wrapping before they are fitted into their tab widths.
        child: singleLine
            ? SizedBox(height: 55, child: row)
            : IntrinsicHeight(child: row),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.selected,
    required this.singleLine,
    required this.onTap,
  });

  final KitTab tab;
  final bool selected;
  final bool singleLine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = KitRelief.of(context);
    final foreground = selected
        ? colors.accent
        : theme.colorScheme.onSurfaceVariant;
    final labelStyle = theme.textTheme.labelMedium?.copyWith(
      color: foreground,
      fontSize: _labelSize,
      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
    );
    final label = Text(
      tab.label,
      textAlign: TextAlign.center,
      style: labelStyle,
      maxLines: singleLine ? 1 : null,
    );
    const corners = BorderRadius.all(Radius.circular(16));
    return Semantics(
      selected: selected,
      button: true,
      label: tab.label,
      excludeSemantics: true,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            if (selected)
              const Positioned.fill(
                child: KitSurface(
                  kind: KitSurfaceKind.recessed,
                  padding: EdgeInsets.zero,
                  child: SizedBox.expand(),
                ),
              ),
            Material(
              color: Colors.transparent,
              borderRadius: corners,
              child: InkWell(
                borderRadius: corners,
                onTap: onTap,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.s4,
                      vertical: 6,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: Spacing.s4,
                      children: [
                        KitIcon(tab.icon, size: 23, color: foreground),
                        if (singleLine)
                          FittedBox(fit: BoxFit.scaleDown, child: label)
                        else
                          label,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
