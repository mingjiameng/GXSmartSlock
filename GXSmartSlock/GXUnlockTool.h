//
//  GXUnlockTool.h
//  GXSmartSlock
//
//  Created by zkey on 9/8/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXUnlockToolDelegate <NSObject>

@optional
- (void)successfullyUnlockDevice:(NSString *)deviceIdentifire;
- (void)forceStopUnlock;

@end

@interface GXUnlockTool : NSObject

@property (nonatomic, weak) id<GXUnlockToolDelegate> delegate;

/*
diviceKeyDictionary = {
    deviceIdentifire : secretKey
}
 */
- (void)updateDeviceKeyDictionary;

- (void)updateUnlockMode;

// when the application enter foreground, upload exist unlock information
- (void)uploadLocalUnlockRecord;

- (void)manulUnlock;

@end