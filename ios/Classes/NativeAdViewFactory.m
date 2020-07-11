#import "NativeAdViewFactory.h"
#import "FlutterNativeAdView.h"

@implementation NativeAdViewFactory {
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
    FlutterNativeAdView *nativeAdView = [[FlutterNativeAdView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args binaryMessager:_messenger];
    NSLog(@"HELLO WORLD DONE PLATFORM VIEW");
    return nativeAdView;
}

@end