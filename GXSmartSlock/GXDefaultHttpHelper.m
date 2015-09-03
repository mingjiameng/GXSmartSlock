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
#import "GXVerifyCodeParam.h"
#import "GXRegisterParam.h"
#import "GXResetPasswordParam.h"
#import "GXChangeDeviceNicknameParam.h"
#import "GXDeleteDeviceParam.h"
#import "GXUpdateProfileImageParam.h"
#import "GXUpdateNicknameParam.h"
#import "GXUpdatePasswordParam.h"
#import "GXDeleteAuthorizedUserParam.h"
#import "GXSynchronizeDeviceUserParam.h"
#import "GXSynchronizeDeviceParam.h"

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

+ (void)postWithVerifyCodeParam:(GXVerifyCodeParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure
{
    NSDictionary *paramDic = @{KEY_USER_NAME : param.userName,
                               KEY_VERIFICATION_CODE : param.verificationCode};
    
    
    [GXHttpTool postWithServerURL:GXVerifyCodeURL params:paramDic success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSError *error) {
        if (error != nil) {
            NSLog(@"核对验证码失败");
            failure(error);
        }
    }];
    
}

+ (void)postWithRegisterParam:(GXRegisterParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure
{
    NSDictionary *paramDic = @{KEY_USER_NAME : param.userName,
                               KEY_PASSWORD : param.password,
                               KEY_VERIFICATION_CODE : param.verificationCode,
                               KEY_NICKNAME : param.nickname,
                               KEY_PHONE_INFO : param.phoneInfo};
    
    [GXHttpTool postWithServerURL:GXRegisterURL params:paramDic success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSError *error) {
        if (error != nil) {
            NSLog(@"注册失败");
            failure(error);
        }
    }];
}

+ (void)postWithResetPasswordParam:(GXResetPasswordParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
{
    NSDictionary *paramDic = @{KEY_USER_NAME : param.userName,
                               KEY_PASSWORD : param.password,
                               KEY_VERIFICATION_CODE : param.verificationCode};
    
    [GXHttpTool postWithServerURL:GXResetPasswordURL params:paramDic success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSError *error) {
        if (error != nil) {
            NSLog(@"重置密码失败");
            failure(error);
        }
    }];
}

+ (void)postWithChangeDeviceNicknameParam:(GXChangeDeviceNicknameParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure
{
    NSDictionary *paramDic = @{KEY_USER_NAME : param.userName,
                               KEY_PASSWORD : param.password,
                               KEY_DEVICE_IDENTIFIRE : param.deviceIdentifire,
                               KEY_DEVICE_NICKNAME : param.deviceNickname};
    
    [GXHttpTool postWithServerURL:GXChangeDeviceNicknameURL params:paramDic success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSError *error) {
        if (error != nil) {
            NSLog(@"更改设备昵称失败");
            failure(error);
        }
    }];
}

+ (void)postWithDeleteDeviceParam:(GXDeleteDeviceParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure
{
    NSDictionary *paramDic = @{KEY_USER_NAME : param.userName,
                               KEY_PASSWORD : param.password,
                               KEY_DEVICE_IDENTIFIRE : param.deviceIdentifire};
    
    NSString *urlString = GXDeleteSelfKeyURL;
    if ([param.deviceAuthority isEqualToString:@"admin"]) {
        urlString = GXDeleteDeviceURL;
    } else {
        urlString = GXDeleteSelfKeyURL;
    }
    
    [GXHttpTool postWithServerURL:urlString params:paramDic success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSError *error) {
        if (error != nil) {
            NSLog(@"删除门锁失败");
            failure(error);
        }
    }];
}

+ (void)postwithUpdateProfileImageParam:(GXUpdateProfileImageParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure
{
    NSDictionary *paramDic = @{KEY_USER_NAME : param.userName,
                               KEY_PASSWORD : param.password,
                               KEY_USER_HEAD_IMAGE_STRING : param.imageBase64String};
    
    [GXHttpTool postWithServerURL:GXUploadUserHeadImageURL params:paramDic success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSError *error) {
        if (error != nil) {
            NSLog(@"更换头像失败");
            failure(error);
        }
    }];
}

+ (void)postWithUpdateNicknameParam:(GXUpdateNicknameParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure
{
    NSDictionary *paramDic = @{KEY_USER_NAME : param.userName,
                               KEY_PASSWORD : param.password,
                               KEY_NEW_NICKNAME : param.nickname};
    
    [GXHttpTool postWithServerURL:GXUpdateUserNicknameURL params:paramDic success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSError *error) {
        if (error != nil) {
            NSLog(@"更新昵称失败");
            failure(error);
        }
    }];
}

+ (void)postWithUpdatePasswordParam:(GXUpdatePasswordParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure
{
    NSDictionary *paramDic = @{KEY_USER_NAME : param.userName,
                               KEY_PASSWORD : param.password,
                               KEY_NEW_PASSWORD : param.nPassword};
    
    [GXHttpTool postWithServerURL:GXUpdateUserPasswordURL params:paramDic success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSError *error) {
        if (error != nil) {
            NSLog(@"更改密码失败");
            failure(error);
        }
    }];
}

+ (void)postWithDeleteAuthorizedUserParam:(GXDeleteAuthorizedUserParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure
{
    NSDictionary *paramDic = @{KEY_USER_NAME : param.userName,
                               KEY_PASSWORD : param.password,
                               KEY_DEVICE_IDENTIFIRE : param.deviceIdentifire,
                               KEY_DELETED_USER_NAME : param.deletedUserName};
    
    
    [GXHttpTool postWithServerURL:GXDeleteAuthorizedUserURL params:paramDic success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSError *error) {
        if (error != nil) {
            NSLog(@"删除授权用户失败");
            failure(error);
        }
    }];
}

+ (void)postWithSynchronizeDeviceUserParam:(GXSynchronizeDeviceUserParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure
{
    NSDictionary *paramDic = @{KEY_USER_NAME : param.userName,
                               KEY_PASSWORD : param.password,
                               KEY_DEVICE_IDENTIFIRE : param.deviceIdentifire};
    
    [GXHttpTool postWithServerURL:GXSynchronizeDeviceUserURL params:paramDic success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSError *error) {
        if (error != nil) {
            NSLog(@"同步设备用户失败");
            failure(error);
        }
    }];
}

+ (void)postWithSynchronizeDeviceParam:(GXSynchronizeDeviceParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure
{
    NSDictionary *paramDic = @{KEY_USER_NAME : param.userName,
                               KEY_PASSWORD : param.password};
    
    [GXHttpTool postWithServerURL:GXSynchronizeDeviceURL params:paramDic success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSError *error) {
        if (error != nil) {
            NSLog(@"同步设备失败");
            failure(error);
        }
    }];
    
}
@end
