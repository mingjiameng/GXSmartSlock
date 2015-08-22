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

#import "GXDatabaseEntityDevice.h"
#import "GXDatabaseEntityDeviceUserMappingItem.h"

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
+ (void)insertDevice:(NSArray *)deviceArray
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

+ (void)insertDeviceUserMappingItem:(NSArray *)deviceUserMappingArray
{
    NSManagedObjectContext *managedObjectContext = [self defaultManagedObjectContext];
    
    for (GXDeviceUserMappingModel *deviceMappingModel in deviceUserMappingArray) {
        GXDatabaseEntityDeviceUserMappingItem *newDeviceEntityUserMappingEntity = [self deviceUserMappingEntityWithID:deviceMappingModel.deviceUserMappingID];
        
        
    }
}

/*
 * the following method provide data for runtime application
 */
+ (NSFetchedResultsController *)validDevice
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

@end
