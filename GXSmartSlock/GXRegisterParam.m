//
//  GXRegisterParam.m
//  GXSmartSlock
//
//  Created by zkey on 8/23/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXRegisterParam.h"

@implementation GXRegisterParam

+ (GXRegisterParam *)paramWithUserName:(NSString *)userName nickname:(NSString *)nickname password:(NSString *)password verificationCode:(NSString *)code phoneInfo:(NSString *)phoneInfo
{
    GXRegisterParam *param = [[GXRegisterParam alloc] init];
    
    param.userName = userName;
    param.nickname = nickname;
    param.password = password;
    param.verificationCode = code;
    param.phoneInfo = phoneInfo;
    
    return param;
}

@end
