package dev.ettynat.stepfold.steps

import java.time.Instant
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class RecordingStepHistoryTest {
    private val now = Instant.parse("2026-11-20T12:00:00Z")

    @Test
    fun firstRecordingDayReadsOnlyTheIntervalAfterTheHardwareHistory() {
        val midnight = Instant.parse("2026-11-20T00:00:00Z")
        val cutover = Instant.parse("2026-11-20T09:00:00Z")
        assertEquals(cutover, completeRecordingStart(midnight, now, cutover, now))
    }

    @Test
    fun expiredPartOfAFormerDayDoesNotOverwriteItsCompleteTotal() {
        val dayStart = Instant.parse("2026-11-10T00:00:00Z")
        val dayEnd = Instant.parse("2026-11-11T00:00:00Z")
        assertNull(completeRecordingStart(dayStart, dayEnd, dayStart, now))
    }

    @Test
    fun daysFullyWithinRetentionReadFromLocalMidnight() {
        val cutover = Instant.parse("2026-11-04T08:00:00Z")
        val dayStart = Instant.parse("2026-11-18T23:00:00Z")
        val dayEnd = Instant.parse("2026-11-19T23:00:00Z")
        assertEquals(dayStart, completeRecordingStart(dayStart, dayEnd, cutover, now))
    }
}
