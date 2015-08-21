//
//  GXDatabaseEntityDevice.h
//  GXSmartSlock
//
//  Created by zkey on 8/21/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GXDatabaseEntityDeviceUserItem, GXDatabaseEntityRecord;

@interface GXDatabaseEntityDevice : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * deviceBattery;
@property (nonatomic, retain) NSNumber * deviceID;
@property (nonatomic, retain) NSString * deviceIdentifire;
@property (nonatomic, retain) NSString * deviceKey;
@property (nonatomic, retain) NSNumber * deviceVersion;
@property (nonatomic, retain) NSSet *unlockRecords;
@property (nonatomic, retain) NSSet *deviceUsers;
@end

@interface GXDatabaseEntityDevice (CoreDataGeneratedAccessors)

- (void)addUnlockRecordsObject:(GXDatabaseEntityRecord *)value;
- (void)removeUnlockRecordsObject:(GXDatabaseEntityRecord *)value;
- (void)addUnlockRecords:(NSSet *)values;
- (void)removeUnlockRecords:(NSSet *)values;

- (void)addDeviceUsersObject:(GXDatabaseEntityDeviceUserItem *)value;
- (void)removeDeviceUsersObject:(GXDatabaseEntityDeviceUserItem *)value;
- (void)addDeviceUsers:(NSSet *)values;
- (void)removeDeviceUsers:(NSSet *)values;

@end
