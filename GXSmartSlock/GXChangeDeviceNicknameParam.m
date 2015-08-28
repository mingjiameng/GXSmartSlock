//
//  GXChangeDeviceNicknameParam.m
//  GXSmartSlock
//
//  Created by zkey on 8/27/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXChangeDeviceNicknameParam.h"

@implementation GXChangeDeviceNicknameParam

+ (GXChangeDeviceNicknameParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire newDeviceNickname:(NSString *)deviceNickname
{
    GXChangeDeviceNicknameParam *param = [[GXChangeDeviceNicknameParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    param.deviceIdentifire = deviceIdentifire;
    param.deviceNickname = deviceNickname;
    
    return param;
}

@end
