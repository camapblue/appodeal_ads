#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    __block AppDelegate* safeSelf = self;
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
        // Tracking authorization completed. Initialise Appodeal here.
        [GeneratedPluginRegistrant registerWithRegistry: safeSelf];
    }];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
