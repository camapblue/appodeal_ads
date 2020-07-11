#import "FlutterNativeAdView.h"
#import "ASNativeView.h"
#import <Appodeal/Appodeal.h>
#import <Appodeal/APDNativeAdQueue.h>

@interface FlutterNativeAdView() <APDNativeAdQueueDelegate, APDNativeAdPresentationDelegate> 

@end

@implementation FlutterNativeAdView {
    FlutterMethodChannel* _channel;
    ASNativeView* nativeView;
    APDNativeAdQueue* nativeAdQueue;
}

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessager:(NSObject<FlutterBinaryMessenger> *)messenger {
    NSString* channelName = [NSString stringWithFormat:@"plugins.appodeal/nativeAd_%lld", viewId];
    NSLog(@"INIT VIEW WITH CHANNEL NAME = %@", channelName);
    self = [super init];
    if (self) {
        nativeAdQueue = [[APDNativeAdQueue alloc] init];
        nativeAdQueue.settings = [APDNativeAdSettings defaultSettings];
        nativeAdQueue.settings.adViewClass = ASNativeView.class;
        nativeAdQueue.delegate = self;
        nativeAdQueue.settings.autocacheMask = APDNativeResourceAutocacheIcon | APDNativeResourceAutocacheMedia;

        [nativeAdQueue loadAd];
        NSLog(@"FINISHED INIT NATIVE AD VIEW");
    }
    _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
    [_channel setMethodCallHandler: ^(FlutterMethodCall *call, FlutterResult result) {
      if ([@"loadAd" isEqualToString:call.method]) {
        NSLog(@"Start LOAD AD");

        [self loadAd:result];
      } else {
        result(FlutterMethodNotImplemented);
      }
    }];

    return self;
}

- (void)loadAd:(FlutterResult)result {
  // UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  NSLog(@"NATIVE QUEUE = %@", nativeAdQueue);

  APDNativeAd * nativeAd = [[nativeAdQueue getNativeAdsOfCount:1] firstObject];
  NSLog(@"GOT NATIVE AD = %@", nativeAd);
  if (nativeAd != nil) {
    nativeAd.delegate = self;
  } else {
    // [Appodeal getNativeAds:1];
  }
  nativeView = [nativeAd getAdViewForController:self];

  NSLog(@"HAVE NATIVE AD NOW = %@", nativeView);

  result([NSNumber numberWithBool:YES]);
}

- (ASNativeView*)view {
    return nativeView == nil ? [[UIView alloc] init] : nativeView;
}

- (void)adQueueAdIsAvailable:(APDNativeAdQueue *)adQueue ofCount:(NSUInteger)count {
  NSLog(@"Native Ad Queue is Available = %d", count);
}

- (void)adQueue:(APDNativeAdQueue *)adQueue failedWithError:(NSError *)error {
  NSLog(@"Native Ad Queue FAIL = %@", error);
}

- (void)nativeAdWillLogImpression:(APDNativeAd *)nativeAd {

}

- (void)nativeAdWillLogUserInteraction:(APDNativeAd *)nativeAd {

}

@end