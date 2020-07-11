#import <Flutter/Flutter.h>

@interface NativeAdViewFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype )initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end