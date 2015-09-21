//
//  GXUpdateDeviceBatteryLevelParam.m
//  GXSmartSlock
//
//  Created by zkey on 9/21/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXUpdateDeviceBatteryLevelParam.h"

@implementation GXUpdateDeviceBatteryLevelParam

+ (GXUpdateDeviceBatteryLevelParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire batteryLevel:(NSInteger)batteryLevel
{
    GXUpdateDeviceBatteryLevelParam *param = [[GXUpdateDeviceBatteryLevelParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    param.deviceIdentifire = deviceIdentifire;
    param.batteryLevelString = [NSString stringWithFormat:@"%ld", (long)batteryLevel];
    
    return param;
}

@end
