//
//  GXLoginModel.m
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 7/9/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXLoginModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_SERVER_INTERFACE.h"

#import "GXLoginParam.h"

#import "GXSystemInfoHelper.h"
#import "GXDefaultHttpHelper.h"
#import "GXServerDataAnalyst.h"
#import "zkeyMiPushPackage.h"

#import <sys/utsname.h>

@implementation GXLoginModel

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password
{
    // 与之前的解绑
    NSString *previousUserName = [[NSUserDefaults standardUserDefaults] objectForKey:PREVIOUS_USER_NAME];
    if (previousUserName != nil) {
        [[zkeyMiPushPackage sharedMiPush] unsetAccount:previousUserName];
    }
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceType = [GXSystemInfoHelper getDeviceInfo:[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_DEVICE_TOKEN];
    NSString *phoneInfo = [NSString stringWithFormat:@"%@,%@", deviceType, deviceToken];
    GXLoginParam *param = [GXLoginParam paramWithUserName:userName password:password phoneInfo:phoneInfo];
    
    [GXDefaultHttpHelper postWithLoginParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:LOGIN_STATUS] integerValue];
        
        if (status == 0) {
            [self.delegate wrongUserNameOrPassword];
        } else if (status == 1) {
            [[zkeyMiPushPackage sharedMiPush] setAccount:userName];
            [GXLoginModel initializeDatabaseWithData:result userName:userName password:password];
            [self.delegate successfullyLogin];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetworkToLogin];
    }];
}


+ (void)initializeDatabaseWithData:(NSDictionary *)result userName:(NSString *)userName password:(NSString *)password
{
    // 必须放在主线程里执行
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSUserDefaults standardUserDefaults] setObject:userName forKey:DEFAULT_USER_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:DEFAULT_USER_PASSWORD];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:true] forKey:LOGIN_STATUS];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:DefaultUnlockModeManul] forKey:DEFAULT_UNLOCK_MODE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [GXServerDataAnalyst login:result];
        
    });
    
}

@end
