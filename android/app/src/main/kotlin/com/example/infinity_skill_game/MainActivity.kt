package com.example.infinity_skill_game

import android.content.pm.ActivityInfo
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // sensorLandscape allows flipping between landscapeLeft and landscapeRight
        // based on the device sensor (unlike USER_LANDSCAPE from Flutter SystemChrome).
        requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE
    }
}
