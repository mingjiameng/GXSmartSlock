//
//  GXDeviceListTableViewCell.h
//  GXSmartSlock
//
//  Created by zkey on 8/28/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GXDeviceListTableViewCellBatteryLevelLabel.h"

@interface GXDeviceListTableViewCell : UITableViewCell

@property (nonatomic, strong) GXDeviceListTableViewCellBatteryLevelLabel *batteryLabel;
@property (nonatomic, strong) UILabel *deviceCategoryLabel;

@end
