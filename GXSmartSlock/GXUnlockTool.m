//
//  GXUnlockTool.m
//  GXSmartSlock
//
//  Created by zkey on 9/8/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXUnlockTool.h"

#import "MICRO_COMMON.h"
#import "MICRO_DEVICE_LIST.h"

#import "GXDatabaseEntityDevice.h"
#import "GXDatabaseEntityUser.h"
#import "GXDatabaseEntityLocalUnlockRecord.h"

#import "GXDatabaseHelper.h"
#import "GXReachability.h"
#import "GXDefaultHttpHelper.h"
#import "GXUpdateDeviceBatteryLevelParam.h"
#import "GXLocalUnlockRecordModel.h"
#import "GXUploadUnlockRecordParam.h"

#import "GXManulUnlockModel.h"
#import "GXAutoUnlockModel.h"
#import "GXShakeUnlockModel.h"

#import "zkeyViewHelper.h"

#import <CoreData/CoreData.h>

#define MANUL_UNLOCK_SCAN_DURATION 10.0f

@interface GXUnlockTool () <GXUnlockModelDelegate, NSFetchedResultsControllerDelegate>
{
    NSDictionary *_deviceKeyDic;
    NSDictionary *_deviceCategoryDic;
    DefaultUnlockMode _currentUnlockMode;
    
    GXManulUnlockModel *_manulUnlockModel;
    GXAutoUnlockModel *_autoUnlockModel;
    GXShakeUnlockModel *_shakeUnlockModel;
    
    BOOL _isUploadingUnlockRecord;
}
@property (nonatomic, strong) NSFetchedResultsController *localUnlockRecordFetchedResultsController;

@end

@implementation GXUnlockTool

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _isUploadingUnlockRecord = NO;
        
        [self updateDeviceKeyDictionary];
        
        [self updateUnlockMode];
        
        [self trackLocalUnlockRecord];
    }
    
    return self;
}

- (void)updateUnlockMode
{
    // stop scan
    if (_currentUnlockMode == DefaultUnlockModeAuto) {
        if (_autoUnlockModel != nil) {
            [_autoUnlockModel stopScan];
        }
    } else if (_currentUnlockMode == DefaultUnlockModeManul) {
        if (_manulUnlockModel != nil) {
            [_manulUnlockModel stopScan];
        }
    } else if (_currentUnlockMode == DefaultUnlockModeShake) {
        if (_shakeUnlockModel != nil) {
            [_shakeUnlockModel stopScan];
        }
    }
    
    // switch unlock mode
    DefaultUnlockMode unlockMode = [[[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_UNLOCK_MODE] integerValue];
    _currentUnlockMode = unlockMode;
    
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
    NSMutableDictionary *tmpDeviceCategoryDic = [NSMutableDictionary dictionary];
    for (GXDatabaseEntityDevice *deviceEntity in validDeviceArray) {
        [tmpDeviceKeyDic setObject:deviceEntity.deviceKey forKey:deviceEntity.deviceIdentifire];
        [tmpDeviceCategoryDic setObject:deviceEntity.deviceCategory forKey:deviceEntity.deviceIdentifire];
    }
    
    _deviceKeyDic = (NSDictionary *)tmpDeviceKeyDic;
    _deviceCategoryDic = (NSDictionary *)tmpDeviceCategoryDic;
}

- (void)trackLocalUnlockRecord
{
    _localUnlockRecordFetchedResultsController = [GXDatabaseHelper allLocalUnlockRecordFetchedResultsController];
    _localUnlockRecordFetchedResultsController.delegate = self;
}

- (void)manulUnlock
{
    if (_manulUnlockModel != nil) {
        
        typeof(self) __weak weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_manulUnlockModel startScan];
            [weakSelf performSelector:@selector(forceStopUnlockAction) withObject:nil afterDelay:MANUL_UNLOCK_SCAN_DURATION];
        });
    }
}

- (void)forceStopUnlockAction
{
    if (_manulUnlockModel == nil) {
        return;
    }
    
    [_manulUnlockModel stopScan];
    
    if ([self.delegate respondsToSelector:@selector(forceStopUnlock)]) {
        [self.delegate forceStopUnlock];
    }
}

#pragma mark - unlock delegate
- (void)tooLowSemaphoreToUnlock
{
    [zkeyViewHelper presentLocalNotificationWithMessage:@"信号弱，请您靠近门锁"];
}

- (void)updateBatteryLevel:(NSInteger)batteryLevel ofDevice:(NSString *)deviceIdentifire
{
    // save to local
    [GXDatabaseHelper device:deviceIdentifire updateBatteryLevel:batteryLevel];
    
    // send to server
    [self uploadBatteryLevel:batteryLevel ofDevice:deviceIdentifire];
}

- (void)lowBatteryAlert:(NSString *)deviceIdentifire
{
    [zkeyViewHelper presentLocalNotificationWithMessage:@"⚠低电量，请尽快更换电池"];
    
    GXLocalUnlockRecordModel *unlockRecord = [[GXLocalUnlockRecordModel alloc] init];
    unlockRecord.event = @"⚠低电量，请尽快更换电池";
    unlockRecord.eventType = 11;
    unlockRecord.deviceIdentifire = deviceIdentifire;
    unlockRecord.date = [NSDate date];
    
    [GXDatabaseHelper addLocalUnlockRecordIntoDatabase:@[unlockRecord]];
}

- (NSString *)secretKeyForDevice:(NSString *)deviceIdentifire
{
    NSString *secretKey = [_deviceKeyDic objectForKey:deviceIdentifire];
    
    if (secretKey != nil) {
        // 门禁锁不支持感应开锁
        NSString *deviceCategory = [_deviceCategoryDic objectForKey:deviceIdentifire];
        if (deviceCategory == nil) {
            return nil;
        }
        
        if ([deviceCategory isEqualToString:DEVICE_CATEGORY_GUARD] && _currentUnlockMode == DefaultUnlockModeAuto) {
            return nil;
        }
    }
    
    return secretKey;
}

- (void)unlockTheDevice:(NSString *)deviceIdentifire successful:(BOOL)successful
{
    // stop the animation if the current unlock mode is manulUnlock
    if (successful) {
        if ([self.delegate respondsToSelector:@selector(successfullyUnlockDevice:)]) {
            [self.delegate successfullyUnlockDevice:deviceIdentifire];
        }
    }
    
    GXDatabaseEntityDevice *device = [GXDatabaseHelper deviceEntityWithDeviceIdentifire:deviceIdentifire];
    GXDatabaseEntityUser *user = [GXDatabaseHelper defaultUser];
    
    GXLocalUnlockRecordModel *unlockRecord = [[GXLocalUnlockRecordModel alloc] init];
    // save to local
    if (successful) {
        unlockRecord.event = [NSString stringWithFormat:@"%@开锁%@成功", user.nickname, device.deviceNickname];
        unlockRecord.eventType = 1;
    } else {
        unlockRecord.event = [NSString stringWithFormat:@"%@开锁%@失败", user.nickname, device.deviceNickname];
        unlockRecord.eventType = 2;
    }
    
    unlockRecord.deviceIdentifire = deviceIdentifire;
    unlockRecord.date = [NSDate date];
    
    [GXDatabaseHelper addLocalUnlockRecordIntoDatabase:@[unlockRecord]];
}

/*
 * STRATEGY OF SYNCHRONIZING BATTERY LEVEL
 * Battery level is not a crucial value for user, so user has no need to know the latest value of battery level
 * As a result, we only need to update battery level to server every time we unlock the door && server is avaiable
 * For that the user who just login should know battery level of each device
 */
- (void)uploadBatteryLevel:(NSInteger)batteryLevel ofDevice:(NSString *)deviceIdentifire
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    GXUpdateDeviceBatteryLevelParam *param = [GXUpdateDeviceBatteryLevelParam paramWithUserName:userName password:password deviceIdentifire:deviceIdentifire batteryLevel:batteryLevel];
    
    [GXDefaultHttpHelper postWithUpdateBatteryLevelParam:param success:^(NSDictionary *result) {
        
    } failure:^(NSError *error) {
        
    }];
}

/*
 * STRATEGY OF SYNCHRONIZE UNLOCK RECORD
 * upload unlock record as soon as possible should be the principle
 * so we need to observer the change of local database (need record may be created)
 * and try to upload local unlock record every time user open the APP
 * or the network condition change (user turn on the network)
 */

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if (type == NSFetchedResultsChangeInsert) {
        if (!_isUploadingUnlockRecord) {
            [self uploadLocalUnlockRecord];
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type == NSFetchedResultsChangeInsert) {
        if (!_isUploadingUnlockRecord) {
            [self uploadLocalUnlockRecord];
        }
    }
}

- (void)uploadLocalUnlockRecord
{
    if (_isUploadingUnlockRecord) {
        return;
    }
    
    _isUploadingUnlockRecord = YES;
    
    if (![GXDefaultHttpHelper isServerAvailable]) {
        //NSLog(@"上传开锁记录没有网络");
        _isUploadingUnlockRecord = NO;
        return;
    }
    
    NSArray *localUnlockRecordArray = [GXDatabaseHelper allLocalUnlockRecordArray];
    if (localUnlockRecordArray == nil || localUnlockRecordArray.count <= 0) {
        _isUploadingUnlockRecord = NO;
        return;
    }
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    for (GXDatabaseEntityLocalUnlockRecord *unlockRecordEntity in localUnlockRecordArray) {
        GXUploadUnlockRecordParam *param = [[GXUploadUnlockRecordParam alloc] init];
        
        param.userName = userName;
        param.password = password;
        param.deviceIdentifire = unlockRecordEntity.deviceIdentifire;
        param.event = unlockRecordEntity.event;
        param.eventType = [NSString stringWithFormat:@"%@", unlockRecordEntity.eventType];
        param.timeIntervalString = [NSString stringWithFormat:@"%.0lf", [unlockRecordEntity.date timeIntervalSince1970] * 1000];
        
        [GXDefaultHttpHelper postWithUploadLocalUnlockRecordParam:param success:^(NSDictionary *result) {
            NSInteger status = [[result objectForKey:@"status"] integerValue];
            if (status == 1) {
                [GXDatabaseHelper deleteLocalUnlockRecordEntity:unlockRecordEntity];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    _isUploadingUnlockRecord = NO;
    return;
}

@end
