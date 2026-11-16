import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/core/placeholder_view.dart';
import 'package:walks/ui/l10n/l10n.dart';

/// Layout of the Today tab. A placeholder until step C5b.
class TodayView extends StatelessWidget {
  /// Creates the view.
  const TodayView({this.onOpenDevMenu, super.key});

  /// Opens the developer menu; null where there is none.
  final VoidCallback? onOpenDevMenu;

  @override
  Widget build(BuildContext context) => PlaceholderView(
    title: context.l10n.tabToday,
    onTitleLongPress: onOpenDevMenu,
  );
}
