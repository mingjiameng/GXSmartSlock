//
//  GXDatabaseEntityUser.h
//  GXSmartSlock
//
//  Created by zkey on 8/23/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GXDatabaseEntityDeviceUserMappingItem, GXDatabaseEntityRecord;

@interface GXDatabaseEntityUser : NSManagedObject

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

- (void)addRecordsObject:(GXDatabaseEntityRecord *)value;
- (void)removeRecordsObject:(GXDatabaseEntityRecord *)value;
- (void)addRecords:(NSSet *)values;
- (void)removeRecords:(NSSet *)values;

@end
