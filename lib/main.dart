import 'package:flutter/material.dart';
import 'package:walks/app/app.dart';
import 'package:walks/app/di.dart';
import 'package:walks/app/error_handlers.dart';
import 'package:walks/app/implementations.dart';
import 'package:walks/domain/repositories/crash_reporter.dart';

// The order is forced: platform channels need the binding, Crashlytics needs
// Firebase, the handlers need the reporter. An error before the handlers are
// installed reaches only the console.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(chosenImplementations);

  final crashReporter = getIt<CrashReporter>();
  installErrorHandlers(crashReporter);
  for (final MapEntry(:key, :value)
      in chosenImplementations.asReportKeys.entries) {
    await crashReporter.setKey(key, value);
  }

  runApp(const StepfoldApp());
}
