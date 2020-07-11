#import <Flutter/Flutter.h>
#import "ASNativeView.h"

@interface FlutterNativeAdView: NSObject<FlutterPlatformView>

- (instancetype)initWithFrame: (CGRect)frame
               viewIdentifier: (int64_t)viewId
               arguments: (id)args
               binaryMessager: (NSObject<FlutterBinaryMessenger>*) messenger;

- (ASNativeView*)view;

@end