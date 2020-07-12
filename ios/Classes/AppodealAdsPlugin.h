#import <Flutter/Flutter.h>
#import <Appodeal/Appodeal.h>

@interface AppodealAdsPlugin : NSObject<FlutterPlugin>

@property (nonatomic, retain) NSObject<FlutterPluginRegistrar> *registrar;

+ (id)sharedPlugin;

@end
