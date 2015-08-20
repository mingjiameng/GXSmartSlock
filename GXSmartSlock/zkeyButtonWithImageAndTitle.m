//
//  zkeyButtonWithImageAndTitle.m
//  FenHongForIOS
//
//  Created by zkey on 7/21/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "zkeyButtonWithImageAndTitle.h"

@implementation zkeyButtonWithImageAndTitle

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title titleFontSize:(CGFloat)fontSize titleColor:(UIColor *)color image:(UIImage *)image imageSize:(CGFloat)imageSize
{
    self = [super initWithFrame:frame];
    
    if (self) {
        CGFloat UIWidth = imageSize;
        CGFloat imageHeigth = UIWidth;
        CGFloat lableHeight = 21.0;
        CGFloat verticalDistance = 10.0;
        
        CGFloat leadingSpace = (frame.size.width - UIWidth) / 2.0;
        CGFloat topSpace = (frame.size.height - UIWidth - lableHeight - verticalDistance) / 2.0;
        
        // image
        self.topImageView = [[UIImageView alloc] initWithImage:image];
        [self.topImageView setFrame:CGRectMake(leadingSpace, topSpace, UIWidth, imageHeigth)];
        [self addSubview:self.topImageView];
        
        // image title
        self.bottomTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topSpace + imageHeigth + verticalDistance, frame.size.width, lableHeight)];
        self.bottomTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.bottomTitleLabel.text = title;
        self.bottomTitleLabel.font = [UIFont systemFontOfSize:fontSize];
        self.bottomTitleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.bottomTitleLabel];
    }
    
    return self;
}

@end
