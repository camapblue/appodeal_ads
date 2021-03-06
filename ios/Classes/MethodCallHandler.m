#import "MethodCallHandler.h"
#import <Appodeal/Appodeal.h>
#import <StackConsentManager/StackConsentManager.h>

@interface MethodCallHandler () <STKConsentManagerDisplayDelegate>

@end

@implementation MethodCallHandler {
  FlutterMethodChannel *_channel;
  NSString *_appKey;
  NSArray *_types;

  NSString *_userId;
  int _age;
  NSString *_gender;
  FlutterResult _initializedResult;
  int _isForTesting;
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
      _appKey = call.arguments[@"appKey"];
      _types = call.arguments[@"types"];
      
      // user info
      _userId = call.arguments[@"userId"];
      _age = (int)[[NSString stringWithFormat:@"%@", call.arguments[@"age"]] integerValue];

      _gender = call.arguments[@"gender"];
      if (call.arguments[@"isForTesting"] != nil) {
        _isForTesting = (int)[[NSString stringWithFormat:@"%@", call.arguments[@"isForTesting"]] integerValue];;
      } else {
        _isForTesting = 0;
      }

      _initializedResult = result;
      [self synchroniseConsent: rootViewController];
  } else if ([@"showInterstitial" isEqualToString:call.method]) {
    BOOL isShow = [Appodeal showAd:AppodealShowStyleInterstitial rootViewController:rootViewController];
    result([NSNumber numberWithBool:isShow]);
  } else if ([@"showRewardedVideo" isEqualToString:call.method]) {
    BOOL isShow = [Appodeal showAd:AppodealShowStyleRewardedVideo rootViewController:rootViewController];
    result([NSNumber numberWithBool:isShow]);
  } else if ([@"isLoaded" isEqualToString:call.method]) {
    NSNumber *type = call.arguments[@"type"];
    BOOL isShow = [Appodeal isReadyForShowWithStyle:[self showStyleFromParameter:type]];
    result([NSNumber numberWithBool:isShow]);
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
        case 2:
            return AppodealAdTypeBanner;
        case 3:
            return AppodealAdTypeNativeAd;
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


- (void)initializeSDK {
    /// User Data
    [Appodeal setUserId:_userId];
    [Appodeal setUserAge:_age];
    [Appodeal setUserGender:[_gender isEqualToString:@"male"] ? AppodealUserGenderMale : AppodealUserGenderFemale];
    
    AppodealAdType types = _types.count > 0 ? [self typeFromParameter:_types.firstObject] : AppodealAdTypeInterstitial;
    int i = 1;
    while (i < _types.count) {
        types = types | [self typeFromParameter:_types[i]];
        i++;
    }
    // [Appodeal setLogLevel:APDLogLevelNone];
    [Appodeal setAutocache:YES types:AppodealAdTypeInterstitial | AppodealAdTypeRewardedVideo | AppodealAdTypeBanner];
    [Appodeal setTestingEnabled: _isForTesting == 1];

    if (STKConsentManager.sharedManager.consent != nil) {
        [Appodeal initializeWithApiKey:_appKey
                                 types:types
                         consentReport:STKConsentManager.sharedManager.consent];
    } else {
        [Appodeal initializeWithApiKey:_appKey types:types];
    }
    _initializedResult([NSNumber numberWithBool:YES]);
}

- (void)synchroniseConsent:(UIViewController*)rootViewController {
    __weak typeof(self) weakSelf = self;
    [STKConsentManager.sharedManager synchronizeWithAppKey:_appKey completion:^(NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (error) {
            NSLog(@"Error while synchronising consent manager: %@", error);
        }
        
        if (STKConsentManager.sharedManager.shouldShowConsentDialog != STKConsentBoolTrue) {
          NSLog(@"Start Init");
            [strongSelf initializeSDK];
            return ;
        }
        
        NSLog(@"Start Load Consent Dialog");
        [STKConsentManager.sharedManager loadConsentDialog:^(NSError *error) {
            if (error) {
                NSLog(@"Error while loading consent dialog: %@", error);
            }
            
            if (!STKConsentManager.sharedManager.isConsentDialogReady) {
                [strongSelf initializeSDK];
                return ;
            }
            [STKConsentManager.sharedManager showConsentDialogFromRootViewController:rootViewController
                                                                            delegate:strongSelf];
        }];
    }];
}

#pragma mark - STKConsentManagerDisplayDelegate

- (void)consentManagerWillShowDialog:(STKConsentManager *)consentManager {
  NSLog(@"CONSENT MANAGER >> WILL SHOW DIALOG");
}

- (void)consentManagerDidDismissDialog:(STKConsentManager *)consentManager {
  NSLog(@"CONSENT MANAGER >> DID DISMISS DIALOG");
  [self initializeSDK];
}

- (void)consentManager:(STKConsentManager *)consentManager didFailToPresent:(NSError *)error {
  NSLog(@"CONSENT MANAGER >> DID FAIL TO PRESENT");
  [self initializeSDK];
}

@end
