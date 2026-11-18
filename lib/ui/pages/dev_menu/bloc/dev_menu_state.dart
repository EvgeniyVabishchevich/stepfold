import 'package:freezed_annotation/freezed_annotation.dart';

part 'dev_menu_state.freezed.dart';

/// A test error the developer menu can produce.
enum DevMenuAction {
  /// Sends a non-fatal report by hand.
  nonFatal,

  /// Sends a test error through the framework's fatal handler.
  frameworkError,

  /// Leaves an asynchronous error for the platform handler.
  asyncError,

  /// Crashes the native side.
  nativeCrash,
}

/// The last action requested in the developer menu.
@freezed
abstract class DevMenuState with _$DevMenuState {
  /// Creates a state with no action recorded by default.
  const factory DevMenuState({DevMenuAction? lastAction}) = _DevMenuState;
}
