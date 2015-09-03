//
//  GXSynchronizeDeviceUserParam.m
//  GXSmartSlock
//
//  Created by zkey on 9/3/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSynchronizeDeviceUserParam.h"

@implementation GXSynchronizeDeviceUserParam

+ (GXSynchronizeDeviceUserParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire
{
    GXSynchronizeDeviceUserParam *param = [[GXSynchronizeDeviceUserParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    param.deviceIdentifire = deviceIdentifire;
    
    return param;
}

@end
