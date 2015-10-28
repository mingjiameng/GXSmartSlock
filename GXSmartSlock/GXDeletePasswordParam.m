//
//  GXDeletePasswordParam.m
//  GXSmartSlock
//
//  Created by zkey on 10/20/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXDeletePasswordParam.h"

@implementation GXDeletePasswordParam

+ (GXDeletePasswordParam *)paramWithAccessToken:(NSString *)accessToken deviceID:(NSString *)deviceIdentifire passwordID:(NSInteger)passwordID operationType:(NSString *)operationType
{
    GXDeletePasswordParam *param = [[GXDeletePasswordParam alloc] init];
    
    param.accessToken = accessToken;
    param.deviceIdentifire = deviceIdentifire;
    param.passwordIdString = [NSString stringWithFormat:@"%ld", (long)passwordID];
    param.operationType = operationType;
    
    return param;
}

@end
