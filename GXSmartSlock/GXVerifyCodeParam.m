//
//  GXVerifyCodeParam.m
//  GXSmartSlock
//
//  Created by zkey on 8/23/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXVerifyCodeParam.h"

@implementation GXVerifyCodeParam

+ (GXVerifyCodeParam *)paramWithUserName:(NSString *)userName verificationCode:(NSString *)code
{
    GXVerifyCodeParam *param = [[GXVerifyCodeParam alloc] init];
    
    param.userName = userName;
    param.verificationCode = code;
    
    return param;
}

@end
