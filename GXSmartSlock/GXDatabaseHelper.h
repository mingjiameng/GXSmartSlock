//
//  GXDatabaseHelper.h
//  GXSmartSlock
//
//  Created by zkey on 8/21/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface GXDatabaseHelper : NSObject

+ (void)insertDeviceIntoDatabase:(NSArray *)deviceArray;

@end
