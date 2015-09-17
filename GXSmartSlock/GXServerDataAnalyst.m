//
//  GXServerDataAnalyst.m
//  GXSmartSlock
//
//  Created by zkey on 8/22/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXServerDataAnalyst.h"

#import "MICRO_COMMON.h"
#import "MICRO_SERVER_DATA.h"

#import "GXDeviceModel.h"
#import "GXDeviceUserMappingModel.h"
#import "GXUserModel.h"
#import "GXUnlockRecordModel.h"

#import "GXDatabaseHelper.h"
#import "zkeyMiPushPackage.h"

@implementation GXServerDataAnalyst

+ (void)login:(NSDictionary *)data
{
    //NSLog(@"%@", data);
    
    GXUserModel *defaultUser = [[GXUserModel alloc] init];
    defaultUser.userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    defaultUser.userID = [[data objectForKey:LOGIN_KEY_USER_ID] integerValue];
    defaultUser.nickname = [data objectForKey:LOGIN_KEY_USER_NICKNAME];
    [GXDatabaseHelper setDefaultUser:defaultUser];
    
    NSArray *deviceList = [data objectForKey:LOGIN_KEY_DEVICE_LIST];
    [self insertDeviceIntoDatabase:deviceList];
    
    NSArray *userList = [data objectForKey:LOGIN_KEY_USER_LIST];
    [self insertUserIntoDatabase:userList];
    
    NSArray *deviceUserMappingList = [data objectForKey:LOGIN_KEY_DEVICE_USER_MAPPING_LIST];
    [self insertDeviceUserMappingItemIntoDatabase:deviceUserMappingList];
}

+ (void)insertDeviceIntoDatabase:(NSArray *)deviceArray
{
    NSMutableArray *deviceModelArray = [NSMutableArray array];
    
    for (NSDictionary *deviceDic in deviceArray) {
        GXDeviceModel *deviceModel = [[GXDeviceModel alloc] init];
        
        deviceModel.deviceBattery = [[deviceDic objectForKey:DEVICE_KEY_BATTERY] integerValue];
        deviceModel.deviceCategory = [deviceDic objectForKey:DEVICE_KEY_CATEGORY];
        deviceModel.deviceID = [[deviceDic objectForKey:DEVICE_KEY_ID] integerValue];
        deviceModel.deviceIdentifire = [deviceDic objectForKey:DEVICE_KEY_IDENTIFIRE];
        deviceModel.deviceKey = [deviceDic objectForKey:DEVICE_KEY_UNLOCK_KEY];
        deviceModel.deviceVersion = [[deviceDic objectForKey:DEVICE_KEY_VERSION] integerValue];
        
        [deviceModelArray addObject:deviceModel];
    }
    
    [GXDatabaseHelper insertDeviceIntoDatabase:deviceModelArray];
}

+ (void)insertDeviceUserMappingItemIntoDatabase:(NSArray *)deviceUserMappingItemArray
{
    NSMutableArray *deviceUserMappingModelArray = [NSMutableArray array];
    
    for (NSDictionary *deviceUserMappingDic in deviceUserMappingItemArray) {
        GXDeviceUserMappingModel *deviceUserMappingModel = [[GXDeviceUserMappingModel alloc] init];
    
        deviceUserMappingModel.deviceUserMappingID = [[deviceUserMappingDic objectForKey:MAPPING_KEY_ID] integerValue];
        deviceUserMappingModel.deviceIdentifire = [deviceUserMappingDic objectForKey:MAPPING_KEY_DEVICE_IDENTIFIRE];
        deviceUserMappingModel.userName = [deviceUserMappingDic objectForKey:MAPPING_KEY_DEVICE_USER];
        deviceUserMappingModel.deviceNickname = [deviceUserMappingDic objectForKey:MAPPING_KEY_DEVICE_NICKNAME];
        deviceUserMappingModel.deviceStatus = [deviceUserMappingDic objectForKey:MAPPING_KEY_DEVICE_STATUS];
        deviceUserMappingModel.deviceAuthority = [deviceUserMappingDic objectForKey:MAPPING_KEY_DEVICE_AUTHORITY];
        
        [deviceUserMappingModelArray addObject:deviceUserMappingModel];
    }
    
    [GXDatabaseHelper insertDeviceUserMappingItemIntoDatabase:deviceUserMappingModelArray];
}

+ (void)insertUserIntoDatabase:(NSArray *)userArray
{
    NSMutableArray *userModelArray = [NSMutableArray array];
    
    for (NSDictionary *userDic in userArray) {
        GXUserModel *userModel = [[GXUserModel alloc] init];
        
        userModel.userID = [[userDic objectForKey:USER_KEY_ID] integerValue];
        userModel.nickname = [userDic objectForKey:USER_KEY_NICKNAME];
        userModel.userName = [userDic objectForKey:USER_KEY_USER_NAME];
        
        [userModelArray addObject:userModel];
    }
    
    [GXDatabaseHelper insertUserIntoDatabase:userModelArray];
}

+ (void)insertUnlockRecordIntoDatabase:(NSArray *)unlockRecordArray
{
    NSMutableArray *unlockRecordModelArray = [NSMutableArray array];
    
    for (NSDictionary *unlockRecordDic in unlockRecordArray) {
        GXUnlockRecordModel *unlockRecordModel = [[GXUnlockRecordModel alloc] init];
        
        unlockRecordModel.unlockRecordID = [[unlockRecordDic objectForKey:UNLOCK_RECORD_KEY_ID] integerValue];
        unlockRecordModel.deviceIdentifire = [unlockRecordDic objectForKey:UNLOCK_RECORD_KEY_DEVICE_IDENTIFIRE];
        unlockRecordModel.event = [unlockRecordDic objectForKey:UNLOCK_RECORD_KEY_EVENT];
        
        NSTimeInterval timeInterval = [[unlockRecordDic objectForKey:UNLOCK_RECORD_KEY_TIME_INTERVAL] doubleValue];
        timeInterval /= 1000.0f;
        unlockRecordModel.date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        
        NSInteger eventType = [[unlockRecordDic objectForKey:UNLOCK_RECORD_KEY_EVENT_TYPE] integerValue];
        if (eventType == 1 || eventType == 2 || eventType == 3 || eventType == 4 || eventType == 5 || eventType == 8 || eventType == 9 || eventType == 10) {
            unlockRecordModel.relatedUserName = [unlockRecordDic objectForKey:UNLOCK_RECORD_KEY_RECEIVER_EMAIL];
        } else if (eventType == 6 || eventType == 7) {
            unlockRecordModel.relatedUserName = [unlockRecordDic objectForKey:UNLOCK_RECORD_KEY_SENDER_EMAIL];
        }
        unlockRecordModel.eventType = eventType;
        
        [unlockRecordModelArray addObject:unlockRecordModel];
    }
    
    [GXDatabaseHelper insertUnlockRecordIntoDatabase:unlockRecordModelArray];
}


@end
