//
//  GXDatabaseEntityOneTimePassword+CoreDataProperties.h
//  GXSmartSlock
//
//  Created by zkey on 9/24/15.
//  Copyright © 2015 guosim. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GXDatabaseEntityOneTimePassword.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXDatabaseEntityOneTimePassword (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *deviceIdentifire;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSNumber *validity;

@end

NS_ASSUME_NONNULL_END
