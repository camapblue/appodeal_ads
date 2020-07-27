#import "FlutterBannerAdView.h"
#import "ASNativeView.h"
#import <Appodeal/Appodeal.h>

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
  [_bannerView loadAd];
  
  if (result != nil) {
    result([NSNumber numberWithBool:YES]);
  }
}

- (UIView*)view {
    return _bannerView;
}

@end