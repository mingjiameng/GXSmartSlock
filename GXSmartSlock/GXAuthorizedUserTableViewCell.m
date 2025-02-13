//
//  GXAuthorizedUserTableViewCell.m
//  GXSmartSlock
//
//  Created by zkey on 9/1/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXAuthorizedUserTableViewCell.h"

@implementation GXAuthorizedUserTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageViewSize = 40.0f;
    CGFloat extraBlank = 35.0f;
    
    self.imageView.frame = CGRectMake(15.0f, 10.0f, imageViewSize, imageViewSize);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2.0f;
    
    self.textLabel.frame = CGRectMake(imageViewSize + extraBlank, 10.0f, self.frame.size.width - imageViewSize - extraBlank, 25.0f);
    
    self.detailTextLabel.frame = CGRectMake(imageViewSize + extraBlank, 35.0f, self.frame.size.width - imageViewSize - extraBlank, 15.0f);
}

@end
