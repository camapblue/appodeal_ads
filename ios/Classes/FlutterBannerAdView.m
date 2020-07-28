#import "FlutterBannerAdView.h"
#import "ASNativeView.h"
#import <Appodeal/Appodeal.h>

@interface FlutterBannerAdView() <AppodealBannerViewDelegate>

@end

@implementation FlutterBannerAdView {
    FlutterMethodChannel* _channel;
    int64_t _viewId;
    APDBannerView *_bannerView;
}

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessager:(NSObject<FlutterBinaryMessenger> *)messenger {
    NSString* channelName = [NSString stringWithFormat:@"plugins.appodeal/bannerAd_%lld", viewId];
    self = [super init];
    if (self) {
        NSBundle *bundle = [NSBundle bundleForClass:[ASNativeView class]];
        NSBundle *resourceBundle = [NSBundle bundleWithURL:[bundle URLForResource:@"AppodealBundle" withExtension:@"bundle"]];
    
        _bannerView = [[resourceBundle loadNibNamed:@"Banner" owner:self options:nil] firstObject];
        [Appodeal setBannerDelegate:self];

        _viewId = viewId;
    }
    __block FlutterBannerAdView *blocksafeSelf = self;
    _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
    [_channel setMethodCallHandler: ^(FlutterMethodCall *call, FlutterResult result) {
      if ([@"loadAd" isEqualToString:call.method]) {        

        [blocksafeSelf loadAd:result];
      } 
      else {
        result(FlutterMethodNotImplemented);
      }
    }];

    return self;
}

- (void)loadAd:(FlutterResult)result {
  [_bannerView setAdSize:kAPDAdSize320x50];
  NSLog(@"START Banner LOAD");
  [_bannerView loadAd];

  result([NSNumber numberWithBool:YES]);
}

- (UIView*)view {
    return _bannerView;
}

#pragma mark - AppodealBannerViewDelegate

// banner was loaded (precache flag shows if the loaded ad is precache)
- (void)bannerDidLoadAdIsPrecache:(BOOL)precache {
  NSLog(@"Banner DID LOAD is Precache = %d", precache);
}

// banner was shown
- (void)bannerDidShow {
  NSLog(@"Banner DID SHOW");
} 

// banner failed to load
- (void)bannerDidFailToLoadAd {
  NSLog(@"Banner DID FAIL TO LOAD");
} 

// banner was clicked
- (void)bannerDidClick {
  NSLog(@"Banner DID Click");
} 

// banner did expire and could not be shown
- (void)bannerDidExpired {
  NSLog(@"Banner DID Expired");
} 

@end