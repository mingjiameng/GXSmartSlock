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
#import "GXVerifyCodeParam.h"
#import "GXRegisterParam.h"
#import "GXResetPasswordParam.h"

#import "GXDefaultHttpHelper.h"
#import "zkeyMiPushPackage.h"
#import "GXLoginModel.h"
#import "GXSystemInfoHelper.h"

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
    GXVerifyCodeParam *param = [GXVerifyCodeParam paramWithUserName:userName verificationCode:validCode];
    
    [GXDefaultHttpHelper postWithVerifyCodeParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:GET_VERIFICATION_CODE_STATUS] integerValue];
        if (status == 0) {
            [self.delegate wrongValidCode];
        } else if (status == 1) {
            [self.delegate correctValidCode];
        }
    } failure:^(NSError *error) {
        [self.delegate correctValidCode];
    }];
}

- (void)resetPassWordWithUserName:(NSString *)userName password:(NSString *)password validityCode:(NSString *)validityCode
{
    GXResetPasswordParam *param = [GXResetPasswordParam paramWithUserName:userName password:password verificationCode:validityCode];
    
    [GXDefaultHttpHelper postWithResetPasswordParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:RESET_PASSWORD_STATUS] integerValue];
        
        if (status == 0 || status == 2) {
            [self.delegate registerOrResetFailed];
        } else if (status == 1) {
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
    NSString *deviceString = [GXSystemInfoHelper getDeviceInfo:[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]];
    //NSString *systemVersion = [GXResourceHelper getDeviceInfo:[NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding]];
    NSString *phoneInfo = [NSString stringWithFormat:@"%@,%@",deviceString, [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_DEVICE_TOKEN]];
    
    GXRegisterParam *param = [GXRegisterParam paramWithUserName:userName nickname:nickname password:password verificationCode:validityCode phoneInfo:phoneInfo];
    
    [GXDefaultHttpHelper postWithRegisterParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:RESET_PASSWORD_STATUS] integerValue];
        
        if (status == 0 || status == 2) {
            [self.delegate registerOrResetFailed];
        } else if (status == 1) {
            [GXLoginModel initializeDatabaseWithData:result userName:userName password:password];
        } else {
            [self.delegate registerOrResetFailed];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
    
}

@end
