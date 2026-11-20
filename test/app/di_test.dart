import 'package:flutter_test/flutter_test.dart';
import 'package:walks/app/di.dart';
import 'package:walks/app/implementations.dart';
import 'package:walks/domain/domain.dart';

void main() {
  // On fakes: real SDKs cannot start in a unit test.
  setUp(() => configureDependencies(Implementations.fakes));
  tearDown(getIt.reset);

  // Resolving, not just isRegistered: factories run only when asked, so this
  // is what catches a missing dependency deeper in the graph.
  test('every dependency resolves', () async {
    await getIt.allReady();

    expect(getIt.get<CrashReporter>, returnsNormally);
    expect(getIt.get<NativeCrasher>, returnsNormally);
    expect(getIt.get<PermissionService>, returnsNormally);
    expect(getIt.get<StepSource>, returnsNormally);
    expect(getIt.get<Catalog>, returnsNormally);
    expect(getIt.get<ProgressRepository>, returnsNormally);
    expect(getIt.get<OpenChapter>, returnsNormally);
    expect(getIt.get<BuyMedal>, returnsNormally);
    expect(getIt.get<SetGoal>, returnsNormally);
    expect(getIt.get<AddManualSteps>, returnsNormally);
    expect(getIt.get<UpdateManualEntryLock>, returnsNormally);
    expect(getIt.get<SyncSteps>, returnsNormally);
  });
}
