//
//  MICRO_HTTP.h
//  GXSmartSlock
//
//  Created by zkey on 8/23/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#ifndef GXSmartSlock_MICRO_HTTP_h
#define GXSmartSlock_MICRO_HTTP_h

#define GXBaseURL @"https://115.28.226.149:443/"

#define GXLoginURL [NSString stringWithFormat:@"%@user_exist", GXBaseURL]
#define GXGetVerificationCodeForRegisetURL [NSString stringWithFormat:@"%@submit_account", GXBaseURL]
#define GXGetVerificationCodeForResetPasswordURL [NSString stringWithFormat:@"%@submit_account_reset_pw", GXBaseURL]
#define GXVerifyCodeURL [NSString stringWithFormat:@"%@verify_account", GXBaseURL]
#define GXRegisterURL [NSString stringWithFormat:@"%@user_register", GXBaseURL]
#define GXResetPasswordURL [NSString stringWithFormat:@"%@reset_password",GXBaseURL]
#define GXChangeDeviceNicknameURL [NSString stringWithFormat:@"%@update_devicename",GXBaseURL]

// delete all device and it's user when defaultUser is administator
#define GXDeleteDeviceURL [NSString stringWithFormat:@"%@delete_device",GXBaseURL]

// only delete the current user from the device's users
#define GXDeleteSelfKeyURL [NSString stringWithFormat:@"%@delete_self_key",GXBaseURL]

#define GXUploadUserHeadImageURL [NSString stringWithFormat:@"%@update_profile", GXBaseURL]

#define GXUpdateUserNicknameURL [NSString stringWithFormat:@"%@update_nickname", GXBaseURL]

#define GXUpdateUserPasswordURL [NSString stringWithFormat:@"%@update_password", GXBaseURL]

#define GXDeleteAuthorizedUserURL [NSString stringWithFormat:@"%@delete_key", GXBaseURL]

#define GXSynchronizeDeviceUserURL [NSString stringWithFormat:@"%@sync_key", GXBaseURL]

#define GXSynchronizeDeviceURL [NSString stringWithFormat:@"%@sync_device", GXBaseURL]

#define GXRejectKeyURL [NSString stringWithFormat:@"%@delete_self_key", GXBaseURL]

#define GXReceiveKeyURL [NSString stringWithFormat:@"%@receive_key", GXBaseURL]

#define GXAddNewDeviceURL [NSString stringWithFormat:@"%@setup_device", GXBaseURL]

#define GXSynchronizeUnlockRecordURL [NSString stringWithFormat:@"%@sync_record", GXBaseURL]

#define GXSendKeyURL [NSString stringWithFormat:@"%@send_key", GXBaseURL]

#define GXLastFirewareVersionURL [NSString stringWithFormat:@"%@fw_version", GXBaseURL]

#define GXUpdateDeviceBatteryURL [NSString stringWithFormat:@"%@update_device_battery", GXBaseURL]

#define GXUploadUnlockRecordURL [NSString stringWithFormat:@"%@push_old_record", GXBaseURL]

#define GXUploadDeviceVersionURL [NSString stringWithFormat:@"%@update_device_version", GXBaseURL]

#define KEY_USER_NAME @"username"
#define KEY_PASSWORD @"password"
#define KEY_PHONE_INFO @"phone_info"
#define KEY_VERIFICATION_CODE @"code"
#define KEY_NICKNAME @"nickname"
#define KEY_DEVICE_IDENTIFIRE @"device_id"
#define KEY_DEVICE_NICKNAME @"device_name"
#define KEY_USER_HEAD_IMAGE_STRING @"profile_img"
#define KEY_NEW_NICKNAME @"nnickname"
#define KEY_NEW_PASSWORD @"npassword"
#define KEY_DELETED_USER_NAME @"contact"
#define KEY_DEVICE_SECRET_KEY @"key"
#define KEY_DEVICE_VERSION @"device_version"
#define KEY_DEVICE_LOCATION @"device_location"
#define KEY_DEVICE_BATTERY @"device_battery"
#define KEY_DEVICE_CATEGORY @"device_typecode"
#define KEY_AUTHORITY_TYPE @"key_type"
#define KEY_RECEIVER_USER_NAME @"contact"
#define KEY_UNLOCK_EVENT @"event"
#define KEY_UNLOCK_EVENT_TYPE @"event_type"
#define KEY_UNLOCK_DATE @"date"


#endif
