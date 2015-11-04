//
//  GXDatabaseHelper.h
//  GXSmartSlock
//
//  Created by zkey on 8/21/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GXUserModel, GXDatabaseEntityUser, GXDatabaseEntityDevice, GXDatabaseEntityLocalUnlockRecord, GXDatabaseEntityPassword, GXPasswordModel;

@interface GXDatabaseHelper : NSObject

/*
 * insert data
 */
+ (void)setDefaultUser:(nonnull GXUserModel *)user;
+ (void)insertDeviceIntoDatabase:(nonnull NSArray *)deviceArray;
+ (void)insertDeviceUserMappingItemIntoDatabase:(nonnull NSArray *)deviceUserMappingArray;
+ (void)insertUserIntoDatabase:(nonnull NSArray *)userArray;
+ (void)insertUnlockRecordIntoDatabase:(nonnull NSArray *)unlockRecordArray;

/************************seperator*********************************/

/*
 * provide data
 */
+ (nullable NSFetchedResultsController *)validDeviceFetchedResultsController;
+ (nullable NSFetchedResultsController *)allDeviceFetchedResultsController;
+ (nullable NSFetchedResultsController *)deviceUserMappingModelFetchedResultsController:(nonnull NSString *)deviceIdentifire;
+ (nullable GXDatabaseEntityUser *)defaultUser;
+ (nullable NSArray *)managedDeviceArray;

// when receive nil value, the method returns unlock records of all devices managed by current user
+ (nullable NSFetchedResultsController *)unlockRecordOfDevice:(nullable NSString *)deviceIdentifire;


+ (nullable NSArray *)validDeviceArray;
+ (nullable GXDatabaseEntityDevice *)deviceEntityWithDeviceIdentifire:(nonnull NSString *)deviceIdentifire;
+ (nullable NSFetchedResultsController *)allLocalUnlockRecordFetchedResultsController;
+ (nullable NSArray *)allLocalUnlockRecordArray;
+ (nullable NSFetchedResultsController *)oneTimePasswordFetchedResultsControllerOfDevice:(nonnull NSString *)deviceIdentifire;
+ (void)device:(nonnull NSString *)deviceIdentifire insertPasswordIntoDatabase:(nullable NSArray<GXPasswordModel *> *)passwordModelArray;

// the previous one-time password will be deleted once you insert the new one-time password array
// the param - oneTimePasswordArray contains object GXOneTimePasswordModel
+ (void)device:(nonnull NSString *)deviceIdentifire insertNewOneTimePasswordIntoDatabase:(nonnull NSArray *)oneTimePasswordArray;

// this interface is sepcifically for data migration(from SQL to CoreData)
+ (void)addOneTimePasswordIntoDatabase:(nonnull NSArray *)oneTimePasswordArray;


+ (nullable NSFetchedResultsController *)device:(nonnull NSString *)deviceIdentifire passwordFetchedResultsContrllerWithPasswordType:(nullable NSString *)passwordType addedFrom:(nullable NSString *)addedApproach;

+ (nullable GXDatabaseEntityPassword *)device:(nonnull NSString *)deviceIdentifire passwordEntity:(NSInteger)passwordID;

/*
 * change data
 */
+ (void)changeDeviceNickname:(nonnull NSString *)deviceIdentifire deviceNickname:(nonnull NSString *)nickname;
+ (void)deleteDeviceWithIdentifire:(nonnull NSString *)deviceIdentifire;
+ (void)updateDefaultUserNickname:(nonnull NSString *)nickname;
+ (void)deleteUser:(nonnull NSString *)userName fromDevice:(nonnull NSString *)deviceIdentifire;
+ (void)logout;
+ (void)updateDonwloadedFirewareVersion:(NSInteger)newVersion ofDevice:(nonnull NSString *)deviceIdentifire;
+ (void)device:(nonnull NSString *)deviceIdentifire updateBatteryLevel:(NSInteger)batteryLevel;
+ (void)addLocalUnlockRecordIntoDatabase:(nonnull NSArray *)unlockRecordArray;
+ (void)deleteLocalUnlockRecordEntity:(nonnull GXDatabaseEntityLocalUnlockRecord *)record;
+ (void)device:(nonnull NSString *)deviceIdentifire turnOneTimePassword:(nonnull NSString *)password toState:(BOOL)valid;
+ (void)device:(nonnull NSString *)deviceIdentifire updateFirewareVersion:(NSInteger)newVerison;

@end
