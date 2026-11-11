import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/crash/fake_crash_reporter.dart';

import '../../../contracts/crash_reporter_contract.dart';

void main() {
  crashReporterContract(FakeCrashReporter.new);

  group('FakeCrashReporter', () {
    late FakeCrashReporter reporter;

    setUp(() => reporter = FakeCrashReporter(maxTrailLength: 3));

    test('records the error with its flags', () async {
      final error = StateError('boom');
      await reporter.recordError(
        error,
        null,
        fatal: true,
        reason: 'unlock chapter',
      );

      final recorded = reporter.errors.single;
      expect(recorded.error, same(error));
      expect(recorded.fatal, isTrue);
      expect(recorded.reason, 'unlock chapter');
    });

    test('attaches the trail, user and keys current at the moment', () async {
      reporter.log('[catalog] opened');
      await reporter.setUserId('user-1');
      await reporter.setKey('pro', true);
      await reporter.recordError('first', null);

      reporter.log('[chapter] unlock tapped');
      await reporter.setUserId(null);
      await reporter.recordError('second', null);

      final [first, second] = reporter.errors;
      expect(first.trail, ['[catalog] opened']);
      expect(first.userId, 'user-1');
      expect(first.keys, {'pro': true});
      expect(second.trail, ['[catalog] opened', '[chapter] unlock tapped']);
      expect(second.userId, isNull);
    });

    test('keeps only the last messages of the trail', () async {
      for (var i = 1; i <= 5; i++) {
        reporter.log('m$i');
      }
      await reporter.recordError('boom', null);

      expect(reporter.errors.single.trail, ['m3', 'm4', 'm5']);
    });
  });
}
