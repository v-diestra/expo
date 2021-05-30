package host.exp.exponent.experience.splashscreen

import android.content.Context
import expo.modules.splashscreen.SplashScreenView
import expo.modules.splashscreen.SplashScreenViewContainer
import expo.modules.splashscreen.SplashScreenViewContext
import expo.modules.splashscreen.SplashScreenViewProvider

class HomeSplashScreenViewProvider () : SplashScreenViewProvider {
    private lateinit var splashScreenView: SplashScreenView

    override fun createSplashScreenView(context: Context): SplashScreenViewContainer {
        splashScreenView = SplashScreenView(context)

        var viewContainer = SplashScreenViewContainer()
        viewContainer.view = splashScreenView
        viewContainer.context = SplashScreenViewContext.HOME

        return viewContainer
    }
}
