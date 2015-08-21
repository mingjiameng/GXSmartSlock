//
//  GXDatabaseEntityRecord.h
//  GXSmartSlock
//
//  Created by zkey on 8/21/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GXDatabaseEntityDevice, GXDatabaseEntityUser;

@interface GXDatabaseEntityRecord : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * deviceIdentifire;
@property (nonatomic, retain) NSString * event;
@property (nonatomic, retain) NSNumber * eventType;
@property (nonatomic, retain) NSString * senderUserName;
@property (nonatomic, retain) GXDatabaseEntityDevice *device;
@property (nonatomic, retain) GXDatabaseEntityUser *user;

@end
