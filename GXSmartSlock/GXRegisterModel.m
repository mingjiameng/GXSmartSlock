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
#import "MICRO_SERVER_INTERFACE.h"

#import "GXGetVerificationCodeParam.h"

#import "GXDefaultHttpHelper.h"
#import "zkeyMiPushPackage.h"
#import "GXLoginModel.h"

#import <sys/utsname.h>

@implementation GXRegisterModel

- (void)getValidCode:(NSString *)userName withType:(RegisterViewType)type
{
    GXGetVerificationCodeParam *param = [GXGetVerificationCodeParam paramWithUserName:userName];
    
    VerificationCodeType codeType = VerificationCodeTypeRegister;
    if (type == RegisterViewTypeRegister) {
        codeType = VerificationCodeTypeRegister;
    } else if (type == RegisterViewTypeForgetPassword) {
        codeType = VerificationCodeTypeResetPassword;
    }
    
    [GXDefaultHttpHelper postWithGetVerificationCodeParam:param codeType:codeType success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:GET_VERIFICATION_CODE_STATUS] integerValue];
        if (status == 0) {
            [self.delegate invalidUserName];
        } else if (status == 1) {
            [self.delegate validUserName];
        }
        
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
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

- (void)initializeDatabaseWithData:(GXRegisterResult *)result userName:(NSString *)userName password:(NSString *)password
{
    [GXLoginModel initializeDatabaseWithData:result userName:userName password:password];
}

@end
