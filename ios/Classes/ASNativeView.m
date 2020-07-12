//
//  ASNativeView.m
//  AppodealObjectiveCDemo
//
//  Copyright © 2018 appodeal. All rights reserved.
//

#import "ASNativeView.h"
#import "AppodealAdsPlugin.h"

@interface ASNativeView ()
//required
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *callToActionLabel;
//optional
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *mediaContainerView;
@property (weak, nonatomic) IBOutlet UIView *adChoicesView;

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
    self.layer.cornerRadius = 16.0;
    self.layer.masksToBounds = YES;
    
    self.iconView.layer.cornerRadius = 8.0;
    self.iconView.layer.masksToBounds = YES;
    
    self.callToActionLabel.layer.cornerRadius = 8.0;
    self.callToActionLabel.layer.masksToBounds = YES;

    NSLog(@"TITLE = %@", self.titleLabel);
    self.backgroundColor = [UIColor redColor];
}

@end
