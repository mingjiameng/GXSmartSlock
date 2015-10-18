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
#define DEVICE_KEY_CATEGORY @"typecode"
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


#define UNLOCK_RECORD_KEY_ID @"id"
#define UNLOCK_RECORD_KEY_DEVICE_IDENTIFIRE @"deviceId"
#define UNLOCK_RECORD_KEY_EVENT @"event"
#define UNLOCK_RECORD_KEY_EVENT_TYPE @"event_type"
#define UNLOCK_RECORD_KEY_RECEIVER_EMAIL @"receiver_email"
#define UNLOCK_RECORD_KEY_SENDER_EMAIL @"sender_email"
#define UNLOCK_RECORD_KEY_TIME_INTERVAL @"timeVal"

#define USER_REMARK_NAME_KEY_ID @"id"
#define USER_REMARK_NAME_KEY_CONTACT @"account_contact"
#define USER_REMARK_NAME_KEY_ALIAS @"alias"



#endif
