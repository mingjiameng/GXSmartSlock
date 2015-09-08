//
//  GXServerDataAnalyst.h
//  GXSmartSlock
//
//  Created by zkey on 8/22/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXServerDataAnalyst : NSObject

+ (void)login:(NSDictionary *)data;
+ (void)insertDeviceIntoDatabase:(NSArray *)deviceArray;
+ (void)insertDeviceUserMappingItemIntoDatabase:(NSArray *)deviceUserMappingItemArray;
+ (void)insertUserIntoDatabase:(NSArray *)userArray;
+ (void)insertUnlockRecordIntoDatabase:(NSArray *)unlockRecordArray;
+ (void)logout;

@end
