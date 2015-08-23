//
//  GXDefaultHttpHelper.m
//  GXSmartSlock
//
//  Created by zkey on 8/23/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXDefaultHttpHelper.h"
#import "GXHttpTool.h"

#import "MICRO_HTTP.h"

#import "GXLoginParam.h"
#import "GXGetVerificationCodeParam.h"

@implementation GXDefaultHttpHelper

+ (void)postWithLoginParam:(GXLoginParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure
{
    NSDictionary *paramDic = @{KEY_USER_NAME : param.userName,
                               KEY_PASSWORD : param.password,
                               KEY_PHONE_INFO : param.phoneInfo};
    
    [GXHttpTool postWithServerURL:GXLoginURL params:paramDic success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSError *error) {
        if (error != nil) {
            NSLog(@"登录失败");
            failure(error);
        }
    }];
}

+ (void)postWithGetVerificationCodeParam:(GXGetVerificationCodeParam *)param codeType:(VerificationCodeType)type success:(HttpSuccess)success failure:(HttpFailure)failure
{
    NSDictionary *paramDic = @{KEY_USER_NAME : param.userName};
    
    if (type == VerificationCodeTypeRegister) {
        [GXHttpTool postWithServerURL:GXGetVerificationCodeForRegisetURL params:paramDic success:^(NSDictionary *result) {
            success(result);
        } failure:^(NSError *error) {
            if (error != nil) {
                NSLog(@"注册获取验证码失败");
                failure(error);
            }
        }];
    } else if (type == VerificationCodeTypeResetPassword) {
        [GXHttpTool postWithServerURL:GXGetVerificationCodeForResetPasswordURL params:paramDic success:^(NSDictionary *result) {
            success(result);
        } failure:^(NSError *error) {
            if (error != nil) {
                NSLog(@"重置密码获取验证码失败");
                failure(error);
            }
        }];
    } else {
        NSLog(@"error: get verification code interface receive unrecognized param named type:%ld", (long)type);
    }
    
}

@end
