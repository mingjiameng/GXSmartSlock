//
//  GXDatabaseEntityLocalUnlockRecord+CoreDataProperties.h
//  GXSmartSlock
//
//  Created by zkey on 9/21/15.
//  Copyright © 2015 guosim. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GXDatabaseEntityLocalUnlockRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXDatabaseEntityLocalUnlockRecord (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *deviceIdentifire;
@property (nullable, nonatomic, retain) NSString *event;
@property (nullable, nonatomic, retain) NSNumber *eventType;

@end

NS_ASSUME_NONNULL_END
