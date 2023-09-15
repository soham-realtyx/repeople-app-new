package com.totality.repeople
import android.app.Application
import com.moengage.core.DataCenter
//import com.facebook.appevents.AppEventsLogger
import io.flutter.embedding.android.FlutterActivity
import com.moengage.core.LogLevel
import com.moengage.core.MoEngage
import com.moengage.core.config.FcmConfig
import com.moengage.core.config.LogConfig
import com.moengage.core.config.NotificationConfig
import com.moengage.core.config.PushKitConfig
import com.moengage.flutter.MoEInitializer

class MainApplication: Application() {
    lateinit var moEngage: MoEngage.Builder
    //  val logger: AppEventsLogger = AppEventsLogger.newLogger(this)
    companion object {
        lateinit var application: Application
    }

    override fun onCreate() {
        super.onCreate()
        //val logger: AppEventsLogger = AppEventsLogger.newLogger(this)
        moEngage = MoEngage.Builder(this, "RNC6FLAC6WO5DC9329DDPT76",)
        moEngage.configureLogs( LogConfig(LogLevel.VERBOSE, true))
            .configureNotificationMetaData(NotificationConfig(
                R.drawable.app_icon,
                R.drawable.app_icon,
                notificationColor = -1,
                isMultipleNotificationInDrawerEnabled = false,
                isBuildingBackStackEnabled = true,
                isLargeIconDisplayEnabled = false
            ))
            .configureFcm(FcmConfig(true))
            .configurePushKit(PushKitConfig(true))
            .setDataCenter(DataCenter.DATA_CENTER_1)
        MoEInitializer.initialiseDefaultInstance(this, moEngage)
//        logger.logEvent("App Open")
    }
//    fun logAppOpenEvent() {
//        logger.logEvent("App Open")
//    }
}