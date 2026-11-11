import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    registerDebugChannel(engineBridge.pluginRegistry)
  }

  // Debug tools; the name matches MethodChannelNativeCrasher in Dart.
  private func registerDebugChannel(_ registry: FlutterPluginRegistry) {
    guard let registrar = registry.registrar(forPlugin: "StepfoldDebugChannel") else { return }
    let channel = FlutterMethodChannel(
      name: "dev.ettynat.stepfold/debug",
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "crash":
        result(nil)
        // fatalError is a trap, not an exception: nothing can catch it, so
        // unlike Android it would crash even inside the handler. Deferred only
        // to mirror MainActivity.kt.
        DispatchQueue.main.async {
          fatalError("Test native crash from the developer menu")
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
