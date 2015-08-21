//
//  GXRegisterModel.m
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 7/15/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXRegisterModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_LOGIN.h"

#import "GXEMailHttpTool.h"
#import "GXResourceHelper.h"
#import "GXUserRegisterParam.h"
#import "GXAuthHttpTool.h"
#import "GXResetPasswordParam.h"
#import "GXDataManager.h"
#import "zkeyMiPushPackage.h"

#import <sys/utsname.h>

@implementation GXRegisterModel

- (void)getValidCode:(NSString *)userName withType:(RegisterViewType)type
{
    if (type == RegisterViewTypeRegister) {
        [GXEMailHttpTool submitAccountInfoWithParams:userName succeed:^(GXUserExistResult *result) {
            if (result.status == 0) {
                [self.delegate invalidUserName];
            } else {
                [self.delegate validUserName];
            }
        } failure:^(NSError *error) {
            [self.delegate noNetwork];
        }];
    } else if (type == RegisterViewTypeForgetPassword) {
        [GXEMailHttpTool forgetAccountInfoWithParams:userName succeed:^(GXUserExistResult *result) {
            if (result.status == 0) {
                [self.delegate invalidUserName];
            } else {
                [self.delegate validUserName];
            }
        } failure:^(NSError *error) {
            [self.delegate noNetwork];
        }];
    }
}

- (void)checkValidCode:(NSString *)validCode withUserName:(NSString *)userName
{
    GXCodeParam *params = [GXCodeParam verifyAccountParamWithUserName:userName code:validCode];
    [GXEMailHttpTool verifyAccountInfoWithParams:params succeed:^(GXUserExistResult *result) {
        if (result.status == 0) {
            [self.delegate wrongValidCode];
        } else {
            [self.delegate correctValidCode];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
}

- (void)resetPassWordWithUserName:(NSString *)userName password:(NSString *)password validityCode:(NSString *)validityCode
{
    GXResetPasswordParam *param = [GXResetPasswordParam paramWithUserName:userName password:password validityCode:validityCode];
    
    [GXEMailHttpTool repeatPasswordInfoWithParams:param succeed:^(GXUserExistResult *result) {
        if (result.status == 0 || result.status == 2) {
            [self.delegate registerOrResetFailed];
        } else if (result.status == 1) {
            [self.delegate registerOrResetSucceed];
        } else {
            [self.delegate registerOrResetFailed];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
}

- (void)registerWithUserName:(NSString *)userName nickname:(NSString *)nickname password:(NSString *)password validityCode:(NSString *)validityCode
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [GXResourceHelper getDeviceInfo:[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]];
    //NSString *systemVersion = [GXResourceHelper getDeviceInfo:[NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding]];
    NSString *phoneInfo = [NSString stringWithFormat:@"%@,%@",deviceString, [kUserDefault valueForKey:DEFAULT_DEVICE_TOKEN]];
    
    GXUserRegisterParam *param = [[GXUserRegisterParam alloc] init];
    param.phone_info = phoneInfo;
    param.username = userName;
    param.nickname = nickname;
    param.password = password;
    param.validityCode = validityCode;
    
    [GXLoginHttpTool postWithRegisterParams:param succeed:^(GXRegisterResult *result) {
        if (result.status == 0 || result.status == 2) {
            [self.delegate registerOrResetFailed];
        } else if (result.status == 1) {
            [self initializeDatabaseWithData:result andParam:param];
        } else {
            [self.delegate registerOrResetFailed];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
}

- (void)initializeDatabaseWithData:(GXRegisterResult *)result andParam:(GXUserRegisterParam *)param
{
    // 必须放在主线程里执行
    dispatch_async(dispatch_get_main_queue(), ^{
        [kUserDefault setBool:false forKey:DEFAULT_LOGOUT_STATUS];
        [kUserDefault setObject:result.uuid forKey:DEFAULT_USER_UUID];
        [kUserDefault setObject:param.username forKey:DEFAULT_USER_NAME];
        [kUserDefault setObject:param.password forKey:DEFAULT_USER_PASSWORD];
        [kUserDefault setObject:param.nickname forKey:DEFAULT_USER_NICKNAME];
        [kUserDefault setObject:[NSNumber numberWithInteger:DefaultUnlockModeManul] forKey:DEFAULT_UNLOCK_MODE];
        [kUserDefault synchronize];
        
        
        // 与miPush绑定
        [[zkeyMiPushPackage sharedMiPush] setAccount:param.username];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_NICKNAME_NOTIFICATION object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UNLOCK_MODE_CHANGE_NOTIFICATION object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:APPLICATION_DID_BECOME_ACTIVE_NOTIFICATION object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TRANSFORM_TO_DEVICE_LIST_NOTIFICATION object:nil];
        
        [self.delegate registerOrResetSucceed];
    });
    
    
}

@end
