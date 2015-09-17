//
//  GXDatabaseEntityDevice.h
//  GXSmartSlock
//
//  Created by zkey on 9/17/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GXDatabaseEntityDeviceUserMappingItem, GXDatabaseEntityUnlockRecord;

@interface GXDatabaseEntityDevice : NSManagedObject

@property (nonatomic, retain) NSString * deviceAuthority;
@property (nonatomic, retain) NSNumber * deviceBattery;
@property (nonatomic, retain) NSString * deviceCategory;
@property (nonatomic, retain) NSNumber * deviceID;
@property (nonatomic, retain) NSString * deviceIdentifire;
@property (nonatomic, retain) NSString * deviceKey;
@property (nonatomic, retain) NSString * deviceNickname;
@property (nonatomic, retain) NSString * deviceStatus;
@property (nonatomic, retain) NSNumber * deviceVersion;
@property (nonatomic, retain) NSNumber * firewareDownloadVersion;
@property (nonatomic, retain) NSSet *deviceUsers;
@property (nonatomic, retain) NSSet *unlockRecords;
@end

@interface GXDatabaseEntityDevice (CoreDataGeneratedAccessors)

- (void)addDeviceUsersObject:(GXDatabaseEntityDeviceUserMappingItem *)value;
- (void)removeDeviceUsersObject:(GXDatabaseEntityDeviceUserMappingItem *)value;
- (void)addDeviceUsers:(NSSet *)values;
- (void)removeDeviceUsers:(NSSet *)values;

- (void)addUnlockRecordsObject:(GXDatabaseEntityUnlockRecord *)value;
- (void)removeUnlockRecordsObject:(GXDatabaseEntityUnlockRecord *)value;
- (void)addUnlockRecords:(NSSet *)values;
- (void)removeUnlockRecords:(NSSet *)values;

@end
