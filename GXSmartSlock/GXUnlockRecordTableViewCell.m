//
//  GXUnlockRecordTableViewCell.m
//  GXSmartSlock
//
//  Created by zkey on 9/7/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXUnlockRecordTableViewCell.h"

@implementation GXUnlockRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.textColor = [UIColor lightGrayColor];
    self.dateLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:self.dateLabel];
    
    return self;
}


- (void)layoutSubviews
{
    CGFloat imageSize = 60.0f;
    self.imageView.frame = CGRectMake(15.0f, 10.0f, imageSize, imageSize);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = imageSize / 2.0f;
    
    self.textLabel.frame = CGRectMake(85.0f, 10.0f, self.frame.size.width - 160.0f, 40.0f);
    
    self.detailTextLabel.frame = CGRectMake(85.0f, 50.0f, self.frame.size.width - 160.0f, 20.0f);
    
    self.dateLabel.frame = CGRectMake(self.frame.size.width - 80.0f, 30.0f, 60.0f, 20.0f);
}

@end
