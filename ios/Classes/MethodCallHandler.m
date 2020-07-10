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

- (void)rewardedVideoDidLoadAd {
    [_channel invokeMethod:@"onRewardedVideoLoaded" arguments:nil];
}

- (void)rewardedVideoDidFailToLoadAd {
    [_channel invokeMethod:@"onRewardedVideoFailedToLoad" arguments:nil];
}

- (void)rewardedVideoDidPresent {
    [_channel invokeMethod:@"onRewardedVideoPresent" arguments:nil];
}

- (void)rewardedVideoWillDismiss {
    [_channel invokeMethod:@"onRewardedVideoWillDismiss" arguments:nil];
}

- (void)rewardedVideoDidFinish:(NSUInteger)rewardAmount name:(NSString *)rewardName {
    NSDictionary *params = rewardName != nil ? @{
                                                 @"rewardAmount" : @(rewardAmount),
                                                 @"rewardType" : rewardName
                                                 }: nil;
    [_channel invokeMethod:@"onRewardedVideoFinished" arguments: params];
}

@end