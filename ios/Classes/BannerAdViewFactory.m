#import "BannerAdViewFactory.h"
#import "FlutterBannerAdView.h"

@implementation BannerAdViewFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype )initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args {
    FlutterBannerAdView *bannerAdView = [[FlutterBannerAdView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args binaryMessager:_messenger];
    return bannerAdView;
}

@end