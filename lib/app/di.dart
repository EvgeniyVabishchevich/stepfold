import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:walks/app/firebase_options.dart';
import 'package:walks/app/implementations.dart';
import 'package:walks/data/data.dart';
import 'package:walks/domain/domain.dart';

/// The container of the app's dependencies.
final GetIt getIt = GetIt.instance;

/// Registers every dependency of the app in [getIt], built from
/// [implementations].
///
/// Firebase is initialized only when a chosen implementation needs it, so
/// tests on fakes run without it. Repositories and services are lazy
/// singletons, use cases are factories.
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

  getIt.registerLazySingleton<Catalog>(
    () => switch (implementations.catalog) {
      CatalogImpl.fake => FakeCatalog(),
      CatalogImpl.assets => AssetCatalog(rootBundle),
    },
  );

  final stepsImpl = implementations.activeSteps;
  final androidSteps = stepsImpl == StepsImpl.fake
      ? null
      : AndroidStepsApi.createWithNativeInteropApi();
  final stepSource = switch (stepsImpl) {
    StepsImpl.fake => FakeStepSource(),
    StepsImpl.androidAutomatic => await AndroidStepSource.select(androidSteps!),
    StepsImpl.androidHealthConnect => AndroidStepSource.healthConnect(
      androidSteps!,
    ),
    StepsImpl.androidSensor => AndroidStepSource.sensor(androidSteps!),
  };
  getIt
    ..registerSingleton<StepSource>(stepSource)
    ..registerLazySingleton<PermissionService>(
      () => androidSteps == null
          ? FakePermissionService()
          : AndroidPermissionService(
              androidSteps,
              stepSource.requiredPermission,
            ),
    );

  getIt.registerLazySingleton<ProgressRepository>(
    () => switch (implementations.progress) {
      ProgressImpl.fake => FakeProgressRepository.installedOn(Day.today()),
      ProgressImpl.drift => DriftProgressRepository.onDevice(),
    },
  );

  // Use cases hold no state of their own: a new one each time.
  getIt
    ..registerFactory(() => OpenChapter(getIt()))
    ..registerFactory(() => BuyMedal(getIt()))
    ..registerFactory(() => SetGoal(getIt()))
    ..registerFactory(() => AddManualSteps(getIt()))
    ..registerFactory(() => UpdateManualEntryLock(getIt()))
    ..registerFactory(() => SyncSteps(progress: getIt(), source: getIt()));

  getIt.registerLazySingleton<NativeCrasher>(MethodChannelNativeCrasher.new);
}
