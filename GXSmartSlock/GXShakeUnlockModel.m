//
//  GXShakeUnlockModel.m
//  GXSmartSlock
//
//  Created by zkey on 9/11/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXShakeUnlockModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_UNLOCK.h"

#import "NSString+ConvertToString.h"
#import "NSData+ToNSString.h"
#import "NSString+StringHexToData.h"
#import "NSData+AES.h"


#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreMotion/CoreMotion.h>

#define DEVICE_MOTION_UPDATE_TIME_INTERVAL 0.02
#define SHAKE_PENDING_TIME_INTERVAL 0.05

#define UNLOCK_ANGLE_LIMIT_LOW 0.3
#define UNLOCK_ANGLE_LIMIT_HIGH 0.6

#define UNLOCK_ANGLE_WAVE_LANDSCAPE_X 0.3
#define UNLOCK_ANGLE_WAVE_LANDSCAPE_Y 0.5

#define UNLOCK_ANGLE_WAVE_PORTRAIT_X 0.5
#define UNLOCK_ANGLE_WAVE_PORTRAIT_Y 0.3

@interface GXShakeUnlockModel () <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    CBCentralManager *_shakeUnlockCentralManager;
    
    //    store the connected pheripheral and the mathching device
    //    ({
    //        @"peripheral" : CBPeripheral
    //        @"deviceIdentifire" : NSString
    //        @"secretKey" : NSString
    //        @"characteristic" : NSArray
    //        @"token" : NSData
    //        @"writeUnlock" : NSNumber (Bool)
    //        @"batteryRead" : NSNumber (Bool)
    //    },
    //     ...
    //    )
    NSMutableArray *_peripheralProccessingArray;
    
    bool _isShaking;
    bool _isDetectShaking;
    CMMotionManager *_motionManager; // detect shaking
    NSTimer *_updateTimer;
    double _previousUnlockAngle;
    double _angle;
    bool _angleBeginChange;
}
@end



@implementation GXShakeUnlockModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _shakeUnlockCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        _peripheralProccessingArray = [NSMutableArray array];
        
        _previousUnlockAngle = _angle = 0x3f3f3f3f;
        _angleBeginChange = true;
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = DEVICE_MOTION_UPDATE_TIME_INTERVAL;
    }
    
    return self;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    
    [_shakeUnlockCentralManager scanForPeripheralsWithServices:@[GX_UNLOCK_SERVICE_CBUUID_IDENTIFY] options:nil];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    //NSLog(@"auto unlock advertisement data:%@", advertisementData);
    // get peripheral name
    NSString *deviceIdentifire = peripheral.name;
    if (deviceIdentifire == nil) {
        deviceIdentifire = advertisementData[GX_UNLOCK_ADVERTISEMENT_VERIFY];
    }
    
    if (deviceIdentifire == nil) {
        return;
    }
    
    if (![self isGuosimDevice:deviceIdentifire]) {
        return;
    }
    
    if ([self isDeviceHandled:deviceIdentifire]) {
        return;
    }
    
    NSString *correspondSecretKey = [self.delegate secretKeyForDevice:deviceIdentifire];
    // device do not exist in database
    if (correspondSecretKey == nil) {
        return;
    }
    
    if (!_isShaking) {
        if (!_isDetectShaking) {
            [self detectShaking];
            _isDetectShaking = true;
        }
        
        return;
    }
    
    // remark peripheral which is to connect
    NSDictionary *tmpNewReadyPeripheral = @{PERIPHERAL : peripheral,
                                            DEVICE_IDENTIFIRE : deviceIdentifire,
                                            SECRET_KEY :  correspondSecretKey,
                                            RSSI_NUMBER : RSSI};
    NSMutableDictionary *newReadyPeripheral = [NSMutableDictionary dictionaryWithDictionary:tmpNewReadyPeripheral];
    
    [_peripheralProccessingArray addObject:newReadyPeripheral];
    
    [central connectPeripheral:peripheral options:nil];
}

- (BOOL)isGuosimDevice:(NSString *)deviceIdentifire
{
    if (deviceIdentifire.length < 6) {
        return NO;
    }
    
    NSString *slockString = [deviceIdentifire substringToIndex:5];
    if (![slockString isEqualToString:@"Slock"]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isDeviceHandled:(NSString *)deviceIdentifire
{
    BOOL handled = NO;
    
    NSString *tmpDeviceIdentifire = nil;
    for (NSMutableDictionary *peripheralProccessing in _peripheralProccessingArray) {
        tmpDeviceIdentifire = [peripheralProccessing objectForKey:DEVICE_IDENTIFIRE];
        if ([deviceIdentifire isEqualToString:tmpDeviceIdentifire]) {
            handled = YES;
            break;
        }
    }
    
    return handled;
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"shake unlock connect peripheral:%@", peripheral);
    
    peripheral.delegate = self;
    [peripheral discoverServices:@[GX_UNLOCK_SERVICE_CBUUID_UNLOCK]];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"shake unlock fail to connect with peripheral:%@ ,error:%@", peripheral, error);
    
    [self cancelHandleWithDevice:peripheral.name];
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        [self cancelHandleWithDevice:peripheral.name];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        if ([service.UUID isEqual:GX_UNLOCK_SERVICE_CBUUID_UNLOCK]) {
            [peripheral discoverCharacteristics:@[GX_UNLOCK_CHARACTERISTICS_CBUUID_READ_TOKEN] forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        [self cancelHandleWithDevice:peripheral.name];
        return;
    }
    
    // 验证token是否已经读到token
    NSData *token = nil;
    NSString *batteryRead = nil;
    NSNumber *writeUnlock = nil;
    
    NSString *tmpDeviceIdentifire = nil;
    for (NSMutableDictionary *peripheralProccessing in _peripheralProccessingArray) {
        tmpDeviceIdentifire = [peripheralProccessing objectForKey:DEVICE_IDENTIFIRE];
        if ([peripheral.name isEqualToString:tmpDeviceIdentifire]) {
            token = [peripheralProccessing objectForKey:TOKEN];
            batteryRead = [peripheralProccessing objectForKey:BATTERY_READ];
            writeUnlock = [peripheralProccessing objectForKey:WRITE_UNLOCK];
            break;
        }
    }
    
    if (token == nil) {
        // 先读token
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:GX_UNLOCK_CHARACTERISTICS_CBUUID_READ_TOKEN]) {
                [self readWriteCharacteristics:characteristic inPeripheral:peripheral];
                break;
            }
        }
    } else {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:GX_UNLOCK_CHARACTERISTICS_CBUUID_WRITE_UNLOCK]) {
                if (batteryRead != nil && writeUnlock == nil) {
                    [self readWriteCharacteristics:characteristic inPeripheral:peripheral];
                }
            } else if ([characteristic.UUID isEqual:GX_UNLOCK_CHARACTERISTICS_CBUUID_READ_BATTERY_LEVEL]) {
                //NSLog(@"search charac battery level");
                if (batteryRead == nil) {
                    [self readWriteCharacteristics:characteristic inPeripheral:peripheral];
                }
            }
        }
    }
    
}

/*
 * 蓝牙特征值更新
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        [self cancelHandleWithDevice:peripheral.name];
        return;
    }
    
    // read token
    if ([characteristic.UUID isEqual:GX_UNLOCK_CHARACTERISTICS_CBUUID_READ_TOKEN]) {
        if (characteristic.value.description.length < 32) {
            [self cancelHandleWithDevice:peripheral.name];
        }
        
        NSData *token = characteristic.value;
        if (token.length) {
            NSString *tmpDeviceIdentifire = nil;
            for (NSMutableDictionary *peripheralProccessing in _peripheralProccessingArray) {
                tmpDeviceIdentifire = [peripheralProccessing objectForKey:DEVICE_IDENTIFIRE];
                if ([peripheral.name isEqualToString:tmpDeviceIdentifire]) {
                    [peripheralProccessing setObject:token forKey:TOKEN];
                    break;
                }
            }
            
            [peripheral discoverCharacteristics:@[GX_UNLOCK_CHARACTERISTICS_CBUUID_READ_BATTERY_LEVEL] forService:characteristic.service];
        }
    } else if ([characteristic.UUID isEqual:GX_UNLOCK_CHARACTERISTICS_CBUUID_READ_BATTERY_LEVEL]) {
        // read battery level
        NSString *batteryLevelString = [NSString stringWithFormat:@"%ld", strtoul([[characteristic.value.description ConvertToString] UTF8String], 0, 16)];
        float batteryLevel = [batteryLevelString floatValue];
        NSLog(@"%f", batteryLevel);
        
        NSString *tmpDeviceIdentifire = nil;
        for (NSMutableDictionary *peripheralProccessing in _peripheralProccessingArray) {
            tmpDeviceIdentifire = [peripheralProccessing objectForKey:DEVICE_IDENTIFIRE];
            if ([peripheral.name isEqualToString:tmpDeviceIdentifire]) {
                [peripheralProccessing setObject:[NSNumber numberWithBool:true] forKey:BATTERY_READ];
                break;
            }
        }
        
        // save battery level to local database
        [self.delegate updateBatteryLevel:[batteryLevelString integerValue] ofDevice:peripheral.name];
        if (batteryLevel <= LOW_BATTERY_LEVEL) {
            [self.delegate lowBatteryAlert:peripheral.name];
        }
        
        // discover unlock service
        [peripheral discoverCharacteristics:@[GX_UNLOCK_CHARACTERISTICS_CBUUID_WRITE_UNLOCK] forService:characteristic.service];
    }
    
}

// successfully write unlock
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error != nil) {
        [self.delegate unlockTheDevice:peripheral.name successful:NO];
    } else {
        [self.delegate unlockTheDevice:peripheral.name successful:YES];
    }
    
    [self cancelHandleWithDevice:peripheral.name];
}

#pragma mark - helper function
- (void)readWriteCharacteristics:(CBCharacteristic *)characteristic inPeripheral:(CBPeripheral *)peripheral
{
    // 1. token 2. battery level 3. write unlock
    
    if ([characteristic.UUID isEqual:GX_UNLOCK_CHARACTERISTICS_CBUUID_READ_TOKEN]) {
        // read token
        [peripheral readValueForCharacteristic:characteristic];
    } else if ([characteristic.UUID isEqual:GX_UNLOCK_CHARACTERISTICS_CBUUID_WRITE_UNLOCK]) {
        // write - unlock
        NSString *deviceIdentifire;
        NSString *deviceSecrectKey;
        NSData *deviceToken;
        NSNumber *deviceRSSI;
        
        for (NSMutableDictionary *peripheralProccessing in _peripheralProccessingArray) {
            deviceIdentifire = [peripheralProccessing objectForKey:DEVICE_IDENTIFIRE];
            if ([peripheral.name isEqualToString:deviceIdentifire]) {
                deviceSecrectKey = [peripheralProccessing objectForKey:SECRET_KEY];
                deviceToken = [peripheralProccessing objectForKey:TOKEN];
                deviceRSSI = [peripheralProccessing objectForKey:RSSI_NUMBER];
                break;
            }
        }
        
        // do not check RSSI under manul unlock mode
        
        //        NSInteger rssi = [deviceRSSI integerValue];
        //        rssi = labs(rssi);
        //        if (rssi > MAX_UNLOCK_RSSI) {
        //            [self.delegate tooLowSemaphoreToUnlock];
        //            [self cancelHandleWithDevice:peripheral.name];
        //            return;
        //        }
        
        NSString *key_convert = [deviceSecrectKey ConvertToString];
        NSString *token_convert = [deviceToken ConvertToNSString];
        NSData *tokenData = [token_convert hexToBytes:2];
        NSMutableData *secretData = (NSMutableData *)[SECRET_PREFIX hexToBytes:2];
        NSData *encryptData = [tokenData AES256EncryptWithKey:key_convert];
        [secretData appendData:encryptData];
        
        [peripheral writeValue:secretData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        
    } else if ([characteristic.UUID isEqual:GX_UNLOCK_CHARACTERISTICS_CBUUID_READ_BATTERY_LEVEL]) {
        // read battery level
        [peripheral readValueForCharacteristic:characteristic];
    }
    
}

- (void)startScan
{
    [_shakeUnlockCentralManager scanForPeripheralsWithServices:@[GX_UNLOCK_SERVICE_CBUUID_IDENTIFY] options:nil];
}

- (void)stopScan
{
    [_shakeUnlockCentralManager stopScan];
    
    CBPeripheral *correspondPeripheral;
    for (NSMutableDictionary *connectedPeripheral in _peripheralProccessingArray) {
        correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
        [_shakeUnlockCentralManager cancelPeripheralConnection:correspondPeripheral];
    }
    
    [_peripheralProccessingArray removeAllObjects];
}

- (void)cancelHandleWithDevice:(NSString *)deviceIdentifire
{
    _isShaking = false;
    
    NSString *tmpDeviceIdentifire = nil;
    for (NSMutableDictionary *peripheralProccessing in _peripheralProccessingArray) {
        tmpDeviceIdentifire = [peripheralProccessing objectForKey:DEVICE_IDENTIFIRE];
        if ([deviceIdentifire isEqualToString:tmpDeviceIdentifire]) {
            CBPeripheral *pheripheral = [peripheralProccessing objectForKey:PERIPHERAL];
            [_shakeUnlockCentralManager cancelPeripheralConnection:pheripheral];
            
            [_peripheralProccessingArray removeObject:peripheralProccessing];
        }
    }
    
    [self startScan];
}

- (void)dealloc
{
    _shakeUnlockCentralManager = nil;
}


#pragma mark - detect shaking
- (void)detectShaking
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopScan];
        
        [_motionManager startDeviceMotionUpdates];
        
        _updateTimer = [NSTimer timerWithTimeInterval:SHAKE_PENDING_TIME_INTERVAL target:self selector:@selector(pendingShake) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_updateTimer forMode:NSDefaultRunLoopMode];
        [_updateTimer fire];
        
        [self performSelector:@selector(refreshScanState) withObject:nil afterDelay:8.0];
    });
    
    
}

- (void)pendingShake
{
    CMAcceleration gravityAcceleration = _motionManager.deviceMotion.gravity;

    double angle = atan2(gravityAcceleration.x, gravityAcceleration.y);
    
    if (_angle > 100.0f) {
        _angle = angle;
        return;
    }
    
    if (fabs(_angle) < 0.0001) {
        _angle = angle;
        return;
    }
    
    if (_previousUnlockAngle < 100.0f) {
        if (fabs(_previousUnlockAngle - _angle) < 0.0001) {
            _angle = angle;
            return;
        }
    }
    
    //NSLog(@"x:%lf y:%lf", gravityAcceleration.x, gravityAcceleration.y);
    
    if ([self pendingShakingWithPreviousAngle:_angle currentAngle:angle] && [self isCurrentGestureValid:gravityAcceleration]) {
        //NSLog(@"shaking!!!!!!");
        _angle = 0x3f3f3f3f;
        _previousUnlockAngle = angle;
        
        _isShaking = true;
        [self startScan];
        
        [self performSelector:@selector(invalidateShakingState) withObject:nil afterDelay:3.0f];
        [self stopDetectShaking];
    }
    
    _angle = angle;
}

// 瞬时转过的角度是否符合要求
- (BOOL)pendingShakingWithPreviousAngle:(double)angle1 currentAngle:(double)angle2
{
    double rotation = 0.0f;
    
    if ((angle1 <= 0 && angle2 <=0) || (angle1 >=0 && angle2 >= 0)) {
        rotation = fabs(angle1 - angle2);
    } else {
        angle1 = fabs(angle1);
        angle2 = fabs(angle2);
        rotation = 2 * M_PI - angle1 - angle2;
    }
    
    //NSLog(@"rotation:%lf", rotation);
    
    if (rotation > UNLOCK_ANGLE_LIMIT_LOW && rotation < UNLOCK_ANGLE_LIMIT_HIGH ) {
        return YES;
    }
    
    return NO;
}

// 瞬时所在的角度是否符合要求
- (BOOL)isCurrentGestureValid:(CMAcceleration)gravityAcceleration
{
    // 手机处于landscap状态
    if (fabs(gravityAcceleration.x - 1) < UNLOCK_ANGLE_WAVE_LANDSCAPE_X && fabs(gravityAcceleration.y) < UNLOCK_ANGLE_WAVE_LANDSCAPE_Y ) {
        return YES;
    }
    
    if (fabs(gravityAcceleration.x + 1) < UNLOCK_ANGLE_WAVE_LANDSCAPE_X && fabs(gravityAcceleration.y) < UNLOCK_ANGLE_WAVE_LANDSCAPE_Y) {
        return YES;
    }
    
    // 不能支持portrait 因为用户在接听手机的时候 手机就处于portrait状态
//    // 手机处于portrait状态
//    if (fabs(gravityAcceleration.x) < UNLOCK_ANGLE_WAVE_PORTRAIT_X && fabs(gravityAcceleration.y - 1) < UNLOCK_ANGLE_WAVE_PORTRAIT_Y) {
//        return YES;
//    }
    
    return NO;
}

- (void)invalidateShakingState
{
    _isShaking = false;
    [self startScan];
}

- (void)refreshScanState
{
    [self stopDetectShaking];
    
    [self startScan];
}

- (void)stopDetectShaking
{
    [_updateTimer invalidate];
    [_motionManager stopDeviceMotionUpdates];
    
    _isDetectShaking = false;
    
    _angle = 0x3f3f3f3f;
}


@end
