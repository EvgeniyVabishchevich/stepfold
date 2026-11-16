import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/core/routes.dart';
import 'package:walks/ui/dev_menu/dev_menu_page.dart';
import 'package:walks/ui/today/today_view.dart';

/// The Today tab: gives [TodayView] what it needs.
class TodayPage extends StatelessWidget {
  /// Creates the page.
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    // A long press on the title opens the developer menu until settings
    // exist, where the version label will take this over.
    return TodayView(
      onOpenDevMenu: devMenuEnabled ? () => context.push(Routes.devMenu) : null,
    );
  }
}
