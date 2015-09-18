//
//  GXDeviceListTableViewCellBatteryLevelLabel.m
//  GXSmartSlock
//
//  Created by zkey on 8/25/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXDeviceListTableViewCellBatteryLevelLabel.h"

@implementation GXDeviceListTableViewCellBatteryLevelLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.textColor = [UIColor lightGrayColor];
        self.font = [UIFont systemFontOfSize:10.0f];
        self.textAlignment = NSTextAlignmentRight;
        
        // indicate battery level by color
        CGFloat indicatorViewHeight = 10.0f;
        self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, (frame.size.height - indicatorViewHeight) / 2.0f, indicatorViewHeight, indicatorViewHeight)];
        self.indicatorView.backgroundColor = [UIColor greenColor];
        self.indicatorView.layer.masksToBounds = YES;
        self.indicatorView.layer.cornerRadius = self.indicatorView.frame.size.width / 2.0f;
        
        [self addSubview:self.indicatorView];
    }
    
    return self;
}

@end
