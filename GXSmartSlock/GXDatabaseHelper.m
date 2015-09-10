//
//  GXDatabaseHelper.m
//  GXSmartSlock
//
//  Created by zkey on 8/21/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

/*****************************READ ME********************************
 * defaultUser here 
 *****************************READ ME*******************************/

#import "GXDatabaseHelper.h"
#import "AppDelegate.h"

#import "MICRO_COMMON.h"
#import "MICRO_COREDATA.h"
#import "MICRO_DEVICE_LIST.h"

#import "GXDeviceModel.h"
#import "GXDeviceUserMappingModel.h"
#import "GXUserModel.h"
#import "GXUnlockRecordModel.h"

#import "GXDatabaseEntityDevice.h"
#import "GXDatabaseEntityDeviceUserMappingItem.h"
#import "GXDatabaseEntityUser.h"
#import "GXDatabaseEntityUnlockRecord.h"

#import <Foundation/Foundation.h>


@implementation GXDatabaseHelper

/*
 * the following methods undertake the data interaction with server
 * they receiver parameter(entity model array) for GXServerDataAnalyst and save data to local database properly
 */

// ... receive data for GXServerDataAnalyst
// ... the deviceArray contains GXDeviceModel object
// ... but the data GXDeviceModel object contains here exclude "deviceNickname"\"deviceStatus"\"deviceAuthority"
// ... for that "deviceNickname"\"deviceStatus"\"deviceAuthority" in server database is storaged in "Mapping" table
// ... so server does not return us these data when we request data from "device" table
+ (void)setDefaultUser:(GXUserModel *)user
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    GXDatabaseEntityUser *defaultUserEntity = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_USER inManagedObjectContext:managedObjectContext];
    
    defaultUserEntity.userID = [NSNumber numberWithInteger:user.userID];
    defaultUserEntity.nickname = user.nickname;
    defaultUserEntity.userName = user.userName;
    defaultUserEntity.headImageURL = [NSString stringWithFormat:@"https://115.28.226.149/user_profile?user_id=%ld.jpg", (long)user.userID];
    
    [self saveContext];
}

+ (void)insertDeviceIntoDatabase:(NSArray *)deviceArray
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    deviceArray = [deviceArray sortedArrayUsingComparator:^NSComparisonResult(GXDeviceModel *obj1, GXDeviceModel *obj2) {
        if (obj2.deviceID < obj1.deviceID) {
            return NSOrderedAscending;
        } else if (obj2.deviceID == obj1.deviceID) {
            return NSOrderedSame;
        } else {
            return NSOrderedDescending;
        }
    }];
    NSArray *localDeviceArray = [self allDeviceArray];
    
    NSMutableArray *deviceNeedToInsert = [NSMutableArray array];
    NSInteger index01 = 0, index02 = 0;
    NSInteger indexBorder01 = deviceArray.count;
    NSInteger indexBorder02 = localDeviceArray.count;
    NSInteger deviceID01, deviceID02;
    
    while (index01 < indexBorder01 && index02 < indexBorder02) {
        GXDeviceModel *deviceModel = [deviceArray objectAtIndex:index01];
        GXDatabaseEntityDevice *deviceEntity = [localDeviceArray objectAtIndex:index02];
        deviceID01 = deviceModel.deviceID;
        deviceID02 = [deviceEntity.deviceID integerValue];
        
        if (deviceID01 > deviceID02) {
            [deviceNeedToInsert addObject:deviceModel];
            ++index01;
            continue;
        }
        
        if (deviceID01 == deviceID02) {
            // ... Attention! - we have no needs to update device battery level once we store the device info in local
            // ... because that we don't update the device battery to server when we unlock the door
//            NSNumber *batteryNumber = deviceEntity.deviceBattery;
//            if ([batteryNumber integerValue] != deviceModel.deviceBattery) {
//                batteryNumber = [NSNumber numberWithInteger:deviceModel.deviceBattery];
//                deviceEntity.deviceBattery = batteryNumber;
//            }
            
            // update version number
            NSNumber *versionNumber = deviceEntity.deviceVersion;
            if ([versionNumber integerValue] != deviceModel.deviceVersion) {
                versionNumber = [NSNumber numberWithInteger:deviceModel.deviceVersion];
                deviceEntity.deviceVersion = versionNumber;
            }
            
            ++index01;
            ++index02;
            continue;
        }
        
        if (deviceID01 < deviceID02) {
            [managedObjectContext deleteObject:deviceEntity];
            ++index02;
            continue;
        }
        
    }
    
    for (; index01 < indexBorder01; ++index01) {
        [deviceNeedToInsert addObject:[deviceArray objectAtIndex:index01]];
    }
    
    for (; index02 < indexBorder02; ++index02) {
        [managedObjectContext deleteObject:[localDeviceArray objectAtIndex:index02]];
    }
    
    for (GXDeviceModel *deviceModel in deviceNeedToInsert) {
        GXDatabaseEntityDevice *newDeviceEntity = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_DEVICE inManagedObjectContext:managedObjectContext];
        
        newDeviceEntity.deviceBattery = [NSNumber numberWithInteger:deviceModel.deviceBattery];
        newDeviceEntity.deviceCategory = deviceModel.deviceCategory;
        newDeviceEntity.deviceID = [NSNumber numberWithInteger:deviceModel.deviceID];
        newDeviceEntity.deviceIdentifire = deviceModel.deviceIdentifire;
        newDeviceEntity.deviceKey = deviceModel.deviceKey;
        newDeviceEntity.deviceVersion = [NSNumber numberWithInteger:deviceModel.deviceVersion];
        
        // set the default value for some info
        newDeviceEntity.deviceStatus = DEVICE_STATUS_INVALID;
        newDeviceEntity.deviceAuthority = DEVICE_AUTHORITY_NORMAL;
        newDeviceEntity.deviceNickname = @"nickname";
    }
    
    [self saveContext];
    
    NSLog(@"successfully insert device");
}

+ (void)insertDeviceUserMappingItemIntoDatabase:(NSArray *)deviceUserMappingArray
{
    NSString *defaultUserName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    deviceUserMappingArray = [deviceUserMappingArray sortedArrayUsingComparator:^NSComparisonResult(GXDeviceUserMappingModel *obj1, GXDeviceUserMappingModel *obj2) {
        if (obj2.deviceUserMappingID < obj1.deviceUserMappingID) {
            return NSOrderedAscending;
        } else if (obj2.deviceUserMappingID == obj1.deviceUserMappingID) {
            return NSOrderedSame;
        } else {
            return NSOrderedDescending;
        }
    }];
    NSArray *localDeviceUserMappingArray = [self allDeviceUserMappingArray];
    
    NSMutableArray *deviceUserMappingNeedToInsert = [NSMutableArray array];
    NSInteger index01 = 0, index02 = 0;
    NSInteger indexBorder01 = deviceUserMappingArray.count;
    NSInteger indexBorder02 = localDeviceUserMappingArray.count;
    NSInteger deviceUserMappingID01, deviceUserMappingID02;
    
    while (index01 < indexBorder01 && index02 < indexBorder02) {
        GXDeviceUserMappingModel *deviceUserMappingModel = [deviceUserMappingArray objectAtIndex:index01];
        GXDatabaseEntityDeviceUserMappingItem *deviceUserMappingEntity = [localDeviceUserMappingArray objectAtIndex:index02];
        deviceUserMappingID01 = deviceUserMappingModel.deviceUserMappingID;
        deviceUserMappingID02 = [deviceUserMappingEntity.deviceUserMappingID integerValue];
        
        if (deviceUserMappingID01 > deviceUserMappingID02) {
            [deviceUserMappingNeedToInsert addObject:deviceUserMappingModel];
            ++index01;
            continue;
        }
        
        if (deviceUserMappingID01 == deviceUserMappingID02) {
            // status may need update
            if (![deviceUserMappingModel.deviceStatus isEqualToString:deviceUserMappingEntity.deviceStatus]) {
                deviceUserMappingEntity.deviceStatus = deviceUserMappingModel.deviceStatus;
            }
            
            if (deviceUserMappingEntity.user == nil) {
                GXDatabaseEntityUser *user = [self userEntityWithUserName:deviceUserMappingEntity.userName];
                if (user != nil) {
                    deviceUserMappingEntity.user = user;
                }
            }
            
            // if the device's user is defaultUser, we may need update the nickname of the device
            // what's more
            if ([deviceUserMappingEntity.userName isEqualToString:defaultUserName]) {
                GXDatabaseEntityDevice *correspondDevice = [self deviceEntityWithDeviceIdentifire:deviceUserMappingModel.deviceIdentifire];
                if (![deviceUserMappingModel.deviceNickname isEqualToString:correspondDevice.deviceNickname]) {
                    correspondDevice.deviceNickname = deviceUserMappingModel.deviceNickname;
                }
                
                if (![deviceUserMappingModel.deviceStatus isEqualToString:correspondDevice.deviceStatus]) {
                    correspondDevice.deviceStatus = deviceUserMappingModel.deviceStatus;
                }
                
            }
            
            ++index01;
            ++index02;
            continue;
        }
        
        if (deviceUserMappingID01 < deviceUserMappingID02) {
            [managedObjectContext deleteObject:deviceUserMappingEntity];
            ++index02;
            continue;
        }
    }
    
    for (; index01 < indexBorder01; ++index01) {
        [deviceUserMappingNeedToInsert addObject:[deviceUserMappingArray objectAtIndex:index01]];
    }
    
    for (; index02 < indexBorder02; ++index02) {
        [managedObjectContext deleteObject:[localDeviceUserMappingArray objectAtIndex:index02]];
    }
    
    for (GXDeviceUserMappingModel *deviceUserMappingModel in deviceUserMappingNeedToInsert) {
        GXDatabaseEntityDevice *device = [self deviceEntityWithDeviceIdentifire:deviceUserMappingModel.deviceIdentifire];
        if (device == nil) {
            NSLog(@"error: deviceUserMappingModel has no correspond device with identifire:%@", deviceUserMappingModel.deviceIdentifire);
            continue;
        }
        
        GXDatabaseEntityUser *user = [self userEntityWithUserName:deviceUserMappingModel.userName];
        if (user == nil) {
            NSLog(@"error: deviceUserMappingModel has no correspond user with userName:%@", deviceUserMappingModel.userName);
        }
        
        GXDatabaseEntityDeviceUserMappingItem *newDeviceUserMappingItem = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_DEVICE_USER_MAPPING inManagedObjectContext:managedObjectContext];
        
        newDeviceUserMappingItem.deviceUserMappingID = [NSNumber numberWithInteger:deviceUserMappingModel.deviceUserMappingID];
        newDeviceUserMappingItem.deviceIdentifire = deviceUserMappingModel.deviceIdentifire;
        newDeviceUserMappingItem.userName = deviceUserMappingModel.userName;
        newDeviceUserMappingItem.deviceNickname = deviceUserMappingModel.deviceNickname;
        newDeviceUserMappingItem.deviceStatus = deviceUserMappingModel.deviceStatus;
        newDeviceUserMappingItem.deviceAuthority = deviceUserMappingModel.deviceAuthority;
        
        newDeviceUserMappingItem.device = device;
        
        if (user != nil) {
            newDeviceUserMappingItem.user = user;
        }
        
        
        // if the device user is defaultUser, we need to make up info in correspond device entity
        if ([deviceUserMappingModel.userName isEqualToString:defaultUserName]) {
            device.deviceNickname = deviceUserMappingModel.deviceNickname;
            device.deviceStatus = deviceUserMappingModel.deviceStatus;
            device.deviceAuthority = deviceUserMappingModel.deviceAuthority;
        }
    }
    
    [self saveContext];
    
    NSLog(@"successfully insert deviceUserMapping");
}

+ (void)insertUserIntoDatabase:(NSArray *)userArray
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    // sort the userArray for server and localUserArray in descending order
    // crossing contrast data in userArray and localUserArray in time complexity O(n)
    // to prevent unneccessary delete and insert action
    userArray = [userArray sortedArrayUsingComparator:^NSComparisonResult(GXUserModel *obj1, GXUserModel *obj2) {
        if (obj2.userID < obj1.userID) {
            return NSOrderedAscending;
        } else if (obj2.userID == obj1.userID) {
            return NSOrderedSame;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    NSArray *localUserArray = [self allUserEntityArray];
    
    NSMutableArray *userNeedToInsert = [NSMutableArray array];
    NSInteger index01 = 0, index02 = 0;
    NSInteger indexBorder01 = userArray.count;
    NSInteger indexBorder02 = localUserArray.count;
    NSInteger userID01, userID02;
    
    while (index01 < indexBorder01 && index02 < indexBorder02) {
        GXUserModel *userModel = [userArray objectAtIndex:index01];
        GXDatabaseEntityUser *userEntity = [localUserArray objectAtIndex:index02];
        userID01 = userModel.userID;
        userID02 = [userEntity.userID integerValue];
        
        if (userID01 > userID02) {
            [userNeedToInsert addObject:userModel];
            ++index01;
            continue;
        }
        
        if (userID01 == userID02) {
            // user's nickname may need update
            if (![userModel.nickname isEqualToString:userEntity.nickname]) {
                userEntity.nickname = userModel.nickname;
            }
            
            ++index01;
            ++index02;
            continue;
        }
        
        if (userID01 < userID02) {
            [managedObjectContext deleteObject:userEntity];
            ++index02;
            continue;
        }
    }
    
    for (; index01 < indexBorder01; ++index01) {
        [userNeedToInsert addObject:[userArray objectAtIndex:index01]];
    }
    
    for (; index02 < indexBorder02; ++index02) {
        [managedObjectContext deleteObject:[localUserArray objectAtIndex:index02]];
    }
    
    // perform the neccessary insert action
    for (GXUserModel *userModel in userNeedToInsert) {
        GXDatabaseEntityUser *newUserEntity = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_USER inManagedObjectContext:managedObjectContext];
        
        newUserEntity.userID = [NSNumber numberWithInteger:userModel.userID];
        newUserEntity.userName = userModel.userName;
        newUserEntity.nickname = userModel.nickname;
        newUserEntity.headImageURL = [NSString stringWithFormat:@"https://115.28.226.149/user_profile?user_id=%ld.jpg", (long)userModel.userID];
    }
    
    [self saveContext];
    
    NSLog(@"successfullt insert user");
}

+ (void)insertUnlockRecordIntoDatabase:(NSArray *)unlockRecordArray
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    for (GXUnlockRecordModel *unlockRecordModel in unlockRecordArray) {
        GXDatabaseEntityUnlockRecord *newRecordEntity = [self unlockRecordEntityWithID:unlockRecordModel.unlockRecordID];
        
        if (newRecordEntity != nil) {
            continue;
        }
        
        GXDatabaseEntityDevice *correspondDevice = [self deviceEntityWithDeviceIdentifire:unlockRecordModel.deviceIdentifire];
        if (correspondDevice == nil) {
            NSLog(@"error: unlock record has no correspond device");
            continue;
        }
        
        GXDatabaseEntityUser *correspondUser = [self userEntityWithUserName:unlockRecordModel.relatedUserName];
        if (correspondUser == nil) {
            NSLog(@"error: unlock record has no correspond user");
        }
        
        newRecordEntity = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_RECORD inManagedObjectContext:managedObjectContext];
        
        newRecordEntity.recordID = [NSNumber numberWithInteger:unlockRecordModel.unlockRecordID];
        newRecordEntity.deviceIdentifire = unlockRecordModel.deviceIdentifire;
        newRecordEntity.relatedUserName = unlockRecordModel.relatedUserName;
        newRecordEntity.event = unlockRecordModel.event;
        newRecordEntity.date = unlockRecordModel.date;
        newRecordEntity.eventType = [NSNumber numberWithInteger:unlockRecordModel.eventType];
        
        newRecordEntity.device = correspondDevice;
        if (correspondUser != nil) {
            newRecordEntity.user = correspondUser;
        }
    }
    
    [self saveContext];
    NSLog(@"successfully insert unlock record");
}

/*
 * the following method provide data for runtime application
 */
+ (NSFetchedResultsController *)validDeviceFetchedResultsController
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDevice = [NSEntityDescription entityForName:ENTITY_DEVICE inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDevice];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceStatus == 'active'"];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"deviceID" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"fetch valid device error:%@, %@", error, [error userInfo]);
        return nil;
    }
    
    return fetchedResultsController;
}

+ (NSArray *)validDeviceArray
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDevice = [NSEntityDescription entityForName:ENTITY_DEVICE inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDevice];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceStatus == 'active'"];
    [fetchRequest setPredicate:predicate];

    NSError *error = nil;
    NSArray *validDeviceArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"fetch validDeviceArray error:%@, %@", error, [error userInfo]);
        return nil;
    }
    
    return validDeviceArray;
}

+ (NSFetchedResultsController *)allDeviceFetchedResultsController
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDevice = [NSEntityDescription entityForName:ENTITY_DEVICE inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDevice];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"deviceID" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"fetch valid device error:%@, %@", error, [error userInfo]);
        return nil;
    }
    
    return fetchedResultsController;
}

// defaultUser is the administrator
+ (NSArray *)managedDeviceArray
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDevice = [NSEntityDescription entityForName:ENTITY_DEVICE inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDevice];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceAuthority == 'admin'"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *managedDevice = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"fetch managed device array error:%@, %@", error, [error userInfo]);
        return nil;
    }
    
    return managedDevice;
}

+ (NSFetchedResultsController *)unlockRecordOfDevice:(NSString *)deviceIdentifire
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityRecord = [NSEntityDescription entityForName:ENTITY_RECORD inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityRecord];
    
    if (deviceIdentifire != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceIdentifire == %@", deviceIdentifire];
        [fetchRequest setPredicate:predicate];
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"fetch unlock record error:%@, %@", error, [error userInfo]);
        return nil;
    }
    
    return fetchedResultsController;
}

+ (NSFetchedResultsController *)deviceUserMappingModelFetchedResultsController:(NSString *)deviceIdentifire
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDeviceUserMapping = [NSEntityDescription entityForName:ENTITY_DEVICE_USER_MAPPING inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDeviceUserMapping];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceIdentifire == %@", deviceIdentifire];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"deviceUserMappingID" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"deviceStatus" cacheName:nil];
    
    
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"fetch valid device error:%@, %@", error, [error userInfo]);
        return nil;
    }
    
    return fetchedResultsController;
}


+ (GXDatabaseEntityUser *)defaultUser
{
    NSString *defaultUserName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    
    GXDatabaseEntityUser *user = [self userEntityWithUserName:defaultUserName];
    
    return user;
}

/*
 the following method provide neccessary assistant
 */
+ (NSManagedObjectContext *)defaultManagedObjectContext
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    return managedObjectContext;
}

+ (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSError *error;
    
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

+ (GXDatabaseEntityDevice *)deviceEntityWithDeviceIdentifire:(NSString *)deviceIdentifire
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDevice = [NSEntityDescription entityForName:ENTITY_DEVICE inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDevice];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceIdentifire == %@", deviceIdentifire];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *correspondDeviceArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"bad fetch request: request device with identifire:%@", deviceIdentifire);
        abort();
    }
    
    if (correspondDeviceArray.count <= 0) {
        NSLog(@"database has no such device with identifire:%@", deviceIdentifire);
        return nil;
    }
    
    if (correspondDeviceArray.count > 1) {
        NSLog(@"error: mutiple device with the same identifire:%@", deviceIdentifire);
    }
    
    GXDatabaseEntityDevice *device = [correspondDeviceArray objectAtIndex:0];
    return device;
}

+ (NSArray *)allDeviceArray
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDevice = [NSEntityDescription entityForName:ENTITY_DEVICE inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDevice];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"deviceID" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *allDevice = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"error: fetch all device array:%@, %@", error, [error userInfo]);
        return nil;
    }
    
    return allDevice;
}

+ (NSArray *)allDeviceUserMappingArray
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDeviceUserMapping = [NSEntityDescription entityForName:ENTITY_DEVICE_USER_MAPPING inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDeviceUserMapping];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"deviceUserMappingID" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *deviceUserMappingArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"error: fetch all deviceUserMapping array:%@, %@", error, [error userInfo]);
        return nil;
    }
    
    return deviceUserMappingArray;
}

+ (GXDatabaseEntityDeviceUserMappingItem *)deviceUserMappingEntityWithID:(NSInteger)deviceUserMappingID
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDeviceUserMapping = [NSEntityDescription entityForName:ENTITY_DEVICE_USER_MAPPING inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDeviceUserMapping];
    
    NSNumber *deviceUserMappingIdParam = [NSNumber numberWithInteger:deviceUserMappingID];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceUserMappingID == %@", deviceUserMappingIdParam];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *correspondDeviceUserMappingArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"bad fetch request: request deviceUserMapping with ID:%@", deviceUserMappingIdParam);
        abort();
    }
    
    if (correspondDeviceUserMappingArray.count <= 0) {
        NSLog(@"database has no such deviceUserMapping with ID:%@", deviceUserMappingIdParam);
        return nil;
    }
    
    if (correspondDeviceUserMappingArray.count > 1) {
        NSLog(@"error: mutiple deviceUserMapping with the same ID:%@", deviceUserMappingIdParam);
    }
    
    GXDatabaseEntityDeviceUserMappingItem *deviceUserMappingItem = [correspondDeviceUserMappingArray objectAtIndex:0];
    return deviceUserMappingItem;
}

+ (NSArray *)allUserEntityArray
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDevice = [NSEntityDescription entityForName:ENTITY_USER inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDevice];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"userID" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *userArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"error: fetch all user array:%@, %@", error, [error userInfo]);
        return nil;
    }
    
    return userArray;
}

+ (GXDatabaseEntityUser *)userEntityWithUserName:(NSString *)userName
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityUser = [NSEntityDescription entityForName:ENTITY_USER inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityUser];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName == %@", userName];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *correspondUserArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"bad fetch request: request user with userName:%@", userName);
        abort();
    }
    
    if (correspondUserArray.count <= 0) {
        //NSLog(@"database has no such user with userName:%@", userName);
        return nil;
    }
    
    if (correspondUserArray.count > 1) {
        NSLog(@"error: mutiple user with the same userName:%@", userName);
    }
    
    GXDatabaseEntityUser *user = [correspondUserArray objectAtIndex:0];
    return user;
}

+ (GXDatabaseEntityUnlockRecord *)unlockRecordEntityWithID:(NSInteger)unlockRecordID
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityRecord = [NSEntityDescription entityForName:ENTITY_RECORD inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityRecord];
    
    NSNumber *recordIdParam = [NSNumber numberWithInteger:unlockRecordID];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordID == %@", recordIdParam];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *correspondRecordArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"bad fetch request: request record with recordID:%@", recordIdParam);
        abort();
    }
    
    if (correspondRecordArray.count <= 0) {
        //NSLog(@"database has no such record with the recordID:%@", recordIdParam);
        return nil;
    }
    
    if (correspondRecordArray.count > 1) {
        NSLog(@"error: mutiple record with the same recordID:%@", recordIdParam);
    }
    
    GXDatabaseEntityUnlockRecord *record = [correspondRecordArray objectAtIndex:0];
    return record;
}

#pragma mark - change data in database
+ (void)changeDeviceNickname:(NSString *)deviceIdentifire deviceNickname:(NSString *)nickname
{
    GXDatabaseEntityDevice *deviceEntity = [self deviceEntityWithDeviceIdentifire:deviceIdentifire];
    
    if (![deviceEntity.deviceNickname isEqualToString:nickname]) {
        deviceEntity.deviceNickname = nickname;
    }
}

+ (void)deleteDeviceWithIdentifire:(NSString *)deviceIdentifire
{
    GXDatabaseEntityDevice *deviceEntity = [self deviceEntityWithDeviceIdentifire:deviceIdentifire];
    
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    [managedObjectContext deleteObject:deviceEntity];
    
    [self saveContext];
}

+ (void)updateDefaultUserNickname:(NSString *)nickname
{
    GXDatabaseEntityUser *userEntity = [self defaultUser];
    
    userEntity.nickname = nickname;
    
    [self saveContext];
}

+ (void)deleteUser:(NSString *)userName fromDevice:(NSString *)deviceIdentifire
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDeviceUserMapping = [NSEntityDescription entityForName:ENTITY_DEVICE_USER_MAPPING inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDeviceUserMapping];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceIdentifire == %@ AND userName == %@", deviceIdentifire, userName];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *deviceUserMappingArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error == nil) {
        for (GXDatabaseEntityDeviceUserMappingItem *deviceUserMappingItem in deviceUserMappingArray) {
            [managedObjectContext deleteObject:deviceUserMappingItem];
        }
    }
    
    [self saveContext];
}

+ (void)logout
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSArray *allDevice = [self allDeviceArray];
    for (GXDatabaseEntityDevice *deviceEnity in allDevice) {
        [managedObjectContext deleteObject:deviceEnity];
    }
    
    NSArray *allUser = [self allUserEntityArray];
    for (GXDatabaseEntityUser *userEntity in allUser) {
        [managedObjectContext deleteObject:userEntity];
    }
    
    [self saveContext];
}
@end
