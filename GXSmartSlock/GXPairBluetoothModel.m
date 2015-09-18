//
//  GXPairBluetoothModel.m
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 7/25/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXPairBluetoothModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_ADD_NEW_DEVICE.h"

#import "NSString+StringHexToData.h"
#import "NSString+ConvertToString.h"

#import "GXAddNewDeviceParam.h"
#import "GXDefaultHttpHelper.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface GXPairBluetoothModel () <CBCentralManagerDelegate, CBPeripheralDelegate>

@end

@implementation GXPairBluetoothModel
{
    CBCentralManager *_pairBluetoothCentralManager;
    
    //    store the connected pheripheral and the mathching device
    //    ({
    //        @"peripheral" : CBPeripheral
    //        @“deviceID” : NSString
    //        @"deviceName" : NSString
    //        @"secretKey" : NSString
    //        @"deviceVersion" : NSString
    //        @"canBeInitialized" : BOOL
    //    },
    //     ...
    //    )
    NSMutableArray *_connectedPeripheralArray;
    NSMutableArray *_peripheralReadyToConnectArray;
}

- (instancetype)initWithDelegate:(id<GXPairBluetoothModelDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
        
        _pairBluetoothCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        _connectedPeripheralArray = [NSMutableArray array];
        _peripheralReadyToConnectArray = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    
    //NSLog(@"bluetooth available");
    
    [_pairBluetoothCentralManager scanForPeripheralsWithServices:@[GX_PAIR_SERVICE_CBUUID_IDENTIFY] options:nil];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //NSLog(@"advertisementData: %@", advertisementData);
    
    // contain the specify service
    NSSet *serviceUuidSet = [advertisementData objectForKey:ADVERTISEMENT_DATA_KEY_UUIDS];
    if (![serviceUuidSet containsObject:GX_PAIR_SERVICE_CBUUID_IDENTIFY]) {
        return;
    }
    
    // check service_id's validity
    //NSString *deviceID = [advertisementData objectForKey:ADVERTISEMENT_DATA_KEY_LOCAL_NAME];
    NSString *deviceID = peripheral.name;
    if (deviceID.length < 5) {
        return;
    }
    
    NSString *peripheralNamePrefix = [deviceID substringWithRange:(NSRange){0,5}];
    if (![peripheralNamePrefix isEqualToString:@"Slock"]) {
        return;
    }
    
    // if the peripheral exist in the _connectedPeripheralArray
    // then no action needed
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *deviceIDExist = nil;
//        for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
//            deviceIDExist = [connectedPeripheral objectForKey:DEVICE_ID];
//            NSLog(@"deviceIDExist:%@", deviceIDExist);
//            if ([deviceIDExist isEqualToString:deviceID]) {
//                return;
//            }
//        }
//    });
    
    // the RSSI is large enough
    // TO DO ...
    
    // whether user press unlock button
    
    if ([serviceUuidSet containsObject:GX_UNLOCK_SERVICE_CBUUID_IDENTIFY]) {
        if ([self.delegate respondsToSelector:@selector(pressWrongButton)]) {
            [self.delegate pressWrongButton];
            //[self refreshPeripheral];
            return;
        }
    }
    
    NSLog(@"prepare to connect peripheral: %@", deviceID);
    NSDictionary *newReadyPeripheral = @{PERIPHERAL : peripheral,
                                         DEVICE_ID : peripheral.name};
    
    NSLog(@"prepare to connect data package:%@", newReadyPeripheral);
    [_peripheralReadyToConnectArray addObject:[NSMutableDictionary dictionaryWithDictionary:newReadyPeripheral]];
    
    [central connectPeripheral:peripheral options:nil];
}


#pragma mark - CBPeripheralDelegate
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (_connectedPeripheralArray.count <= 0) {
        [self refreshPeripheral];
    }
    
    return;
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"connect peripheral: %@", peripheral.name);
    
    // remark connected peripheral
    CBPeripheral *correspondPeripheral;
    for (NSMutableDictionary *readyPeripheral in _peripheralReadyToConnectArray) {
        correspondPeripheral = [readyPeripheral objectForKey:PERIPHERAL];
        if ([correspondPeripheral isEqual:peripheral]) {
            [_connectedPeripheralArray addObject:readyPeripheral];
            break;
        }
    }
    
    peripheral.delegate = self;
    
    // try to read device version
    // all other task should perform after this
    [peripheral discoverServices:@[GX_PAIR_SERVICE_CBUUID_OAD]];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}

// peripheral discover service
// there are two kind of service in the advertisement data
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error != nil) {
        [self refreshPeripheral];
    }
    
    for (CBService *service in peripheral.services) {
        NSLog(@"did discovery service: %@", service.UUID);
        if ([service.UUID isEqual:GX_PAIR_SERVICE_CBUUID_MAIN]) {
            
            // task related with characteristic in GX_PAIR_SERVICE_CBUUID_MAIN should be performed after reading the device version
            CBPeripheral *correspondPeripheral;
            for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
                correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
                if (![correspondPeripheral isEqual:peripheral]) {
                    continue;
                }
                
                if ([connectedPeripheral objectForKey:DEVICE_VERSION] != nil) {
                    NSLog(@"begin to discovery character - secret key");
                    [peripheral discoverCharacteristics:@[GX_PAIR_CHARACTERISTIC_READ_SECRET_KEY] forService:service];
                    break;
                }
            }
        } else if ([service.UUID isEqual:GX_PAIR_SERVICE_CBUUID_OAD]) {
            // read device version
            CBPeripheral *correspondPeripheral;
            for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
                correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
                if (![correspondPeripheral isEqual:peripheral]) {
                    continue;
                }
                
                if ([connectedPeripheral objectForKey:DEVICE_VERSION] == nil) {
                    [peripheral discoverCharacteristics:@[GX_PAIR_CHARACTERISTIC_DEVICE_VERSION] forService:service];
                    break;
                }
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error != nil) {
        [self refreshPeripheral];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([service.UUID isEqual:GX_PAIR_SERVICE_CBUUID_MAIN]) {
            [self readWriteCharacteristics:characteristic inPeripheral:peripheral];
        } else if ([service.UUID isEqual:GX_PAIR_SERVICE_CBUUID_OAD]) {
            [self initializeDeviceForReadWrite:peripheral characteristic:characteristic];
        }
    }
}

// initialized the device for read/write
- (void)initializeDeviceForReadWrite:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic
{
    if ([characteristic.UUID isEqual:GX_PAIR_CHARACTERISTIC_DEVICE_VERSION]) {
        CBPeripheral *correspondPeripheral;
        for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
            correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
            if (![correspondPeripheral isEqual:peripheral]) {
                continue;
            }
            
            if ([connectedPeripheral objectForKey:DEVICE_VERSION] == nil) {
                NSLog(@"begin to initialized to read device version");
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                break;
            }
        }
    }
}

// call back of the selector(setNotifyValue)
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"update notification state, characteristic:%@", characteristic);
    if ([characteristic.UUID isEqual:GX_PAIR_CHARACTERISTIC_DEVICE_VERSION] && characteristic.isNotifying) {
        CBPeripheral *correspondPeripheral;
        for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
            correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
            if (![correspondPeripheral isEqual:peripheral]) {
                continue;
            }
            
            if ([connectedPeripheral objectForKey:DEVICE_VERSION] == nil) {
                NSData *data = [@"00" hexToBytes:2];
                NSLog(@"begin to write to read device version");
                [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                break;
            }
        }
    } else if ([characteristic.UUID isEqual:GX_PAIR_CHARACTERISTIC_PREPARE_FOR_INITIALIZATION]) {
        [peripheral readValueForCharacteristic:characteristic];
    }
}

// characteristic in GX_PAIR_SERVICE_CBUUID_MAIN
- (void)readWriteCharacteristics:(CBCharacteristic *)characteristic inPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"read write character:%@", characteristic.UUID);
    // 1. read secret key
    if ([characteristic.UUID isEqual:GX_PAIR_CHARACTERISTIC_READ_SECRET_KEY]) {
        CBPeripheral *correspondPeripheral;
        for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
            correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
            if ([correspondPeripheral isEqual:peripheral]) {
                if ([connectedPeripheral objectForKey:DEVICE_VERSION] != nil && [connectedPeripheral objectForKey:SECRET_KEY] == nil) {
                    [peripheral readValueForCharacteristic:characteristic];
                }
                break;
            }
        }
        
        return;
    }
    
    // 2. read battery level
    if ([characteristic.UUID isEqual:GX_PAIR_CHARACTERISTIC_READ_BATTERY_LEVEL]) {
        CBPeripheral *correspondPeripheral;
        for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
            correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
            if ([correspondPeripheral isEqual:peripheral]) {
                // read battery level after reading secret key
                if ([connectedPeripheral objectForKey:SECRET_KEY] != nil && [connectedPeripheral objectForKey:BATTERY_LEVEL] == nil) {
                    NSLog(@"begin to read battery level");
                    [peripheral readValueForCharacteristic:characteristic];
                }
                break;
            }
        }
        
        return;
    }
    
    // 3. read device category
    if ([characteristic.UUID isEqual:GX_PAIR_CHARACTERISTIC_READ_DEVICE_CATEGORY]) {
        CBPeripheral *correspondPeripheral;
        for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
            correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
            if ([correspondPeripheral isEqual:peripheral]) {
                // read battery level after reading secret key
                if ([connectedPeripheral objectForKey:BATTERY_LEVEL] != nil && [connectedPeripheral objectForKey:DEVICE_CATEGORY] == nil) {
                    NSLog(@"begin to read device category");
                    [peripheral readValueForCharacteristic:characteristic];
                }
                break;
            }
        }
        
        return;
    }
    
    // 3. prepare for initialize
    if ([characteristic.UUID isEqual:GX_PAIR_CHARACTERISTIC_PREPARE_FOR_INITIALIZATION]) {
        CBPeripheral *correspondPeripheral;
        for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
            correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
            if ([correspondPeripheral isEqual:peripheral]) {
                // initialize the device after reading the battery level
                if ([connectedPeripheral objectForKey:DEVICE_CATEGORY] && ![connectedPeripheral objectForKey:DEVICE_NAME]) {
                    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                }
                break;
            }
        }
        
        return;
    }
    
    // 4. write initialized
    if ([characteristic.UUID isEqual:GX_PAIR_CHARACTERISTIC_WRITE_INITIALIZATION]) {
        CBPeripheral *correspondPeripheral;
        for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
            correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
            if ([correspondPeripheral isEqual:peripheral]) {
                // initialize the device after user setting the device name
                if ([connectedPeripheral objectForKey:DEVICE_NAME] != nil) {
                    NSData *data = [@"03" hexToBytes:2];
                    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                }
                break;
            }
        }
        
        return;

    }
}



#pragma mark - call back of read/write characteristic
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"write value characteristic:%@", characteristic);
    if (error != nil) {
        [self refreshPeripheral];
        return;
    }
    
    if ([characteristic.UUID isEqual:GX_PAIR_CHARACTERISTIC_DEVICE_VERSION]) {
        CBPeripheral *correspondPeripheral;
        for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
            correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
            if (![correspondPeripheral isEqual:peripheral]) {
                continue;
            }
            
            NSLog(@"has written for read device version, begin to read device version");
            
            if ([connectedPeripheral objectForKey:DEVICE_VERSION] == nil) {
                NSLog(@"write initialization successful then read device version");
                [peripheral readValueForCharacteristic:characteristic];
                break;
            }
        }
        
    } else if ([characteristic.UUID isEqual:GX_PAIR_CHARACTERISTIC_WRITE_INITIALIZATION]) {
        // write initialization success, send the data to server
        [_pairBluetoothCentralManager stopScan];
        NSLog(@"written initialization complete");
        [self sendInitializationDataToServer:peripheral];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // 0. read device version - service_main
    if ([characteristic.UUID isEqual:GX_PAIR_CHARACTERISTIC_DEVICE_VERSION]) {
        unsigned char data[characteristic.value.length];
        [characteristic.value getBytes:&data];
        uint16_t number = ((uint16_t)data[1] << 8 & 0xff00) | ((uint16_t)data[0] & 0xff);
        uint16_t deviceVersionNumber =  number >> 1;
        NSString  *deviceVersion = [NSString stringWithFormat:@"%d",deviceVersionNumber];
        
        NSLog(@"device version:%@", deviceVersion);
        
        CBPeripheral *correspondPeripheral;
        for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
            correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
            if ([correspondPeripheral isEqual:peripheral]) {
                [connectedPeripheral setValue:deviceVersion forKey:DEVICE_VERSION];
                [peripheral discoverServices:@[GX_PAIR_SERVICE_CBUUID_MAIN]];
                break;
            }
        }
        return;
    }
    
    NSString *characteristicValue = characteristic.value.description;
    
    // 1. read secret key
    if ([characteristic.UUID isEqual:GX_PAIR_CHARACTERISTIC_READ_SECRET_KEY]) {
        NSString *deviceSecretKey = [characteristicValue ConvertToString];
        NSLog(@"secret key:%@", deviceSecretKey);
        CBPeripheral *correspondPeripheral;
        for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
            correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
            if ([correspondPeripheral isEqual:peripheral]) {
                [connectedPeripheral setValue:deviceSecretKey forKey:SECRET_KEY];
                NSLog(@"set secret key");
                [peripheral discoverCharacteristics:@[GX_PAIR_CHARACTERISTIC_READ_BATTERY_LEVEL, GX_PAIR_CHARACTERISTIC_READ_DEVICE_CATEGORY] forService:characteristic.service];
                break;
            }
        }
        
        return;
    }
    
    // 2. read battery level
    if ([characteristic.UUID isEqual:GX_PAIR_CHARACTERISTIC_READ_BATTERY_LEVEL]) {
        NSString *batteryLevel = [NSString stringWithFormat:@"%ld", strtoul([[characteristicValue ConvertToString] UTF8String],0,16)];
        NSNumber *batteryLevelNumber = [NSNumber numberWithDouble:[batteryLevel floatValue]];
        NSLog(@"battery level:%@", batteryLevelNumber);
        CBPeripheral *correspondPeripheral;
        for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
            correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
            if ([correspondPeripheral isEqual:peripheral]) {
                [connectedPeripheral setValue:batteryLevelNumber forKey:BATTERY_LEVEL];
                
                // check whether property FFF8(deviceCategory) exists in the service FFF0
                bool deviceCategoryExist = false;
                for (CBCharacteristic *characteristicExist in characteristic.service.characteristics) {
                    if ([characteristicExist.UUID isEqual:GX_PAIR_CHARACTERISTIC_READ_DEVICE_CATEGORY]) {
                        deviceCategoryExist = true;
                        break;
                    }
                }
                
                if (deviceCategoryExist) {
                    [peripheral discoverCharacteristics:@[GX_PAIR_CHARACTERISTIC_READ_DEVICE_CATEGORY] forService:characteristic.service];
                } else {
                    [connectedPeripheral setObject:GX_PAIR_DEFAULT_DEVICE_CATEGORY forKey:DEVICE_CATEGORY];
                    [peripheral discoverCharacteristics:@[GX_PAIR_CHARACTERISTIC_PREPARE_FOR_INITIALIZATION] forService:characteristic.service];
                }
                
                break;
            }
        }
        
        return;
    }
    
    // 4. read device category
    if ([characteristic.UUID isEqual:GX_PAIR_CHARACTERISTIC_READ_DEVICE_CATEGORY]) {
        NSString *deviceCategory = [characteristicValue stringByTrimmingCharactersInSet:[NSCharacterSet symbolCharacterSet]];
        if (deviceCategory.length == 2) {
            deviceCategory = [deviceCategory stringByAppendingString:@"01"];
        }
        NSLog(@"device category readed:%@", deviceCategory);
        
        CBPeripheral *correspondPeripheral;
        for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
            correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
            if ([correspondPeripheral isEqual:peripheral]) {
                [connectedPeripheral setValue:deviceCategory forKey:DEVICE_CATEGORY];
                [peripheral discoverCharacteristics:@[GX_PAIR_CHARACTERISTIC_PREPARE_FOR_INITIALIZATION] forService:characteristic.service];
                break;
            }
        }
        
        return;
    }
    
    // 5. prepare for initialization - the status of the device
    // device has been initialized ?
    if ([characteristic.UUID isEqual:GX_PAIR_CHARACTERISTIC_PREPARE_FOR_INITIALIZATION]) {
        if ([characteristicValue isEqualToString:GX_PAIR_DEVICE_STATUS_WAIT_FOR_INITIALIZATION]) {
            CBPeripheral *correspondPeripheral;
            for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
                correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
                if ([correspondPeripheral isEqual:peripheral]) {
                    [connectedPeripheral setValue:[NSNumber numberWithBool:YES] forKey:CAN_BE_INITIALIZED];
                    break;
                }
            }
            
            [self.delegate getDeviceNameOfPeripheral:peripheral forService:characteristic.service];
        } else if ([characteristicValue isEqualToString:GX_PAIR_DEVICE_STATUS_INITIALIZED]) {
            // check the status of this periphral
            // if the user is going to name the pheripheral
            // then ignore this
            CBPeripheral *correspondPeripheral;
            for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
                correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
                if ([correspondPeripheral isEqual:peripheral]) {
                    if ([[connectedPeripheral objectForKey:CAN_BE_INITIALIZED] boolValue]) {
                        return;
                    }
                    break;
                }
            }
            
            // stop scan and exist for "addNewDevice"
            //[self refreshPeripheral];
            if ([self.delegate respondsToSelector:@selector(deviceHasBeenInitialized)]) {
                [self stopScan];
                [self.delegate deviceHasBeenInitialized];
            }
        }
        
        return;
    }
}


// disconnect with all peripheral firstly
// and restart all task
- (void)stopScan
{
    [_pairBluetoothCentralManager stopScan];
    
    CBPeripheral *correspondPeripheral;
    for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
        correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
        [_pairBluetoothCentralManager cancelPeripheralConnection:correspondPeripheral];
    }
    
    [_connectedPeripheralArray removeAllObjects];
    [_peripheralReadyToConnectArray removeAllObjects];
    
    NSLog(@"zkey stop scan");
}

- (void)refreshPeripheral
{
    NSLog(@"pair refresh");
    
    [self stopScan];
    // restart all task
    [_pairBluetoothCentralManager scanForPeripheralsWithServices:@[GX_PAIR_SERVICE_CBUUID_IDENTIFY] options:nil];
}

- (void)initializePeripheral:(CBPeripheral *)peripheral withName:(NSString *)deviceName inService:(CBService *)service
{
    CBPeripheral *correspondPeripheral;
    for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
        correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
        if ([correspondPeripheral isEqual:peripheral]) {
            [connectedPeripheral setValue:deviceName forKey:DEVICE_NAME];
            //NSLog(@"written initialization:%@", connectedPeripheral);
            [peripheral discoverCharacteristics:@[GX_PAIR_CHARACTERISTIC_WRITE_INITIALIZATION] forService:service];
            break;
        }
    }
}

- (void)sendInitializationDataToServer:(CBPeripheral *)peripheral
{
    NSDictionary *peripheralData = nil;
    CBPeripheral *correspondPeripheral;
    for (NSMutableDictionary *connectedPeripheral in _connectedPeripheralArray) {
        correspondPeripheral = [connectedPeripheral objectForKey:PERIPHERAL];
        NSLog(@"correspondPeripheral:%@", correspondPeripheral);
        if ([correspondPeripheral.identifier isEqual:peripheral.identifier]) {
            peripheralData = connectedPeripheral;
            break;
        }
    }
    //NSLog(@"peripheral:%@", peripheral);
    
    //NSLog(@"peripheral data %@", peripheralData);
    
    GXAddNewDeviceParam *param = [[GXAddNewDeviceParam alloc] init];
    
    param.userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    param.password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    param.deviceNickname = [peripheralData objectForKey:DEVICE_NAME];
    param.secretKey = [peripheralData objectForKey:SECRET_KEY];
    param.batteryLevel = [peripheralData objectForKey:BATTERY_LEVEL];
    param.deviceIdentifire = peripheral.name;
    param.deviceVersion = [peripheralData objectForKey:DEVICE_VERSION];
    param.deviceLocation = @"北京市";
    param.deviceCategory = [peripheralData objectForKey:DEVICE_CATEGORY];
    
    [GXDefaultHttpHelper postWithAddNewDeviceParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        if (status == 1) {
            [self.delegate pairSuccess:YES];
        } else {
            [self.delegate pairSuccess:NO];
        }
    } failure:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(noNetwork)]) {
            [self.delegate noNetwork];
        }
    }];
    
    [self stopScan];
}


- (void)dealloc
{
    _peripheralReadyToConnectArray = nil;
    _connectedPeripheralArray = nil;
}

@end
