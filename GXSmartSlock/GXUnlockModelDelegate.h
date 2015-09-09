//
//  GXUnlockModelDelegate.h
//  GXSmartSlock
//
//  Created by zkey on 9/9/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXUnlockModelDelegate <NSObject>

@required
- (void)tooLowSemaphoreToUnlock;
- (NSString *)secretKeyForDevice:(NSString *)deviceIdentifire;
- (void)unlockTheDevice:(NSString *)deviceIdentifire successful:(BOOL)successful;
- (void)updateBatteryLevel:(NSInteger)batteryLevel ofDevice:(NSString *)deviceIdentifire;
- (void)lowBatteryAlert;

@end
