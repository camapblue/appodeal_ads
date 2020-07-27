#import <Flutter/Flutter.h>

@interface FlutterBannerAdView: NSObject<FlutterPlatformView>

- (instancetype)initWithFrame: (CGRect)frame
               viewIdentifier: (int64_t)viewId
               arguments: (id)args
               binaryMessager: (NSObject<FlutterBinaryMessenger>*) messenger;

- (UIView*)view;

@end