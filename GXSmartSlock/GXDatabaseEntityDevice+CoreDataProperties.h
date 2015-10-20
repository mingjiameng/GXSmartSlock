//
//  GXDatabaseEntityDevice+CoreDataProperties.h
//  GXSmartSlock
//
//  Created by zkey on 10/19/15.
//  Copyright © 2015 guosim. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GXDatabaseEntityDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXDatabaseEntityDevice (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *deviceAuthority;
@property (nullable, nonatomic, retain) NSNumber *deviceBattery;
@property (nullable, nonatomic, retain) NSString *deviceCategory;
@property (nullable, nonatomic, retain) NSNumber *deviceID;
@property (nullable, nonatomic, retain) NSString *deviceIdentifire;
@property (nullable, nonatomic, retain) NSString *deviceKey;
@property (nullable, nonatomic, retain) NSString *deviceNickname;
@property (nullable, nonatomic, retain) NSString *deviceStatus;
@property (nullable, nonatomic, retain) NSNumber *deviceVersion;
@property (nullable, nonatomic, retain) NSNumber *firewareDownloadVersion;
@property (nullable, nonatomic, retain) NSNumber *supportedByRepeater;
@property (nullable, nonatomic, retain) NSSet<GXDatabaseEntityDeviceUserMappingItem *> *deviceUsers;
@property (nullable, nonatomic, retain) NSSet<GXDatabaseEntityUnlockRecord *> *unlockRecords;

@end

@interface GXDatabaseEntityDevice (CoreDataGeneratedAccessors)

- (void)addDeviceUsersObject:(GXDatabaseEntityDeviceUserMappingItem *)value;
- (void)removeDeviceUsersObject:(GXDatabaseEntityDeviceUserMappingItem *)value;
- (void)addDeviceUsers:(NSSet<GXDatabaseEntityDeviceUserMappingItem *> *)values;
- (void)removeDeviceUsers:(NSSet<GXDatabaseEntityDeviceUserMappingItem *> *)values;

- (void)addUnlockRecordsObject:(GXDatabaseEntityUnlockRecord *)value;
- (void)removeUnlockRecordsObject:(GXDatabaseEntityUnlockRecord *)value;
- (void)addUnlockRecords:(NSSet<GXDatabaseEntityUnlockRecord *> *)values;
- (void)removeUnlockRecords:(NSSet<GXDatabaseEntityUnlockRecord *> *)values;

@end

NS_ASSUME_NONNULL_END
