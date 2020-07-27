#import <Flutter/Flutter.h>

@interface BannerAdViewFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype )initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end