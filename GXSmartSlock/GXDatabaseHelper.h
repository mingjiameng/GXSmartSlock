//
//  GXDatabaseHelper.h
//  GXSmartSlock
//
//  Created by zkey on 8/21/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GXUserModel, GXDatabaseEntityUser;

@interface GXDatabaseHelper : NSObject

/*
 * insert data
 */
+ (void)setDefaultUser:(GXUserModel *)user;
+ (void)insertDeviceIntoDatabase:(NSArray *)deviceArray;
+ (void)insertDeviceUserMappingItemIntoDatabase:(NSArray *)deviceUserMappingArray;
+ (void)insertUserIntoDatabase:(NSArray *)userArray;

/************************seperator*********************************/

/*
 * provide data
 */
+ (NSFetchedResultsController *)validDeviceFetchedResultsController;
+ (NSFetchedResultsController *)allDeviceFetchedResultsController;
+ (NSFetchedResultsController *)deviceUserMappingModelFetchedResultsController:(NSString *)deviceIdentifire;
+ (GXDatabaseEntityUser *)defaultUser;

/*
 * change data
 */
+ (void)changeDeviceNickname:(NSString *)deviceIdentifire deviceNickname:(NSString *)nickname;
+ (void)deleteDeviceWithIdentifire:(NSString *)deviceIdentifire;
+ (void)updateDefaultUserNickname:(NSString *)nickname;

@end
