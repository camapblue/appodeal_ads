#import "AppodealAdsPlugin.h"
#import "MethodCallHandler.h"
#import <Appodeal/Appodeal.h>

@implementation AppodealAdsPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    MethodCallHandler *methodHandler = [[MethodCallHandler alloc] initMethodCallHandlerByMessenger:[registrar messenger]];
    AppodealAdsPlugin* instance = [[AppodealAdsPlugin alloc] init];

    [Appodeal setRewardedVideoDelegate:methodHandler];
    [registrar addMethodCallDelegate:methodHandler channel:[methodHandler channel]];
}

@end