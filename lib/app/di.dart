import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:walks/app/firebase_options.dart';
import 'package:walks/app/implementations.dart';
import 'package:walks/data/repositories/catalog/asset_catalog.dart';
import 'package:walks/data/repositories/catalog/fake_catalog.dart';
import 'package:walks/data/repositories/crash/crashlytics_crash_reporter.dart';
import 'package:walks/data/repositories/crash/fake_crash_reporter.dart';
import 'package:walks/data/repositories/permissions/fake_permission_service.dart';
import 'package:walks/data/repositories/progress/drift_progress_repository.dart';
import 'package:walks/data/repositories/progress/fake_progress_repository.dart';
import 'package:walks/data/repositories/steps/fake_step_source.dart';
import 'package:walks/data/services/method_channel_native_crasher.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/repositories/catalog.dart';
import 'package:walks/domain/repositories/crash_reporter.dart';
import 'package:walks/domain/repositories/native_crasher.dart';
import 'package:walks/domain/repositories/permission_service.dart';
import 'package:walks/domain/repositories/progress_repository.dart';
import 'package:walks/domain/repositories/step_source.dart';
import 'package:walks/domain/use_cases/add_manual_steps.dart';
import 'package:walks/domain/use_cases/buy_medal.dart';
import 'package:walks/domain/use_cases/open_chapter.dart';
import 'package:walks/domain/use_cases/set_goal.dart';
import 'package:walks/domain/use_cases/sync_steps.dart';

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

  // Only fakes so far; the real ones come in stage D, and with them a choice
  // in `Implementations`.
  getIt
    ..registerLazySingleton<PermissionService>(FakePermissionService.new)
    ..registerLazySingleton<StepSource>(FakeStepSource.new);

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
    ..registerFactory(() => SyncSteps(progress: getIt(), source: getIt()));

  getIt.registerLazySingleton<NativeCrasher>(MethodChannelNativeCrasher.new);
}
