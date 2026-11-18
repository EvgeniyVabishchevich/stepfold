import 'package:flutter/widgets.dart';

/// Calls back with a context below the page's providers when the app resumes.
class AppResumeListener extends StatefulWidget {
  /// Creates a listener that lives as long as [child].
  const AppResumeListener({
    required this.onResume,
    required this.child,
    super.key,
  });

  /// Handles app resume, with access to the inherited widgets.
  final ValueChanged<BuildContext> onResume;

  /// Content to display.
  final Widget child;

  @override
  State<AppResumeListener> createState() => _AppResumeListenerState();
}

class _AppResumeListenerState extends State<AppResumeListener> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onResume: () => widget.onResume(context));
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
