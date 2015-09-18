//
//  GXDeviceListTableViewCell.m
//  GXSmartSlock
//
//  Created by zkey on 8/28/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXDeviceListTableViewCell.h"

@implementation GXDeviceListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.batteryLabel = [[GXDeviceListTableViewCellBatteryLevelLabel alloc] initWithFrame:CGRectMake(0, 0, 10.0f, 10.0f)];
        [self.contentView addSubview:self.batteryLabel];
        
        self.deviceCategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10.0f, 10.0f)];
        self.deviceCategoryLabel.textColor = [UIColor lightGrayColor];
        self.deviceCategoryLabel.font = [UIFont systemFontOfSize:10.0f];
        self.deviceCategoryLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.deviceCategoryLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageViewSize = 60.0f;
    self.imageView.frame = CGRectMake(15.0f, 10.0f, imageViewSize, imageViewSize);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 5.0f;
    
    self.textLabel.frame = CGRectMake(100.0f, 15.0f, self.frame.size.width - 80.0f, 35.0f);
    
    self.detailTextLabel.frame = CGRectMake(100.0f, 50.0f, self.frame.size.width - 80.0f, 15.0f);
    
    CGFloat deviceCategoryLabelWidth = 40.0f;
    self.deviceCategoryLabel.frame = CGRectMake(self.frame.size.width - deviceCategoryLabelWidth - 10.0f, 20.0f, deviceCategoryLabelWidth, 21.0f);
    
    CGFloat batteryLabelWidth = 53.0f;
    CGFloat batteryLabelHeight = 10.0f;
    self.batteryLabel.frame = CGRectMake(self.frame.size.width - deviceCategoryLabelWidth - 20.0f, self.frame.size.height - 10.0f - batteryLabelHeight ,batteryLabelWidth, batteryLabelHeight);
}

@end
