//
//  GXDatabaseEntityUser.h
//  GXSmartSlock
//
//  Created by zkey on 8/21/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GXDatabaseEntityDeviceUserItem;

@interface GXDatabaseEntityUser : NSManagedObject

@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSSet *devices;
@end

@interface GXDatabaseEntityUser (CoreDataGeneratedAccessors)

- (void)addDevicesObject:(GXDatabaseEntityDeviceUserItem *)value;
- (void)removeDevicesObject:(GXDatabaseEntityDeviceUserItem *)value;
- (void)addDevices:(NSSet *)values;
- (void)removeDevices:(NSSet *)values;

@end
