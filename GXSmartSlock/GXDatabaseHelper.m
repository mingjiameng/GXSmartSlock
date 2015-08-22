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

#import "MICRO_COREDATA.h"

#import "GXDeviceModel.h"
#import "GXDeviceUserMappingModel.h"
#import "GXUserModel.h"

#import "GXDatabaseEntityDevice.h"
#import "GXDatabaseEntityDeviceUserMappingItem.h"
#import "GXDatabaseEntityUser.h"

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
+ (void)insertDeviceIntoDatabase:(NSArray *)deviceArray
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    for (GXDeviceModel *deviceModel in deviceArray) {
        GXDatabaseEntityDevice *newDeviceEntity = [self deviceEntityWithDeviceIdentifire:deviceModel.deviceIdentifire];
        
        if (newDeviceEntity != nil) {
            NSNumber *batteryNumber = newDeviceEntity.deviceBattery;
            if ([batteryNumber integerValue] != deviceModel.deviceBattery) {
                batteryNumber = [NSNumber numberWithInteger:deviceModel.deviceBattery];
                newDeviceEntity.deviceBattery = batteryNumber;
            }
            
            NSNumber *versionNumber = newDeviceEntity.deviceVersion;
            if ([versionNumber integerValue] != deviceModel.deviceVersion) {
                versionNumber = [NSNumber numberWithInteger:deviceModel.deviceVersion];
                newDeviceEntity.deviceVersion = versionNumber;
            }
            
            continue;
        }
        
        newDeviceEntity = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_DEVICE inManagedObjectContext:managedObjectContext];
        newDeviceEntity.deviceBattery = [NSNumber numberWithInteger:deviceModel.deviceBattery];
        newDeviceEntity.deviceCategory = deviceModel.deviceCategory;
        newDeviceEntity.deviceID = [NSNumber numberWithInteger:deviceModel.deviceID];
        newDeviceEntity.deviceIdentifire = deviceModel.deviceIdentifire;
        newDeviceEntity.deviceKey = deviceModel.deviceKey;
        newDeviceEntity.deviceVersion = [NSNumber numberWithInteger:deviceModel.deviceVersion];
    }
    
    [self saveContext];
}

+ (void)insertDeviceUserMappingItemIntoDatabase:(NSArray *)deviceUserMappingArray
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    
    
    for (GXDeviceUserMappingModel *deviceMappingModel in deviceUserMappingArray) {
        GXDatabaseEntityDeviceUserMappingItem *newDeviceEntityUserMappingEntity = [self deviceUserMappingEntityWithID:deviceMappingModel.deviceUserMappingID];
        
        
    }
}

+ (void)insertUserIntoDatabase:(NSArray *)userArray
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    
    // sort the userArray for server and localUserArray in descending order
    // crossing contrast data in userArray and localUserArray in time complexity O(n)
    // to prevent unneccessary delete and insert action
    userArray = [userArray sortedArrayUsingComparator:^NSComparisonResult(GXUserModel *obj1, GXUserModel *obj2) {
        return (obj2.userID < obj1.userID);
    }];
    
    NSMutableArray *userNeedToInsert = [NSMutableArray array];
    
    NSArray *localUserArray = [self allUserEntityArray];
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
            ++userID01;
            continue;
        }
        
        if (userID01 == userID02) {
            ++userID01;
            ++userID02;
            continue;
        }
        
        if (userID01 < userID02) {
            [managedObjectContext deleteObject:userEntity];
            ++userID02;
            continue;
        }
    }
    
    for (; index01 < indexBorder01; ++index01) {
        [userNeedToInsert addObject:[userArray objectAtIndex:index01]];
    }
    
    for (; index01 < indexBorder02; ++index02) {
        [managedObjectContext deleteObject:[localUserArray objectAtIndex:index02]];
    }
    
    // perform the neccessary insert action
    for (GXUserModel *userModel in userNeedToInsert) {
        GXDatabaseEntityUser *newUserEntity = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_USER inManagedObjectContext:managedObjectContext];
        
        newUserEntity.userID = [NSNumber numberWithInteger:userModel.userID];
        newUserEntity.userName = userModel.userName;
        newUserEntity.nickname = userModel.nickname;
    }
    
    [self saveContext];
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceIdentifire == '%@'", deviceIdentifire];
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

+ (GXDatabaseEntityDeviceUserMappingItem *)deviceUserMappingEntityWithID:(NSInteger)deviceUserMappingID
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDevice = [NSEntityDescription entityForName:ENTITY_DEVICE_USER_MAPPING inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDevice];
    
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
    NSArray *allUserArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"error: fetch all user array:%@, %@", error, [error userInfo]);
        return nil;
    }
    
    return allUserArray;
}

+ (GXDatabaseEntityUser *)userEntityWithUserName:(NSString *)userName
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityUser = [NSEntityDescription entityForName:ENTITY_USER inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityUser];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName == '%@'", userName];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *correspondUserArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"bad fetch request: request user with userName:%@", userName);
        abort();
    }
    
    if (correspondUserArray.count <= 0) {
        NSLog(@"database has no such user with userName:%@", userName);
        return nil;
    }
    
    if (correspondUserArray.count > 1) {
        NSLog(@"error: mutiple user with the same userName:%@", userName);
    }
    
    GXDatabaseEntityUser *user = [correspondUserArray objectAtIndex:0];
    return user;
}


@end