//
//  zkeyAlertBanner.m
//  FenHongForIOS
//
//  Created by zkey on 6/13/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "zkeyAlertBanner.h"

@implementation zkeyAlertBanner

- (instancetype)initWithFrame:(CGRect)frame message:(NSString *)message
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat leadingSpace = 20;
        CGFloat topBottomSpace = 10;
        
        UIFont *alertBannerFont = [UIFont systemFontOfSize:12.0];
        
        CGSize maxSize = CGSizeMake(frame.size.width - 4 * leadingSpace, 100);
        CGSize alertBannerSize = [message boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObjectsAndKeys:alertBannerFont, NSFontAttributeName, nil] context:nil].size;
        
        CGFloat alertBannerWidth = alertBannerSize.width + 2 * leadingSpace;
        CGFloat alertBannerHeight = alertBannerSize.height + 2 * topBottomSpace;
        UILabel *alertBanner = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, alertBannerWidth, alertBannerHeight)];
        alertBanner.center = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
        alertBanner.backgroundColor = [UIColor blackColor];
        alertBanner.textColor = [UIColor whiteColor];
        alertBanner.textAlignment = NSTextAlignmentCenter;
        alertBanner.alpha = 0.8;
        alertBanner.layer.masksToBounds = YES;
        alertBanner.layer.cornerRadius = 5.0;
        alertBanner.font = alertBannerFont;
        
        alertBanner.text = message;
        [self addSubview:alertBanner];
    }
    
    return self;
}

@end
