//
//  MICRO_COMMON.h
//  GXSmartSlock
//
//  Created by zkey on 8/20/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

// unlock mode
typedef NS_ENUM(NSInteger, DefaultUnlockMode) {
    DefaultUnlockModeAuto = 10,
    DefaultUnlockModeManul = 20,
    DefaultUnlockModeShake = 30
};

#ifndef GXSmartSlock_MICRO_COMMON_h
#define GXSmartSlock_MICRO_COMMON_h

#define NAVIGATION_BASED_TOP_SPACE 64.0f

// application tint color
#define MAIN_COLOR [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:229.0/255/0 alpha:1.0]

// data store in [NSUserDefaults standardUserDefaults]
#define DEFAULT_USER_NAME @"defaultUserName"
#define DEFAULT_USER_PASSWORD @"defaultUserPassword"
#define DEFAULT_LOGIN_STATUS @"loginStatus"
#define USER_HEAD_IMAGE_FILE_PATH @"userHeadImageFilePath"
#define APP_VERSION @"appVersion"
#define DEFAULT_DEVICE_TOKEN @"deviceToken"
#define PREVIOUS_USER_NAME @"previousUserName"
#define DEFAULT_GESTURE_PASSWORD @"defaultGesturePassword"
#define DEFAULT_UNLOCK_MODE @"defaultUnlockModel"

// screen size parameter
#define TOP_SPACE_IN_NAVIGATION_MODE 64.0
#define BOTTOM_SPACE_IN_TAB_MODE 44.0


// system version
#define IOS8_OR_LATER ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)

// third party framework information
#define WEIXIN_GUOSIM_ID @"wxd5b207c3ecc53a2e"


// notification
#define NOTIFICATION_UPDATE_PROFILE_IMAGE @"updateProfileImageNotification"


#endif
