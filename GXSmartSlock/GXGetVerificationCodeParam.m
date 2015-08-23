//
//  GXGetVerificationCodeParam.m
//  GXSmartSlock
//
//  Created by zkey on 8/23/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXGetVerificationCodeParam.h"

@implementation GXGetVerificationCodeParam

+ (GXGetVerificationCodeParam *)paramWithUserName:(NSString *)userName
{
    GXGetVerificationCodeParam *param = [[GXGetVerificationCodeParam alloc] init];
    
    param.userName = userName;
    
    return param;
}

@end
