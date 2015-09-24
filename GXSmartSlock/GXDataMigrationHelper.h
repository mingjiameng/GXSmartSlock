//
//  GXDataMigrationHelper.h
//  GXSmartSlock
//
//  Created by zkey on 9/24/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXDataMigrationHelper : NSObject

/*
 * Before the version 2.3.0, we use SQL as the data storage instrument.
 * Some key information (one-time passord) only storage at local (we don't have a copy on server).
 * So we need to migarte those data to data storage system supported by CoreData.
 * In additional, some key-value objects in user infoDictioanry are no longer useful.
 * We need to remvoe them to keep the reliability of the data storaged in user infoDictionary.
 */

+ (void)migrateData;

@end
