//
//  GXDatabaseEntityDevice.h
//  GXSmartSlock
//
//  Created by zkey on 8/22/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GXDatabaseEntityDeviceUserMapping, GXDatabaseEntityRecord;

@interface GXDatabaseEntityDevice : NSManagedObject

@property (nonatomic, retain) NSString * deviceCategory;
@property (nonatomic, retain) NSNumber * deviceBattery;
@property (nonatomic, retain) NSNumber * deviceID;
@property (nonatomic, retain) NSString * deviceIdentifire;
@property (nonatomic, retain) NSString * deviceKey;
@property (nonatomic, retain) NSNumber * deviceVersion;
@property (nonatomic, retain) NSString * deviceStatus;
@property (nonatomic, retain) NSString * deviceNickname;
@property (nonatomic, retain) NSString * deviceAuthority;
@property (nonatomic, retain) NSSet *deviceUsers;
@property (nonatomic, retain) NSSet *unlockRecords;
@end

@interface GXDatabaseEntityDevice (CoreDataGeneratedAccessors)

- (void)addDeviceUsersObject:(GXDatabaseEntityDeviceUserMapping *)value;
- (void)removeDeviceUsersObject:(GXDatabaseEntityDeviceUserMapping *)value;
- (void)addDeviceUsers:(NSSet *)values;
- (void)removeDeviceUsers:(NSSet *)values;

- (void)addUnlockRecordsObject:(GXDatabaseEntityRecord *)value;
- (void)removeUnlockRecordsObject:(GXDatabaseEntityRecord *)value;
- (void)addUnlockRecords:(NSSet *)values;
- (void)removeUnlockRecords:(NSSet *)values;

@end
