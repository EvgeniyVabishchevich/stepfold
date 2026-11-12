import 'package:flutter_test/flutter_test.dart';
import 'package:walks/app/di.dart';
import 'package:walks/app/implementations.dart';
import 'package:walks/domain/repositories/catalog.dart';
import 'package:walks/domain/repositories/crash_reporter.dart';
import 'package:walks/domain/repositories/native_crasher.dart';
import 'package:walks/domain/repositories/permission_service.dart';
import 'package:walks/domain/repositories/step_source.dart';
import 'package:walks/ui/dev_menu/bloc/dev_menu_cubit.dart';

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
    expect(getIt.get<DevMenuCubit>, returnsNormally);
  });
}
