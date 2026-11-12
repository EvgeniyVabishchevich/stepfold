import 'package:flutter/services.dart';
import 'package:walks/domain/repositories/native_crasher.dart';

/// A [NativeCrasher] that asks the platform code over a method channel.
///
/// Android throws a `RuntimeException` on the main thread, iOS calls
/// `fatalError`: both are crashes any crash reporting SDK catches.
class MethodChannelNativeCrasher implements NativeCrasher {
  /// Creates a crasher on the app's debug channel.
  const MethodChannelNativeCrasher();

  /// The channel name; the same string is in MainActivity.kt and
  /// AppDelegate.swift.
  static const channel = MethodChannel('dev.ettynat.stepfold/debug');

  @override
  Future<void> crash() => channel.invokeMethod<void>('crash');
}
