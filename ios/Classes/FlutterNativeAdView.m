#import "FlutterNativeAdView.h"
#import "ASNativeView.h"
#import <Appodeal/Appodeal.h>
#import <Appodeal/APDNativeAdQueue.h>

@interface FlutterNativeAdView() <APDNativeAdQueueDelegate, APDNativeAdPresentationDelegate> 

@property (nonatomic, strong) APDNativeAdQueue *nativeAdQueue;
@property (nonatomic, strong) ASNativeView *nativeView;

@end

@implementation FlutterNativeAdView {
    FlutterMethodChannel* _channel;

    UIView *_container;
}

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessager:(NSObject<FlutterBinaryMessenger> *)messenger {
    NSString* channelName = [NSString stringWithFormat:@"plugins.appodeal/nativeAd_%lld", viewId];
    NSLog(@"INIT VIEW WITH CHANNEL NAME = %@", channelName);
    self = [super init];
    if (self) {
        _container = [[UIView alloc] initWithFrame:frame];
        _container.backgroundColor = [UIColor greenColor];

        APDNativeAdSettings * setting = [APDNativeAdSettings new];
        setting.adViewClass = ASNativeView.class;
        setting.type = APDNativeAdTypeAuto;
        
        self.nativeAdQueue = [APDNativeAdQueue nativeAdQueueWithSdk:nil
                                                       settings:setting
                                                       delegate:self
                                                      autocache:YES];

        [self.nativeAdQueue loadAd];
        NSLog(@"FINISHED INIT NATIVE AD VIEW");
    }
    __block FlutterNativeAdView *blocksafeSelf = self;
    _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
    [_channel setMethodCallHandler: ^(FlutterMethodCall *call, FlutterResult result) {
      if ([@"loadAd" isEqualToString:call.method]) {
        bool isInitialized = [Appodeal isInitalizedForAdType: AppodealAdTypeNativeAd];
        bool isInitializedInterstitial = [Appodeal isInitalizedForAdType: AppodealAdTypeInterstitial];

        NSLog(@"Start LOAD AD = %@", isInitialized == true ? @"true" : @"false");
        NSLog(@"ALA LA = %@", isInitializedInterstitial == true ? @"true" : @"false");

        [blocksafeSelf loadAd:result];
      } 
      else {
        result(FlutterMethodNotImplemented);
      }
    }];

    return self;
}

- (void)loadAd:(FlutterResult)result {
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  NSLog(@"NATIVE QUEUE = %@", self.nativeAdQueue);

  APDNativeAd * nativeAd = [[self.nativeAdQueue getNativeAdsOfCount:1] firstObject];
  NSLog(@"GOT NATIVE AD = %@", nativeAd);
  if (nativeAd != nil) {
    nativeAd.delegate = self;
  }
  
  self.nativeView = [nativeAd getAdViewForController:rootViewController];
  [_container addSubview: self.nativeView];

  self.nativeView.translatesAutoresizingMaskIntoConstraints = NO;
  [NSLayoutConstraint activateConstraints:@[
      [self.nativeView.leftAnchor constraintEqualToAnchor:_container.leftAnchor],
      [self.nativeView.rightAnchor constraintEqualToAnchor:_container.rightAnchor],
      [self.nativeView.topAnchor constraintEqualToAnchor:_container.topAnchor],
      [self.nativeView.bottomAnchor constraintEqualToAnchor:_container.bottomAnchor]
  ]];

  NSLog(@"HAVE NATIVE AD NOW = %@", self.nativeView);

  result([NSNumber numberWithBool:YES]);
}

- (UIView*)view {
  NSLog(@"RENDER AD = %@", self.nativeView);
    return _container;
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