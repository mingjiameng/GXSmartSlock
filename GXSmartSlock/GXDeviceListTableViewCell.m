//
//  GXDeviceListTableViewCell.m
//  GXSmartSlock
//
//  Created by zkey on 8/28/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXDeviceListTableViewCell.h"

@implementation GXDeviceListTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageViewSize = 60.0f;
    self.imageView.frame = CGRectMake(15.0f, 10.0f, imageViewSize, imageViewSize);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = imageViewSize / 2.0f;
    
}

@end
