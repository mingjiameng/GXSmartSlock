//
//  GXDatabaseHelper.h
//  GXSmartSlock
//
//  Created by zkey on 8/21/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GXUserModel;

@interface GXDatabaseHelper : NSObject

+ (void)setDefaultUser:(GXUserModel *)user;
+ (void)insertDeviceIntoDatabase:(NSArray *)deviceArray;
+ (void)insertDeviceUserMappingItemIntoDatabase:(NSArray *)deviceUserMappingArray;
+ (void)insertUserIntoDatabase:(NSArray *)userArray;

/************************seperator*********************************/
+ (NSFetchedResultsController *)validDeviceFetchedResultsController;
+ (NSFetchedResultsController *)allDeviceFetchedResultsController;

@end
