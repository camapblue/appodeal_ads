//
//  ASNativeView.h
//  AppodealObjectiveCDemo
//
//  Copyright © 2018 appodeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Appodeal/Appodeal.h>

@interface ASNativeView : UIView <APDNativeAdView>

- (void)bindData:(APDNativeAd*)nativeAd;

@end
