//
//  GXDeleteAuthorizedUserParam.m
//  GXSmartSlock
//
//  Created by zkey on 9/2/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXDeleteAuthorizedUserParam.h"

@implementation GXDeleteAuthorizedUserParam

+ (GXDeleteAuthorizedUserParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire deletedUserName:(NSString *)deletedUserName
{
    GXDeleteAuthorizedUserParam *param = [[GXDeleteAuthorizedUserParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    param.deviceIdentifire = deviceIdentifire;
    param.deletedUserName = deletedUserName;
    
    return param;
}

@end
