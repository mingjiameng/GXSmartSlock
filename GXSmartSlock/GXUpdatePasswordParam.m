//
//  GXUpdatePasswordParam.m
//  GXSmartSlock
//
//  Created by zkey on 9/1/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXUpdatePasswordParam.h"

@implementation GXUpdatePasswordParam

+ (GXUpdatePasswordParam *)paramWithUserName:(NSString *)userName password:(NSString *)password nPassword:(NSString *)nPassword
{
    GXUpdatePasswordParam *param = [[GXUpdatePasswordParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    param.nPassword = nPassword;
    
    return param;
}

@end
