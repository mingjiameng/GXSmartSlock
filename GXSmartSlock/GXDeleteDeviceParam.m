//
//  GXDeleteDeviceParam.m
//  GXSmartSlock
//
//  Created by zkey on 8/29/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXDeleteDeviceParam.h"

@implementation GXDeleteDeviceParam

+ (GXDeleteDeviceParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire deviceAuthority:(NSString *)deviceAuthority
{
    GXDeleteDeviceParam *param = [[GXDeleteDeviceParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    param.deviceIdentifire = deviceIdentifire;
    param.deviceAuthority = deviceAuthority;
    
    return param;
}

@end
