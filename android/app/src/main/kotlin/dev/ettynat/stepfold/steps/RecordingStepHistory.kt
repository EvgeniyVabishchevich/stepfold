package dev.ettynat.stepfold.steps

import android.content.Context
import android.os.Build
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.fitness.FitnessLocal
import com.google.android.gms.fitness.LocalRecordingClient
import com.google.android.gms.fitness.data.LocalDataType
import com.google.android.gms.fitness.data.LocalField
import com.google.android.gms.fitness.request.LocalDataReadRequest
import java.io.IOException
import java.time.Clock
import java.time.Duration
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import java.util.concurrent.TimeUnit
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.withContext

/** Daily phone steps collected by the accountless Google Play services recorder. */
internal class RecordingStepHistory(
    private val context: Context,
    private val sensor: SensorStepHistory,
    private val clock: Clock = Clock.systemUTC(),
) {
    private val client by lazy { FitnessLocal.getLocalRecordingClient(context) }
    private val preferences by lazy {
        context.getSharedPreferences("step_recording", Context.MODE_PRIVATE)
    }
    private val startup = Mutex()
    private var subscribed = false
    private var rejected = false

    private val cutover: Instant?
        get() = preferences.getLong(CUTOVER, -1).takeIf { it >= 0 }?.let(Instant::ofEpochMilli)

    val hasCutover: Boolean get() = cutover != null

    val isAvailable: Boolean
        get() = Build.VERSION.SDK_INT >= 29 && !rejected &&
            GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(
                context,
                LocalRecordingClient.LOCAL_RECORDING_CLIENT_MIN_VERSION_CODE,
            ) == ConnectionResult.SUCCESS

    suspend fun start(): Boolean = startup.withLock {
        if (subscribed) return@withLock true
        if (!isAvailable) return@withLock false

        val firstStart = !hasCutover
        if (firstStart) {
            // Freeze the existing hardware totals before opening the new interval.
            // Persist the boundary first so a process death during subscribe
            // cannot move it past steps Play services has already recorded.
            sensor.stop()
            saveCutover(clock.instant())
        }
        try {
            client.subscribe(LocalDataType.TYPE_STEP_COUNT_DELTA).await()
        } catch (error: ApiException) {
            if (!firstStart || error.statusCode != ConnectionResult.API_UNAVAILABLE) throw error
            saveCutover(null)
            rejected = true
            return@withLock false
        }
        // Repeating subscribe after a process restart preserves an active subscription.
        subscribed = true
        true
    }

    suspend fun readDays(fromDay: Long, toDay: Long): List<AndroidDayCount> {
        val startedAt = checkNotNull(cutover)
        val now = clock.instant()
        val zone = ZoneId.systemDefault()
        return (fromDay..toDay).mapNotNull { day ->
            val date = LocalDate.ofEpochDay(day)
            val dayStart = date.atStartOfDay(zone).toInstant()
            val dayEnd = minOf(date.plusDays(1).atStartOfDay(zone).toInstant(), now)
            val prior = sensor.countOn(day)
            if (dayEnd <= startedAt) return@mapNotNull prior?.let { AndroidDayCount(day, it) }

            val start = completeRecordingStart(dayStart, dayEnd, startedAt, now)
                ?: return@mapNotNull null
            val recorded = readTotal(start, dayEnd) ?: return@mapNotNull null
            AndroidDayCount(day, (prior ?: 0) + recorded)
        }
    }

    private suspend fun readTotal(start: Instant, end: Instant): Long? {
        val request = LocalDataReadRequest.Builder()
            .aggregate(LocalDataType.TYPE_STEP_COUNT_DELTA)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(start.toEpochMilli(), end.toEpochMilli(), TimeUnit.MILLISECONDS)
            .build()
        val result = client.readData(request).await()
        var total: Long? = null
        for (bucket in result.buckets) {
            for (dataSet in bucket.dataSets) {
                for (point in dataSet.dataPoints) {
                    total = (total ?: 0) + point.getValue(LocalField.FIELD_STEPS).asInt()
                }
            }
        }
        return total
    }

    private suspend fun saveCutover(value: Instant?) = withContext(Dispatchers.IO) {
        val edit = preferences.edit()
        if (value == null) edit.remove(CUTOVER) else edit.putLong(CUTOVER, value.toEpochMilli())
        if (!edit.commit()) throw IOException("Could not save the recording start time")
    }

    private companion object {
        const val CUTOVER = "started_at"
    }
}

/** A truncated historical day must not replace a complete total in Drift. */
internal fun completeRecordingStart(
    dayStart: Instant,
    dayEnd: Instant,
    cutover: Instant,
    now: Instant,
): Instant? {
    val start = maxOf(dayStart, cutover)
    return start.takeIf {
        it >= now.minus(Duration.ofDays(10)) && it.toEpochMilli() < dayEnd.toEpochMilli()
    }
}
