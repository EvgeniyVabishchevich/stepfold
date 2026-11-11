import 'package:get_it/get_it.dart';
import 'package:walks/app/implementations.dart';
import 'package:walks/data/repositories/crash/fake_crash_reporter.dart';
import 'package:walks/domain/repositories/crash_reporter.dart';

/// The container of the app's dependencies.
final GetIt getIt = GetIt.instance;

/// Registers every dependency of the app in [getIt].
///
/// The implementation of each area is chosen with a `switch` over its
/// constant in `implementations.dart`. Repositories and services are lazy
/// singletons, blocs are factories.
Future<void> configureDependencies() async {
  getIt.registerLazySingleton<CrashReporter>(
    () => switch (crashReporterImpl) {
      CrashReporterImpl.fake => FakeCrashReporter(),
    },
  );
}
