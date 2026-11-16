import 'package:material_ui/material_ui.dart';

/// Stands in for a screen that is not built yet: shows its title.
class PlaceholderView extends StatelessWidget {
  /// Creates the placeholder.
  const PlaceholderView({
    required this.title,
    this.onTitleLongPress,
    super.key,
  });

  /// Name of the screen.
  final String title;

  /// Called on a long press on the title, if set.
  final VoidCallback? onTitleLongPress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onLongPress: onTitleLongPress,
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
      ),
    );
  }
}
