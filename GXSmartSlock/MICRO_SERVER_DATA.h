//
//  MICRO_SERVER_DATA.h
//  GXSmartSlock
//
//  Created by zkey on 8/22/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#ifndef GXSmartSlock_MICRO_SERVER_DATA_h
#define GXSmartSlock_MICRO_SERVER_DATA_h

// key in dicationary "login"
#define LOGIN_KEY_USER_ID @"user_id"
#define LOGIN_KEY_USER_NICKNAME @"nickname"
#define LOGIN_KEY_DEVICE_LIST @"devices"
#define LOGIN_KEY_DEVICE_USER_MAPPING_LIST @"mappings"
#define LOGIN_KEY_RECORD_LIST @"records"
#define LOGIN_KEY_USER_LIST @"users"

// key in dictionary "device"
#define DEVICE_KEY_ID @"id"
#define DEVICE_KEY_CATEGORY @"category"
#define DEVICE_KEY_BATTERY @"device_battery"
#define DEVICE_KEY_UNLOCK_KEY @"device_key"
#define DEVICE_KEY_VERSION @"device_version"
#define DEVICE_KEY_IDENTIFIRE @"device_id"

// key in dictionary "mappings"
#define MAPPING_KEY_DEVICE_IDENTIFIRE @"device_id"
#define MAPPING_KEY_DEVICE_NICKNAME @"device_name"
#define MAPPING_KEY_DEVICE_USER @"email"
#define MAPPING_KEY_DEVICE_STATUS @"status"
#define MAPPING_KEY_DEVICE_AUTHORITY @"type"
#define MAPPING_KEY_ID @"id"

// key in dictionary "user"
#define USER_KEY_ID @"id"
#define USER_KEY_NICKNAME @"nickname"
#define USER_KEY_USER_NAME @"email"

#endif
