// Copyright © 2018 650 Industries. All rights reserved.

#import <EXSplashScreen/EXSplashScreenViewNativeProvider.h>
#import "EXSplashScreenViewContainer.h"
#import <UMCore/UMLogManager.h>

@implementation EXSplashScreenViewNativeProvider

- (nonnull EXSplashScreenViewContainer *)createSplashScreenView
{
  NSString *splashScreenFilename = (NSString *)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"UILaunchStoryboardName"] ?: @"SplashScreen";
  UIStoryboard *storyboard;
  @try {
    storyboard = [UIStoryboard storyboardWithName:splashScreenFilename bundle:[NSBundle mainBundle]];
  } @catch (NSException *_) {
    UMLogWarn([NSString stringWithFormat:@"'%@.storyboard' file is missing. Fallbacking to '%@.xib' file.", splashScreenFilename, splashScreenFilename]);
  }
  if (storyboard) {
    @try {
      UIViewController *splashScreenViewController = [storyboard instantiateInitialViewController];
      UIView *splashScreenView = splashScreenViewController.view;
      EXSplashScreenViewContainer *viewContainer = [[EXSplashScreenViewContainer alloc] initWithView:splashScreenView andContext:EXSplashScreenBare];
      return viewContainer;
    } @catch (NSException *_) {
      @throw [NSException exceptionWithName:@"ERR_INVALID_SPLASH_SCREEN"
                                     reason:[NSString stringWithFormat:@"'%@.storyboard'does not contain proper ViewController. Add correct ViewController to your '%@.storyboard' file (https://github.com/expo/expo/tree/master/packages/expo-splash-screen#-configure-ios).", splashScreenFilename, splashScreenFilename]
                                   userInfo:nil];
    }
  }
  
  NSArray *views;
  @try {
    views = [[NSBundle mainBundle] loadNibNamed:splashScreenFilename owner:self options:nil];
  } @catch (NSException *_) {
    UMLogWarn([NSString stringWithFormat:@"'%@.xib' file is missing - 'expo-splash-screen' will not work as expected.", splashScreenFilename]);
  }
  if (views) {
    if (!views.firstObject) {
      @throw [NSException exceptionWithName:@"ERR_INVALID_SPLASH_SCREEN"
                                     reason:[NSString stringWithFormat:@"'%@.xib' does not contain any views. Add a view to the '%@.xib' or create '%@.storyboard' (https://github.com/expo/expo/tree/master/packages/expo-splash-screen#-configure-ios).", splashScreenFilename, splashScreenFilename, splashScreenFilename]
                                   userInfo:nil];
    }
    UIView *view = views.firstObject;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    EXSplashScreenViewContainer *viewContainer = [[EXSplashScreenViewContainer alloc] initWithView:view andContext:EXSplashScreenBare];
    return viewContainer;
  }
  
  @throw [NSException exceptionWithName:@"ERR_NO_SPLASH_SCREEN"
                                 reason:[NSString stringWithFormat:@"Couln't locate neither '%@.storyboard' file nor '%@.xib' file. Create one of these in the project to make 'expo-splash-screen' work (https://github.com/expo/expo/tree/master/packages/expo-splash-screen#-configure-ios).", splashScreenFilename, splashScreenFilename]
                               userInfo:nil];
}

@end
