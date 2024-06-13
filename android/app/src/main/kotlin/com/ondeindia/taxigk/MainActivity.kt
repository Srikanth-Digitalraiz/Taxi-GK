package com.ondeindia.taxigk

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

     private val CHANNEL = "noti_channel" // replace with your channel name

    override fun configureFlutterEngine(bundle: FlutterEngine) {
        super.configureFlutterEngine(bundle)

        MethodChannel(bundle.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "showNotification") {
                    val pendingIntent = NotificationHelper.createPendingIntent(this)

                    // Use the pendingIntent for notification setup
                    // For simplicity, let's print the pendingIntent details
                    println("PendingIntent: $pendingIntent")

                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

}