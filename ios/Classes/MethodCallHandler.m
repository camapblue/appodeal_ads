#import "MethodCallHandler.h"
#import <Appodeal/Appodeal.h>

@implementation MethodCallHandler {
  FlutterMethodChannel *_channel;
}

- (instancetype )initMethodCallHandlerByMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _channel = [FlutterMethodChannel methodChannelWithName:@"flutter_appodeal" binaryMessenger:messenger];
    }
    return self;
}

- (FlutterMethodChannel*)channel {
  return _channel;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;

  if ([@"initialize" isEqualToString:call.method]) {
      NSString* appKey = call.arguments[@"appKey"];
      NSArray* types = call.arguments[@"types"];
      AppodealAdType type = types.count > 0 ? [self typeFromParameter:types.firstObject] : AppodealAdTypeInterstitial;
      int i = 1;
      while (i < types.count) {
          type = type | [self typeFromParameter:types[i]];
          i++;
      }
      [Appodeal initializeWithApiKey:appKey types:type];
      [Appodeal setLogLevel:APDLogLevelVerbose];
      result([NSNumber numberWithBool:YES]);
  } else if ([@"showInterstitial" isEqualToString:call.method]) {
      [Appodeal showAd:AppodealShowStyleInterstitial rootViewController:rootViewController];
      result([NSNumber numberWithBool:YES]);
  } else if ([@"showRewardedVideo" isEqualToString:call.method]) {
      [Appodeal showAd:AppodealShowStyleRewardedVideo rootViewController:rootViewController];
      result([NSNumber numberWithBool:YES]);
  } else if ([@"isLoaded" isEqualToString:call.method]) {
      NSNumber *type = call.arguments[@"type"];
      result([NSNumber numberWithBool:[Appodeal isReadyForShowWithStyle:[self showStyleFromParameter:type]]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (AppodealAdType) typeFromParameter:(NSNumber*) parameter{
    switch ([parameter intValue]) {
        case 0:
            return AppodealAdTypeInterstitial;
        case 2:
            return AppodealAdTypeBanner;
        case 3:
            return AppodealAdTypeNativeAd;
        case 4:
            return AppodealAdTypeRewardedVideo;
            
        default:
            break;
    }
    return AppodealAdTypeInterstitial;
}

- (AppodealShowStyle) showStyleFromParameter:(NSNumber*) parameter{
    switch ([parameter intValue]) {
        case 0:
            return AppodealShowStyleInterstitial;
        case 4:
            return AppodealShowStyleRewardedVideo;
            
        default:
            break;
    }
    return AppodealShowStyleInterstitial;
}

#pragma mark - RewardedVideo Delegate

- (void)rewardedVideoDidLoadAdIsPrecache:(BOOL)precache {
    // rewarded video was loaded
    [_channel invokeMethod:@"onRewardedVideoLoaded" arguments:nil];
}
 
- (void)rewardedVideoDidFailToLoadAd {
    // rewarded video ad failed to load
    [_channel invokeMethod:@"onRewardedVideoFailedToLoad" arguments:nil];
}

- (void)rewardedVideoDidFailToPresentWithError:(NSError *)error {
    // rewarded video ad was loaded but failed to present due to ad netwotk error,
    // placement settings or invalid creative.
    // Error object that indicates error reason
}
 
- (void)rewardedVideoDidPresent {
    // rewarded video was presented
    [_channel invokeMethod:@"onRewardedVideoPresent" arguments:nil];
}
 
- (void)rewardedVideoWillDismissAndWasFullyWatched:(BOOL)wasFullyWatched {
    // rewarded video was closed.
    // wasFullyWatched boolean flag indicated that user watch video fully
    [_channel invokeMethod:@"onRewardedVideoWillDismiss" arguments:nil];
}

- (void)rewardedVideoDidFinish:(float)rewardAmount name:(NSString *)rewardName {
    // rewarded video finished with some reward
    NSDictionary *params = rewardName != nil ? @{
                                                 @"rewardAmount" : @(rewardAmount),
                                                 @"rewardType" : rewardName
                                                 }: nil;
    [_channel invokeMethod:@"onRewardedVideoFinished" arguments: params];
}

@end
