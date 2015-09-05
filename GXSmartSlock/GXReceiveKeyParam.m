//
//  GXReceiveKeyParam.m
//  GXSmartSlock
//
//  Created by zkey on 9/5/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXReceiveKeyParam.h"

@implementation GXReceiveKeyParam

+ (GXReceiveKeyParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceNickname:(NSString *)nickname forDevice:(NSString *)deviceIdentifire
{
    GXReceiveKeyParam *param = [[GXReceiveKeyParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    param.nickname = nickname;
    param.deviceIdentifire = deviceIdentifire;
    
    return param;
}

@end
