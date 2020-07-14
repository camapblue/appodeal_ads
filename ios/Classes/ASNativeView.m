//
//  ASNativeView.m
//  AppodealObjectiveCDemo
//
//  Copyright © 2018 appodeal. All rights reserved.
//

#import "ASNativeView.h"
#import "AppodealAdsPlugin.h"
#import <Appodeal/Appodeal.h>
#import <HCSStarRatingView/HCSStarRatingView.h>

@interface ASNativeView ()
//required
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *callToActionLabel;
//optional
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *adChoiceView;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRatingView;

@end

@implementation ASNativeView

+ (UINib *)nib {
    NSBundle *b = [NSBundle bundleForClass:[self class]];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:[b URLForResource:@"AppodealBundle" withExtension:@"bundle"]];
    
    return [UINib nibWithNibName:@"Native" bundle:resourceBundle];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    ASNativeView * nativeView = [super initWithCoder:aDecoder];
    return nativeView;
}

- (void)drawRect:(CGRect)rect {
    self.iconView.layer.cornerRadius = 8.0;
    self.iconView.layer.masksToBounds = YES;
    
    self.callToActionLabel.layer.cornerRadius = 8.0;
    self.callToActionLabel.layer.masksToBounds = YES;
}

- (void)bindData:(APDNativeAd*)nativeAd {
  [self.starRatingView setUserInteractionEnabled:false];
  self.starRatingView.value = [nativeAd.starRating doubleValue];

  NSBundle *b = [NSBundle bundleForClass:[self class]];
  NSBundle *resourceBundle = [NSBundle bundleWithURL:[b URLForResource:@"AppodealBundle" withExtension:@"bundle"]];
  NSString *fileName = [resourceBundle pathForResource:@"ad" ofType:@"png"];
  UIImage *image = [UIImage imageWithContentsOfFile:fileName];
  [self.adChoiceView setImage:image];
}

@end
