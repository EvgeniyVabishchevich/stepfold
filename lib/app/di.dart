import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get_it/get_it.dart';
import 'package:walks/app/firebase_options.dart';
import 'package:walks/app/implementations.dart';
import 'package:walks/data/repositories/crash/crashlytics_crash_reporter.dart';
import 'package:walks/data/repositories/crash/fake_crash_reporter.dart';
import 'package:walks/domain/repositories/crash_reporter.dart';

/// The container of the app's dependencies.
final GetIt getIt = GetIt.instance;

/// Registers every dependency of the app in [getIt], built from
/// [implementations].
///
/// Firebase is initialized only when a chosen implementation needs it, so
/// tests on fakes run without it. Repositories and services are lazy
/// singletons, blocs are factories.
Future<void> configureDependencies(Implementations implementations) async {
  if (implementations.usesFirebase) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  getIt.registerLazySingleton<CrashReporter>(
    () => switch (implementations.crashReporter) {
      CrashReporterImpl.fake => FakeCrashReporter(),
      CrashReporterImpl.crashlytics => CrashlyticsCrashReporter(
        FirebaseCrashlytics.instance,
      ),
    },
  );
}
