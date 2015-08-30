//
//  GXSelectDeviceTableViewCell.m
//  GXSmartSlock
//
//  Created by zkey on 8/30/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSelectDeviceTableViewCell.h"

@implementation GXSelectDeviceTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageSize = 44.0f;
    self.imageView.frame = CGRectMake(15.0f, 8.0f, imageSize, imageSize);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = imageSize / 44.0f;
    
    self.textLabel.frame = CGRectMake(60.0f, 10.0f, self.frame.size.width - 80.0f, 40.0f);
    
}

@end
