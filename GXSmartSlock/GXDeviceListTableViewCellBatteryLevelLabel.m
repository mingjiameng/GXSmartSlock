//
//  GXDeviceListTableViewCellBatteryLevelLabel.m
//  GXSmartSlock
//
//  Created by zkey on 8/25/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXDeviceListTableViewCellBatteryLevelLabel.h"

@implementation GXDeviceListTableViewCellBatteryLevelLabel

- (instancetype)initWithFrame:(CGRect)frame andBatteryLevel:(NSInteger)batteryLevel
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.textColor = [UIColor lightGrayColor];
        self.font = [UIFont systemFontOfSize:10.0f];
        self.textAlignment = NSTextAlignmentLeft;
        
        NSString *title = nil;
        UIColor *indicatorViewBackgroundColor = nil;
        if (batteryLevel < 350.0f) {
            title = @"低电量";
            indicatorViewBackgroundColor = [UIColor redColor];
        } else if (batteryLevel < 485.0f) {
            title = @"中等电量";
            indicatorViewBackgroundColor = [UIColor yellowColor];
        } else {
            title = @"电量充足";
            indicatorViewBackgroundColor = [UIColor greenColor];
        }
        
        self.text = title;
        
        
        // indicate battery level by color
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.0f, 10.0f)];
        indicatorView.center = CGPointMake(frame.size.width - 12.0f, frame.size.height / 2.0f);
        indicatorView.backgroundColor = indicatorViewBackgroundColor;
        indicatorView.layer.masksToBounds = YES;
        indicatorView.layer.cornerRadius = indicatorView.frame.size.width / 2.0f;
        
        [self addSubview:indicatorView];
    }
    
    return self;
}

@end
