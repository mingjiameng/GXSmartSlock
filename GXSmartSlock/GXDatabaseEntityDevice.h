//
//  GXDatabaseEntityDevice.h
//  GXSmartSlock
//
//  Created by zkey on 10/19/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GXDatabaseEntityDeviceUserMappingItem, GXDatabaseEntityUnlockRecord;

NS_ASSUME_NONNULL_BEGIN

@interface GXDatabaseEntityDevice : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "GXDatabaseEntityDevice+CoreDataProperties.h"
