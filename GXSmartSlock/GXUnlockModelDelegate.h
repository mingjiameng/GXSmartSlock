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
- (nullable NSString *)secretKeyForDevice:(nonnull NSString *)deviceIdentifire;
- (void)unlockTheDevice:(nonnull NSString *)deviceIdentifire successful:(BOOL)successful;
- (void)updateBatteryLevel:(NSInteger)batteryLevel ofDevice:(nonnull NSString *)deviceIdentifire;
- (void)lowBatteryAlert:(nonnull NSString *)deviceIdentifire;



@end
