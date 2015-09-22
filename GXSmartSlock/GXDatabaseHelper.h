//
//  GXDatabaseHelper.h
//  GXSmartSlock
//
//  Created by zkey on 8/21/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GXUserModel, GXDatabaseEntityUser, GXDatabaseEntityDevice, GXDatabaseEntityLocalUnlockRecord;

@interface GXDatabaseHelper : NSObject

/*
 * insert data
 */
+ (void)setDefaultUser:(GXUserModel *)user;
+ (void)insertDeviceIntoDatabase:(NSArray *)deviceArray;
+ (void)insertDeviceUserMappingItemIntoDatabase:(NSArray *)deviceUserMappingArray;
+ (void)insertUserIntoDatabase:(NSArray *)userArray;
+ (void)insertUnlockRecordIntoDatabase:(NSArray *)unlockRecordArray;

/************************seperator*********************************/

/*
 * provide data
 */
+ (NSFetchedResultsController *)validDeviceFetchedResultsController;
+ (NSFetchedResultsController *)allDeviceFetchedResultsController;
+ (NSFetchedResultsController *)deviceUserMappingModelFetchedResultsController:(NSString *)deviceIdentifire;
+ (GXDatabaseEntityUser *)defaultUser;
+ (NSArray *)managedDeviceArray;
+ (NSFetchedResultsController *)unlockRecordOfDevice:(NSString *)deviceIdentifire;
+ (NSArray *)validDeviceArray;
+ (GXDatabaseEntityDevice *)deviceEntityWithDeviceIdentifire:(NSString *)deviceIdentifire;
+ (NSFetchedResultsController *)allLocalUnlockRecordFetchedResultsController;
+ (NSArray *)allLocalUnlockRecordArray;
/*
 * change data
 */
+ (void)changeDeviceNickname:(NSString *)deviceIdentifire deviceNickname:(NSString *)nickname;
+ (void)deleteDeviceWithIdentifire:(NSString *)deviceIdentifire;
+ (void)updateDefaultUserNickname:(NSString *)nickname;
+ (void)deleteUser:(NSString *)userName fromDevice:(NSString *)deviceIdentifire;
+ (void)logout;
+ (void)updateDonwloadedFirewareVersion:(NSInteger)newVersion ofDevice:(NSString *)deviceIdentifire;
+ (void)device:(NSString *)deviceIdentifire updateBatteryLevel:(NSInteger)batteryLevel;
+ (void)addLocalUnlockRecordIntoDatabase:(NSArray *)unlockRecordArray;
+ (void)deleteLocalUnlockRecordEntity:(GXDatabaseEntityLocalUnlockRecord *)record;

@end
