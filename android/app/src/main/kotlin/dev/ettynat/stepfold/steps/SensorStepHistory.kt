package dev.ettynat.stepfold.steps

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.SystemClock
import java.time.Instant
import java.time.ZoneId

/** History of steps observed while Stepfold was on screen. Runs on the main thread. */
internal class SensorStepHistory(context: Context) : SensorEventListener {
    private val sensors by lazy { context.getSystemService(Context.SENSOR_SERVICE) as SensorManager }
    private val counter by lazy { sensors.getDefaultSensor(Sensor.TYPE_STEP_COUNTER) }
    private val days by lazy { context.getSharedPreferences("step_sensor_days", Context.MODE_PRIVATE) }
    private var listening = false
    private var previousCount: Long? = null

    val isAvailable: Boolean get() = counter != null

    fun start(): Boolean {
        if (listening) return true
        val sensor = counter ?: return false
        listening = sensors.registerListener(this, sensor, SensorManager.SENSOR_DELAY_NORMAL)
        return listening
    }

    fun stop() {
        if (listening) sensors.unregisterListener(this)
        listening = false
        previousCount = null
    }

    fun readDays(fromDay: Long, toDay: Long): List<AndroidDayCount> =
        (fromDay..toDay).mapNotNull { day ->
            val count = days.getLong(day.toString(), -1)
            if (count < 0) null else AndroidDayCount(day, count)
        }

    override fun onSensorChanged(event: SensorEvent) {
        if (!listening) return
        val count = event.values[0].toLong()
        val previous = previousCount
        previousCount = count
        if (previous == null || count <= previous) return

        val sampleAgeMillis = (SystemClock.elapsedRealtimeNanos() - event.timestamp) / 1_000_000
        val sampleTime = Instant.ofEpochMilli(System.currentTimeMillis() - sampleAgeMillis)
        val key = sampleTime.atZone(ZoneId.systemDefault()).toLocalDate().toEpochDay().toString()
        days.edit().putLong(key, days.getLong(key, 0) + count - previous).apply()
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) = Unit
}
