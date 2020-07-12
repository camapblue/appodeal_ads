#import "AppodealAdsPlugin.h"
#import "MethodCallHandler.h"
#import "NativeAdViewFactory.h"
#import <Appodeal/Appodeal.h>

@implementation AppodealAdsPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    MethodCallHandler *methodHandler = [[MethodCallHandler alloc] initMethodCallHandlerByMessenger:[registrar messenger]];
    AppodealAdsPlugin* instance = [[AppodealAdsPlugin alloc] init];

    [Appodeal setRewardedVideoDelegate:methodHandler];
    [registrar addMethodCallDelegate:methodHandler channel:[methodHandler channel]];
    [registrar registerViewFactory: [[NativeAdViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"plugins.appodeal/nativeAd"];
    NSLog(@"FINISHED REGISTER NOW HEHE");
    NSString* key = [registrar lookupKeyForAsset: @"Native.xib"];
    NSLog(@"KEY NOW = %@", key);
}

@end