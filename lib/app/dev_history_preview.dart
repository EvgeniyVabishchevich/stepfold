import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:walks/data/data.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/pages/history/history.dart';

/// Owns a short-lived SQLite database for the developer history preview.
class DevHistoryPreview extends StatefulWidget {
  /// Creates the preview with the app's crash reporter.
  const DevHistoryPreview({
    required this.crashReporter,
    required this.catalog,
    super.key,
  });

  /// Reports storage errors from the preview.
  final CrashReporter crashReporter;

  /// Catalog used by the history screen.
  final Catalog catalog;

  @override
  State<DevHistoryPreview> createState() => _DevHistoryPreviewState();
}

class _DevHistoryPreviewState extends State<DevHistoryPreview> {
  late final DriftProgressRepository _progress;

  @override
  void initState() {
    super.initState();
    final first = Day.today() - 999;
    _progress = DriftProgressRepository.memory(
      installDay: first,
      initialDays: [
        for (var i = 0; i < 1000; i++)
          DayCount(day: first + i, steps: 1500 + (i * 7919) % 12500),
      ],
    );
  }

  @override
  void dispose() {
    unawaited(_progress.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HistoryPage(
    progress: _progress,
    catalog: widget.catalog,
    addManualSteps: AddManualSteps(_progress),
    updateLock: UpdateManualEntryLock(_progress),
    crashReporter: widget.crashReporter,
    preview: true,
  );
}
