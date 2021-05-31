#import <UIKit/UIKit.h>
#import "EXHomeAppSplashScreenViewProvider.h"

@implementation EXHomeAppSplashScreenViewProvider

- (UIView *)createSplashScreenView
{
  UIView *view = [super createSplashScreenView];
  
  UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView *)[view viewWithTag:1];
  [activityIndicatorView startAnimating];
  
  return view;
}

@end
