#import "AppodealAdsPlugin.h"
#import "MethodCallHandler.h"
#import "NativeAdViewFactory.h"
#import "BannerAdViewFactory.h"
#import <Appodeal/Appodeal.h>

@implementation AppodealAdsPlugin

+ (id)sharedPlugin {
    static AppodealAdsPlugin *sharedAppodealPlugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAppodealPlugin = [[self alloc] init];
    });
    return sharedAppodealPlugin;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    MethodCallHandler *methodHandler = [[MethodCallHandler alloc] initMethodCallHandlerByMessenger:[registrar messenger]];
    AppodealAdsPlugin* instance = [AppodealAdsPlugin sharedPlugin];

    [Appodeal setRewardedVideoDelegate:methodHandler];
    [registrar addMethodCallDelegate:methodHandler channel:[methodHandler channel]];
    [registrar registerViewFactory: [[NativeAdViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"plugins.appodeal/nativeAd"];
    [registrar registerViewFactory: [[BannerAdViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"plugins.appodeal/bannerAd"];
    instance.registrar = registrar;
}

@end