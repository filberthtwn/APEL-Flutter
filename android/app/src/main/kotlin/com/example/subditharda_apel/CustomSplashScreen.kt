package com.subditharda.apel

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import androidx.annotation.Nullable
import com.subditharda.apel.R
import io.flutter.embedding.android.SplashScreen


public class CustomSplashScreen : SplashScreen {
    @Nullable
    override fun createSplashView(context: Context, @Nullable savedInstanceState: Bundle?): View {
        return LayoutInflater.from(context).inflate(R.layout.launch_screen, null, false)
    }

    override fun transitionToFlutter(onTransitionComplete: Runnable) {
        onTransitionComplete.run()
    }
}