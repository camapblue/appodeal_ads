#import <Flutter/Flutter.h>

@interface MethodCallHandler : NSObject
- (instancetype )initMethodCallHandlerByMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (FlutterMethodChannel*)channel;
@end
