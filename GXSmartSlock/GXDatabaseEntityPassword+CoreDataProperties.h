//
//  GXDatabaseEntityPassword+CoreDataProperties.h
//  GXSmartSlock
//
//  Created by zkey on 10/20/15.
//  Copyright © 2015 guosim. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GXDatabaseEntityPassword.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXDatabaseEntityPassword (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *passwordID;
@property (nullable, nonatomic, retain) NSString *passwordType;
@property (nullable, nonatomic, retain) NSString *passwordAddedApproach;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) NSDate *endDate;
@property (nullable, nonatomic, retain) NSNumber *actived;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSNumber *passwordStatus;
@property (nullable, nonatomic, retain) NSString *passwordNickname;
@property (nullable, nonatomic, retain) NSString *deviceIdentifire;
@property (nullable, nonatomic, retain) GXDatabaseEntityDevice *device;

@end

NS_ASSUME_NONNULL_END
