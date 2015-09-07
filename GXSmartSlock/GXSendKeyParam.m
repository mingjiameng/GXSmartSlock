//
//  GXSendKeyParam.m
//  GXSmartSlock
//
//  Created by zkey on 9/7/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSendKeyParam.h"

@implementation GXSendKeyParam

+ (GXSendKeyParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire receiverUserName:(NSString *)receiver authorityType:(NSString *)type
{
    GXSendKeyParam *param = [[GXSendKeyParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    param.deviceIdentifire = deviceIdentifire;
    param.receiverUserName = receiver;
    param.authorityType = type;
    
    return param;
}

@end
