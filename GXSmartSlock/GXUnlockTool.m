//
//  GXUnlockTool.m
//  GXSmartSlock
//
//  Created by zkey on 9/8/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXUnlockTool.h"

#import "MICRO_COMMON.h"

#import "GXDatabaseEntityDevice.h"
#import "GXDatabaseHelper.h"
#import "GXReachability.h"

#import "GXManulUnlockModel.h"
#import "GXAutoUnlockModel.h"
#import "GXShakeUnlockModel.h"

#import "zkeyViewHelper.h"

@interface GXUnlockTool () <GXUnlockModelDelegate>
{
    NSDictionary *_deviceKeyDic;
    GXManulUnlockModel *_manulUnlockModel;
    GXAutoUnlockModel *_autoUnlockModel;
    GXShakeUnlockModel *_shakeUnlockModel;
}
@end

@implementation GXUnlockTool

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self updateUnlockMode];
        [self updateDeviceKeyDictionary];
    }
    
    return self;
}

- (void)updateUnlockMode
{
    DefaultUnlockMode unlockMode = [[[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_UNLOCK_MODE] integerValue];
    if (unlockMode == DefaultUnlockModeManul) {
        _autoUnlockModel = nil;
        _shakeUnlockModel = nil;
        if (_manulUnlockModel == nil) {
            _manulUnlockModel = [[GXManulUnlockModel alloc] init];
            _manulUnlockModel.delegate = self;
        }
    
    } else if (unlockMode == DefaultUnlockModeAuto) {
        _manulUnlockModel = nil;
        _shakeUnlockModel = nil;
        if (_autoUnlockModel == nil) {
            _autoUnlockModel = [[GXAutoUnlockModel alloc] init];
            _autoUnlockModel.delegate = self;
        }
        
    } else if (unlockMode == DefaultUnlockModeShake) {
        _manulUnlockModel = nil;
        _autoUnlockModel = nil;
        if (_shakeUnlockModel == nil) {
            _shakeUnlockModel = [[GXShakeUnlockModel alloc] init];
            _shakeUnlockModel.delegate = self;
        }
    }
}

- (void)updateDeviceKeyDictionary
{
    NSArray *validDeviceArray = [GXDatabaseHelper validDeviceArray];
    if (validDeviceArray == nil) {
        return;
    }
    
    NSMutableDictionary *tmpDeviceKeyDic = [NSMutableDictionary dictionary];
    for (GXDatabaseEntityDevice *deviceEntity in validDeviceArray) {
        [tmpDeviceKeyDic setObject:deviceEntity.deviceKey forKey:deviceEntity.deviceIdentifire];
    }
    
    _deviceKeyDic = (NSDictionary *)tmpDeviceKeyDic;
}

- (void)manulUnlock
{
    if (_manulUnlockModel != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_manulUnlockModel startScan];
            [self performSelector:@selector(forceStopUnlockAction) withObject:nil afterDelay:10.0];
        });
    }
}

- (void)forceStopUnlockAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_manulUnlockModel stopScan];
        //[self.delegate forceStopUnlockAction];
    });
    
}

#pragma mark - unlock delegate
- (void)tooLowSemaphoreToUnlock
{
    [zkeyViewHelper presentLocalNotificationWithMessage:@"信号弱，请您靠近门锁"];
}

- (void)updateBatteryLevel:(NSInteger)batteryLevel ofDevice:(NSString *)deviceIdentifire
{
    
}

- (void)lowBatteryAlert
{
    [zkeyViewHelper presentLocalNotificationWithMessage:@"⚠低电量，请尽快更换电池"];
}

- (NSString *)secretKeyForDevice:(NSString *)deviceIdentifire
{
    NSString *secretKey = [_deviceKeyDic objectForKey:deviceIdentifire];
    return secretKey;
}

- (void)unlockTheDevice:(NSString *)deviceIdentifire successful:(BOOL)successful
{
    if ([self serverAvailable]) {
        if ([self uploadUnlockRecordOfDevice:deviceIdentifire successful:successful]) {
            return;
        }
    }
    
    // save to local
}

- (BOOL)uploadUnlockRecordOfDevice:(NSString *)deviceIdentifire successful:(BOOL)successful
{
    __block BOOL updateSuccessful = NO;
    
    return NO;
}

// upload local unlock record when server is available
- (void)uploadLocalUnlockRecord
{
    if (![self serverAvailable]) {
        return;
    }
}

- (BOOL)serverAvailable
{
    GXReachability *server = [GXReachability reachabilityWithHostName:@"https://115.28.226.149"];
    return ([server currentReachabilityStatus] != NotReachable);
}

@end
