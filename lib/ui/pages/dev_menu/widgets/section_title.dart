import 'package:material_ui/material_ui.dart';

/// Labels a group of actions in the developer menu.
class DevMenuSectionTitle extends StatelessWidget {
  /// Creates a heading with the given [text].
  const DevMenuSectionTitle(this.text, {super.key});

  /// The heading text.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
