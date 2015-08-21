//
//  GXDatabaseEntityDeviceUserItem.h
//  GXSmartSlock
//
//  Created by zkey on 8/21/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GXDatabaseEntityDevice, GXDatabaseEntityUser;

@interface GXDatabaseEntityDeviceUserItem : NSManagedObject

@property (nonatomic, retain) NSString * deviceIdentifire;
@property (nonatomic, retain) NSString * deviceName;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) GXDatabaseEntityDevice *device;
@property (nonatomic, retain) GXDatabaseEntityUser *user;

@end
