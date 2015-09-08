//
//  GXLogoutModel.m
//  GXSmartSlock
//
//  Created by zkey on 8/31/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXLogoutModel.h"

#import "MICRO_COMMON.h"

#import "GXDatabaseHelper.h"
#import "zkeyMiPushPackage.h"

@implementation GXLogoutModel

+ (void)logout
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:PREVIOUS_USER_NAME];
    
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:DEFAULT_LOGIN_STATUS];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEFAULT_USER_NAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEFAULT_USER_PASSWORD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEFAULT_GESTURE_PASSWORD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEFAULT_UNLOCK_MODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [GXDatabaseHelper logout];
    
    [[zkeyMiPushPackage sharedMiPush] unsetAccount:userName];
}

@end
