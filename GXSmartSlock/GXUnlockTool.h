//
//  GXUnlockTool.h
//  GXSmartSlock
//
//  Created by zkey on 9/8/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXUnlockTool : NSObject

/*
diviceKeyDictionary = {
    deviceIdentifire : secretKey
}
 */
- (void)updateDeviceKeyDictionary;


- (void)updateUnlockMode;

// when the application enter foreground, upload exist unlock information
- (void)uploadUnlockRecord;


- (void)manulUnlock;

@end