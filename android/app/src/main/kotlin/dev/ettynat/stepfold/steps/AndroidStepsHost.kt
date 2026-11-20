package dev.ettynat.stepfold.steps

import android.Manifest
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.PermissionController
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.StepsRecord
import androidx.health.connect.client.request.AggregateRequest
import androidx.health.connect.client.time.TimeRangeFilter
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import com.google.android.gms.common.api.ApiException
import java.io.IOException
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

internal class AndroidStepsHost(private val activity: FragmentActivity) :
    AndroidStepsApi, DefaultLifecycleObserver {
    private val history = SensorStepHistory(activity)
    private val recording by lazy { RecordingStepHistory(activity.applicationContext, history) }
    private val preferences by lazy {
        activity.getSharedPreferences("step_permission_requests", Context.MODE_PRIVATE)
    }
    private val readSteps = HealthPermission.getReadPermission(StepsRecord::class)
    private val health by lazy { HealthConnectClient.getOrCreate(activity.applicationContext) }
    private var observeSensor = false
    private var pendingRequest: CompletableDeferred<Unit>? = null

    private val askForActivity = activity.registerForActivityResult(
        ActivityResultContracts.RequestPermission(),
    ) { pendingRequest?.complete(Unit) }

    private val askForHealth = activity.registerForActivityResult(
        PermissionController.createRequestPermissionResultContract(),
    ) { pendingRequest?.complete(Unit) }

    init {
        activity.lifecycle.addObserver(this)
    }

    override fun onResume(owner: LifecycleOwner) {
        if (observeSensor && hasActivityPermission()) history.start()
    }

    override fun onPause(owner: LifecycleOwner) {
        history.stop()
    }

    override fun onDestroy(owner: LifecycleOwner) {
        pendingRequest?.cancel()
    }

    override suspend fun status(provider: AndroidStepProvider): AndroidStepPermission =
        onMain { permissionStatus(provider) }

    override suspend fun request(provider: AndroidStepProvider): AndroidStepPermission = onMain {
        val current = permissionStatus(provider)
        if (current != AndroidStepPermission.CAN_REQUEST) return@onMain current
        val inFlight = pendingRequest
        if (inFlight != null) {
            inFlight.await()
            return@onMain permissionStatus(provider)
        }

        val result = CompletableDeferred<Unit>()
        pendingRequest = result
        try {
            when (provider) {
                AndroidStepProvider.HEALTH_CONNECT -> askForHealth.launch(setOf(readSteps))
                AndroidStepProvider.SENSOR -> askForActivity.launch(Manifest.permission.ACTIVITY_RECOGNITION)
            }
            result.await()
            preferences.edit().putBoolean(provider.name, true).apply()
            permissionStatus(provider)
        } finally {
            pendingRequest = null
        }
    }

    override suspend fun openSettings(provider: AndroidStepProvider) = onMain {
        val appSettings = Intent(
            Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
            Uri.fromParts("package", activity.packageName, null),
        )
        if (provider == AndroidStepProvider.HEALTH_CONNECT) {
            try {
                activity.startActivity(Intent(HealthConnectClient.ACTION_HEALTH_CONNECT_SETTINGS))
                return@onMain
            } catch (_: ActivityNotFoundException) {
                // Some Android variants expose only the app settings screen.
            } catch (_: SecurityException) {
                // The system can restrict access to the health settings.
            }
        }
        activity.startActivity(appSettings)
    }

    override suspend fun readDays(
        provider: AndroidStepProvider,
        fromDay: Long,
        toDay: Long,
    ): List<AndroidDayCount> = onMain {
        when (permissionStatus(provider)) {
            AndroidStepPermission.GRANTED -> Unit
            AndroidStepPermission.UNAVAILABLE -> throw FlutterError("step-source-unavailable")
            else -> throw FlutterError("step-permission-denied")
        }
        when (provider) {
            AndroidStepProvider.HEALTH_CONNECT -> readHealthDays(fromDay, toDay)
            AndroidStepProvider.SENSOR -> {
                if (recording.isAvailable) {
                    observeSensor = false
                    if (recording.start()) {
                        return@onMain recording.readDays(fromDay, toDay)
                    }
                }
                if (recording.hasCutover) throw FlutterError("step-source-unavailable")
                observeSensor = true
                if (activity.lifecycle.currentState.isAtLeast(Lifecycle.State.RESUMED) && !history.start()) {
                    throw FlutterError("step-source-unavailable")
                }
                history.readDays(fromDay, toDay)
            }
        }
    }

    private suspend fun permissionStatus(provider: AndroidStepProvider): AndroidStepPermission {
        val requested = preferences.getBoolean(provider.name, false)
        return when (provider) {
            AndroidStepProvider.HEALTH_CONNECT -> when {
                HealthConnectClient.getSdkStatus(activity) != HealthConnectClient.SDK_AVAILABLE ->
                    AndroidStepPermission.UNAVAILABLE
                readSteps in health.permissionController.getGrantedPermissions() -> AndroidStepPermission.GRANTED
                requested -> AndroidStepPermission.BLOCKED
                else -> AndroidStepPermission.CAN_REQUEST
            }
            AndroidStepProvider.SENSOR -> when {
                !recording.isAvailable && (recording.hasCutover || !history.isAvailable) ->
                    AndroidStepPermission.UNAVAILABLE
                hasActivityPermission() -> AndroidStepPermission.GRANTED
                !requested || activity.shouldShowRequestPermissionRationale(Manifest.permission.ACTIVITY_RECOGNITION) ->
                    AndroidStepPermission.CAN_REQUEST
                else -> AndroidStepPermission.BLOCKED
            }
        }
    }

    private fun hasActivityPermission(): Boolean =
        Build.VERSION.SDK_INT < 29 ||
            ContextCompat.checkSelfPermission(activity, Manifest.permission.ACTIVITY_RECOGNITION) ==
            PackageManager.PERMISSION_GRANTED

    private suspend fun readHealthDays(fromDay: Long, toDay: Long): List<AndroidDayCount> {
        val zone = ZoneId.systemDefault()
        val now = Instant.now()
        return (fromDay..toDay).mapNotNull { day ->
            val date = LocalDate.ofEpochDay(day)
            val start = date.atStartOfDay(zone).toInstant()
            val end = minOf(now, date.plusDays(1).atStartOfDay(zone).toInstant())
            if (start >= end) return@mapNotNull null
            val result = health.aggregate(
                AggregateRequest(
                    metrics = setOf(StepsRecord.COUNT_TOTAL),
                    timeRangeFilter = TimeRangeFilter.between(start, end),
                ),
            )
            result[StepsRecord.COUNT_TOTAL]?.let { AndroidDayCount(day, it) }
        }
    }

    private suspend fun <T> onMain(block: suspend () -> T): T = withContext(Dispatchers.Main.immediate) {
        try {
            block()
        } catch (error: CancellationException) {
            throw error
        } catch (error: SecurityException) {
            throw FlutterError("step-permission-denied", error.message)
        } catch (error: ApiException) {
            val code = if (hasActivityPermission()) "step-source-unavailable" else "step-permission-denied"
            throw FlutterError(code, error.message)
        } catch (error: IOException) {
            throw FlutterError("step-source-unavailable", error.message)
        } catch (error: IllegalStateException) {
            throw FlutterError("step-source-unavailable", error.message)
        } catch (error: ActivityNotFoundException) {
            throw FlutterError("step-source-unavailable", error.message)
        }
    }
}
