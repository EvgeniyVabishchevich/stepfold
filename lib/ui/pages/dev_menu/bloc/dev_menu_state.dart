import 'package:freezed_annotation/freezed_annotation.dart';

part 'dev_menu_state.freezed.dart';

/// An action in the developer menu.
sealed class DevMenuEvent {
  const DevMenuEvent();
}

/// A test error the developer menu can produce.
enum DevMenuAction implements DevMenuEvent {
  /// Sends a non-fatal report by hand.
  nonFatal,

  /// Sends a test error through the framework's fatal handler.
  frameworkError,

  /// Leaves an asynchronous error for the platform handler.
  asyncError,

  /// Crashes the native side.
  nativeCrash,
}

/// Credits the current day with an additional manual step count.
final class DevAddSteps extends DevMenuEvent {
  /// Creates a request to credit [steps].
  const DevAddSteps(this.steps);

  /// The amount to add.
  final int steps;
}

/// The result of the last attempt to save steps.
enum DevStepAddition {
  /// No addition has been requested yet.
  idle,

  /// A write is in progress.
  saving,

  /// The steps were saved.
  added,

  /// The steps could not be saved.
  failed,

  /// Storage is full.
  storageFull,
}

/// The last action requested in the developer menu.
@freezed
abstract class DevMenuState with _$DevMenuState {
  /// Creates a state with no action recorded by default.
  const factory DevMenuState({
    DevMenuAction? lastAction,
    @Default(DevStepAddition.idle) DevStepAddition stepAddition,
  }) = _DevMenuState;
}
