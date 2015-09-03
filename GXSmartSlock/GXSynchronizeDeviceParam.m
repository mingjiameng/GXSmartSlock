//
//  GXSynchronizeDeviceParam.m
//  GXSmartSlock
//
//  Created by zkey on 9/3/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSynchronizeDeviceParam.h"

@implementation GXSynchronizeDeviceParam

+ (GXSynchronizeDeviceParam *)paramWithUserName:(NSString *)userName password:(NSString *)password
{
    GXSynchronizeDeviceParam *param = [[GXSynchronizeDeviceParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    
    return param;
}

@end
