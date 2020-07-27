#import "FlutterNativeAdView.h"
#import "ASNativeView.h"
#import <Appodeal/Appodeal.h>
#import <Appodeal/APDNativeAdQueue.h>

@interface FlutterNativeAdView() <APDNativeAdQueueDelegate, APDNativeAdPresentationDelegate> 

@property (nonatomic, strong) APDNativeAdQueue *nativeAdQueue;
@property (nonatomic, strong) ASNativeView *nativeView;
@property (nonatomic, strong) APDNativeAd *nativeAd;

@end

@implementation FlutterNativeAdView {
    FlutterMethodChannel* _channel;
    int64_t _viewId;
    bool _needLoadView;
    UIView *_container;
}

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessager:(NSObject<FlutterBinaryMessenger> *)messenger {
    NSString* channelName = [NSString stringWithFormat:@"plugins.appodeal/nativeAd_%lld", viewId];
    self = [super init];
    if (self) {
        _container = [[UIView alloc] initWithFrame:frame];

        APDNativeAdSettings * setting = [APDNativeAdSettings new];
        setting.adViewClass = ASNativeView.class;
        setting.type = APDNativeAdTypeAuto;
        
        self.nativeAdQueue = [APDNativeAdQueue nativeAdQueueWithSdk:nil
                                                       settings:setting
                                                       delegate:self
                                                      autocache:YES];

        [self.nativeAdQueue loadAd];

        _viewId = viewId;
        _needLoadView = NO;
    }
    __block FlutterNativeAdView *blocksafeSelf = self;
    _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
    [_channel setMethodCallHandler: ^(FlutterMethodCall *call, FlutterResult result) {
      if ([@"loadAd" isEqualToString:call.method]) {
        [blocksafeSelf loadAd:result];
      } 
      else {
        result(FlutterMethodNotImplemented);
      }
    }];
    NSLog(@"INIT NATIVE AD VIEW FINISHED >> %d", viewId);

    return self;
}

- (void)loadAd:(FlutterResult)result {
  NSArray *queue = [self.nativeAdQueue getNativeAdsOfCount:1];
  NSLog(@"Load Ad >> ID = %d >> Total in queue = %d", _viewId, [queue count]);
  self.nativeAd = [queue firstObject];
  NSLog(@"Load Ad >> GET NATIVE = %@", self.nativeAd);
  if (self.nativeAd == nil) {
    _needLoadView = YES;
    if (result != nil) {
      result([NSNumber numberWithBool:NO]);
    }
    return;
  }

  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  self.nativeAd.delegate = self;
  
  self.nativeView = [self.nativeAd getAdViewForController:rootViewController];
  [self.nativeView bindData:self.nativeAd];
  [_container addSubview: self.nativeView];

  self.nativeView.translatesAutoresizingMaskIntoConstraints = NO;
  [NSLayoutConstraint activateConstraints:@[
      [self.nativeView.leftAnchor constraintEqualToAnchor:_container.leftAnchor],
      [self.nativeView.rightAnchor constraintEqualToAnchor:_container.rightAnchor],
      [self.nativeView.topAnchor constraintEqualToAnchor:_container.topAnchor],
      [self.nativeView.bottomAnchor constraintEqualToAnchor:_container.bottomAnchor]
  ]];
  _needLoadView = NO;
  if (result != nil) {
    result([NSNumber numberWithBool:YES]);
  }
}

- (UIView*)view {
    return _container;
}

- (void)adQueueAdIsAvailable:(APDNativeAdQueue *)adQueue ofCount:(NSUInteger)count {
  NSLog(@"Native Ad Queue is Available = %d", count);

  if (count > 0 && _needLoadView) {
    [self loadAd:nil];
  }
}

- (void)adQueue:(APDNativeAdQueue *)adQueue failedWithError:(NSError *)error {
  NSLog(@"Native Ad Queue FAIL = %@", error);
}

- (void)nativeAdWillLogImpression:(APDNativeAd *)nativeAd {
  NSLog(@"Native Ad LOG Impression");
}

- (void)nativeAdWillLogUserInteraction:(APDNativeAd *)nativeAd {
  NSLog(@"Native Ad LOG USER INTERACTION");
}

- (void)nativeAdDidExpired:(nonnull APDNativeAd *)nativeAd {
  NSLog(@"Native Ad DID EXPIRED");
}

@end