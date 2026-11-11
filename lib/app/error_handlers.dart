import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:walks/domain/repositories/crash_reporter.dart';

/// Sends every error nobody else handled to [reporter].
///
/// Errors the framework caught in build, layout or paint are fatal: the user
/// sees a broken screen. Uncaught async errors are non-fatal by default;
/// important scenarios catch their errors on the spot and choose for
/// themselves.
void installErrorHandlers(CrashReporter reporter) {
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    previousOnError?.call(details);
    unawaited(
      reporter.recordError(
        details.exception,
        details.stack,
        fatal: true,
        reason: details.context?.toDescription(),
      ),
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    unawaited(reporter.recordError(error, stack));
    return true;
  };
}
