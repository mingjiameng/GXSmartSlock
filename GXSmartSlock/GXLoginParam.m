//
//  GXLoginParam.m
//  GXSmartSlock
//
//  Created by zkey on 8/23/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXLoginParam.h"

@implementation GXLoginParam

+ (GXLoginParam *)paramWithUserName:(NSString *)userName password:(NSString *)password phoneInfo:(NSString *)phoneInfo
{
    GXLoginParam *param = [[GXLoginParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    param.phoneInfo = phoneInfo;
    
    return param;
}

@end
