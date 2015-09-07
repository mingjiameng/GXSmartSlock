//
//  GXSynchronizeUnlockRecordParam.m
//  GXSmartSlock
//
//  Created by zkey on 9/7/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSynchronizeUnlockRecordParam.h"

@implementation GXSynchronizeUnlockRecordParam

+ (GXSynchronizeUnlockRecordParam *)paramWithUserName:(NSString *)userName password:(NSString *)password
{
    GXSynchronizeUnlockRecordParam *param = [[GXSynchronizeUnlockRecordParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    
    return param;
}

@end
