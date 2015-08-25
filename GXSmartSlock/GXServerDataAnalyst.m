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

#import "GXDatabaseHelper.h"

@implementation GXServerDataAnalyst

+ (void)login:(NSDictionary *)data
{
    NSLog(@"%@", data);
    
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

@end
