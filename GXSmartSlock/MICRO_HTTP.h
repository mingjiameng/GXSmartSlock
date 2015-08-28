//
//  MICRO_HTTP.h
//  GXSmartSlock
//
//  Created by zkey on 8/23/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#ifndef GXSmartSlock_MICRO_HTTP_h
#define GXSmartSlock_MICRO_HTTP_h

#define GXBaseURL @"https://115.28.226.149/"

#define GXLoginURL [NSString stringWithFormat:@"%@user_exist", GXBaseURL]
#define GXGetVerificationCodeForRegisetURL [NSString stringWithFormat:@"%@submit_account", GXBaseURL]
#define GXGetVerificationCodeForResetPasswordURL [NSString stringWithFormat:@"%@submit_account_reset_pw", GXBaseURL]
#define GXVerifyCodeURL [NSString stringWithFormat:@"%@verify_account", GXBaseURL]
#define GXRegisterURL [NSString stringWithFormat:@"%@user_register", GXBaseURL]
#define GXResetPasswordURL [NSString stringWithFormat:@"%@reset_password",GXBaseURL]
#define GXChangeDeviceNicknameURL [NSString stringWithFormat:@"%@update_devicename",GXBaseURL]


#define KEY_USER_NAME @"username"
#define KEY_PASSWORD @"password"
#define KEY_PHONE_INFO @"phone_info"
#define KEY_VERIFICATION_CODE @"code"
#define KEY_NICKNAME @"nickname"
#define KEY_DEVICE_IDENTIFIRE @"device_id"
#define KEY_DEVICE_NICKNAME @"device_name"

#endif
