//
//  GXRejectKeyParam.m
//  GXSmartSlock
//
//  Created by zkey on 9/4/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXRejectKeyParam.h"

@implementation GXRejectKeyParam

+ (GXRejectKeyParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire
{
    GXRejectKeyParam *param = [[GXRejectKeyParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    param.deviceIdentifire = deviceIdentifire;
    
    return param;
}

@end
