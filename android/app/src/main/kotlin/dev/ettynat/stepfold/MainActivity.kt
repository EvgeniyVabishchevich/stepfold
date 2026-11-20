package dev.ettynat.stepfold

import android.os.Handler
import android.os.Looper
import dev.ettynat.stepfold.steps.AndroidStepsApiRegistrar
import dev.ettynat.stepfold.steps.AndroidStepsHost
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val steps = AndroidStepsHost(this)
    private val stepsRegistrar = AndroidStepsApiRegistrar()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        stepsRegistrar.register(steps, flutterEngine)

        // Debug tools; the name matches MethodChannelNativeCrasher in Dart.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "dev.ettynat.stepfold/debug")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "crash" -> {
                        result.success(null)
                        // Thrown inside the handler, the exception would be caught by
                        // the channel and sent back to Dart as an error. Posted to the
                        // main looper, nothing catches it: a real crash.
                        Handler(Looper.getMainLooper()).post {
                            throw RuntimeException("Test native crash from the developer menu")
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        stepsRegistrar.unregister(steps, flutterEngine)
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
