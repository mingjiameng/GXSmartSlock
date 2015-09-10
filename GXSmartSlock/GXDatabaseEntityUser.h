//
//  GXDatabaseEntityUser.h
//  GXSmartSlock
//
//  Created by zkey on 9/10/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GXDatabaseEntityDeviceUserMappingItem, GXDatabaseEntityUnlockRecord;

@interface GXDatabaseEntityUser : NSManagedObject

@property (nonatomic, retain) NSString * headImageURL;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSSet *devices;
@property (nonatomic, retain) NSSet *records;
@end

@interface GXDatabaseEntityUser (CoreDataGeneratedAccessors)

- (void)addDevicesObject:(GXDatabaseEntityDeviceUserMappingItem *)value;
- (void)removeDevicesObject:(GXDatabaseEntityDeviceUserMappingItem *)value;
- (void)addDevices:(NSSet *)values;
- (void)removeDevices:(NSSet *)values;

- (void)addRecordsObject:(GXDatabaseEntityUnlockRecord *)value;
- (void)removeRecordsObject:(GXDatabaseEntityUnlockRecord *)value;
- (void)addRecords:(NSSet *)values;
- (void)removeRecords:(NSSet *)values;

@end
