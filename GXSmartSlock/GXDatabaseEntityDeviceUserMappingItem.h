//
//  GXDatabaseEntityDeviceUserMappingItem.h
//  GXSmartSlock
//
//  Created by zkey on 8/22/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GXDatabaseEntityDevice, GXDatabaseEntityUser;

@interface GXDatabaseEntityDeviceUserMappingItem : NSManagedObject

@property (nonatomic, retain) NSString * deviceIdentifire;
@property (nonatomic, retain) NSString * deviceNickname;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * deviceUserMappingID;
@property (nonatomic, retain) NSString * deviceStatus;
@property (nonatomic, retain) NSString * deviceAuthority;
@property (nonatomic, retain) GXDatabaseEntityDevice *device;
@property (nonatomic, retain) GXDatabaseEntityUser *user;

@end
