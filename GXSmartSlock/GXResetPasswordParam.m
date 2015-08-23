//
//  GXResetPasswordParam.m
//  GXSmartSlock
//
//  Created by zkey on 8/23/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXResetPasswordParam.h"

@implementation GXResetPasswordParam

+ (GXResetPasswordParam *)paramWithUserName:(NSString *)userName password:(NSString *)password verificationCode:(NSString *)code
{
    GXResetPasswordParam *param = [[GXResetPasswordParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    param.verificationCode = code;
    
    return param;
}

@end
