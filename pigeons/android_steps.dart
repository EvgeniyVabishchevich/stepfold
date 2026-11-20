// Regenerate with: fvm dart run pigeon --input pigeons/android_steps.dart

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    appDirectory: '.',
    dartOut: 'lib/data/repositories/steps/android_steps.g.dart',
    kotlinOut:
        'android/app/src/main/kotlin/dev/ettynat/stepfold/steps/AndroidSteps.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'dev.ettynat.stepfold.steps',
      useJni: true,
    ),
  ),
)
enum AndroidStepProvider { healthConnect, sensor }

enum AndroidStepPermission { granted, canRequest, blocked, unavailable }

class AndroidDayCount {
  AndroidDayCount({required this.day, required this.steps});

  int day;
  int steps;
}

@HostApi()
abstract class AndroidStepsApi {
  @async
  AndroidStepPermission status(AndroidStepProvider provider);

  @async
  AndroidStepPermission request(AndroidStepProvider provider);

  @async
  void openSettings(AndroidStepProvider provider);

  @async
  List<AndroidDayCount> readDays(
    AndroidStepProvider provider,
    int fromDay,
    int toDay,
  );
}
