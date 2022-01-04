package com.subditharda.apel

import androidx.annotation.Nullable
import io.flutter.embedding.android.FlutterActivity
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import io.flutter.embedding.android.SplashScreen

class MainActivity: FlutterActivity() {
    @Nullable
    override fun provideSplashScreen(): SplashScreen? {
        return CustomSplashScreen()
    }
}
