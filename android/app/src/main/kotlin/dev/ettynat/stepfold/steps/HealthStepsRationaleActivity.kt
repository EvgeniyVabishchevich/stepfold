package dev.ettynat.stepfold.steps

import android.app.Activity
import android.app.AlertDialog
import android.os.Bundle
import dev.ettynat.stepfold.R

/** Opened by Health Connect from the permissions screen. */
class HealthStepsRationaleActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AlertDialog.Builder(this)
            .setTitle(R.string.health_steps_title)
            .setMessage(R.string.health_steps_rationale)
            .setPositiveButton(android.R.string.ok) { _, _ -> finish() }
            .setOnCancelListener { finish() }
            .show()
    }
}
