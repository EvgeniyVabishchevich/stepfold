import 'package:flutter/material.dart';
import 'package:walks/app/app.dart';
import 'package:walks/app/di.dart';
import 'package:walks/app/error_handlers.dart';
import 'package:walks/app/implementations.dart';
import 'package:walks/domain/repositories/crash_reporter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  final crashReporter = getIt<CrashReporter>();
  installErrorHandlers(crashReporter);
  for (final MapEntry(:key, :value) in chosenImplementations.entries) {
    await crashReporter.setKey(key, value);
  }

  runApp(const StepfoldApp());
}
