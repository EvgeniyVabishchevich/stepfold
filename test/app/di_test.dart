import 'package:flutter_test/flutter_test.dart';
import 'package:walks/app/di.dart';
import 'package:walks/app/implementations.dart';
import 'package:walks/domain/repositories/crash_reporter.dart';

void main() {
  // On fakes: real SDKs cannot start in a unit test.
  setUp(() => configureDependencies(Implementations.fakes));
  tearDown(getIt.reset);

  // Resolving, not just isRegistered: factories run only when asked, so this
  // is what catches a missing dependency deeper in the graph.
  test('every dependency resolves', () async {
    await getIt.allReady();

    expect(getIt.get<CrashReporter>, returnsNormally);
  });
}
