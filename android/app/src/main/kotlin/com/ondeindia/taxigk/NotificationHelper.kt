import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity

class NotificationHelper {

    companion object {
        fun createPendingIntent(context: Context): PendingIntent {
            val intent = Intent(context, FlutterActivity::class.java)

            // Set flags based on Android version
            val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.FLAG_MUTABLE
            } else {
                0
            }

            return PendingIntent.getActivity(context, 0, intent, flags)
        }
    }
}