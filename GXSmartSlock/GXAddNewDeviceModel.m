//
//  GXAddNewDeviceModel.m
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 6/22/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//


#import "GXAddNewDeviceModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_SERVER_INTERFACE.h"

#import "GXPairBluetoothModel.h"

#import "GXSynchronizeDeviceParam.h"
#import "GXDefaultHttpHelper.h"
#import "GXServerDataAnalyst.h"

#import <CoreBluetooth/CoreBluetooth.h>


@interface GXAddNewDeviceModel () <GXPairBluetoothModelDelegate>
{
    GXPairBluetoothModel *_pairBluetoothModel;
    CBPeripheral *_peripheral;
    CBService *_service;
}
@end

@implementation GXAddNewDeviceModel
#pragma mark - initialize
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _pairBluetoothModel = [[GXPairBluetoothModel alloc] initWithDelegate:self];
    }
    
    return self;
}


#pragma mark - GXPairBLEInformationCollect delegate
- (void)pressWrongButton
{
    //[self.delegate pressWrongButtonToInitialize];
}

- (void)deviceHasBeenInitialized
{
    [self.delegate deviceHadBeenInitialized];
}

- (void)getDeviceNameOfPeripheral:(CBPeripheral *)peripheral forService:(CBService *)service
{
    _peripheral = peripheral;
    _service = service;
    [self.delegate setNewDeviceName];
}

- (void)noNetwork
{
    [self.delegate noNetwork];
}

- (void)pairSuccess:(BOOL)succeed
{
    if (succeed) {
        [self synchronizeDevice];
    } else {
        [self.delegate successfullyPaired:NO];
    }
}

#pragma mark - add device into database
- (void)setNewDeviceName:(NSString *)deviceName
{
    [_pairBluetoothModel initializePeripheral:_peripheral withName:deviceName inService:_service];
}

- (void)synchronizeDevice
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    GXSynchronizeDeviceParam *param = [GXSynchronizeDeviceParam paramWithUserName:userName password:password];
    [GXDefaultHttpHelper postWithSynchronizeDeviceParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:SYNCHRONIZE_DEVICE_STATUS] integerValue];
        if (status == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *userArray = [result objectForKey:SYNCHRONIZE_DEVICE_USER];
                [GXServerDataAnalyst insertUserIntoDatabase:userArray];
                
                NSArray *deviceArray = [result objectForKey:SYNCHRONIZE_DEVICE_DEVICE];
                [GXServerDataAnalyst insertDeviceIntoDatabase:deviceArray];
                
                NSArray *deviceUserMappingArray = [result objectForKey:SYNCHRONIZE_DEVICE_MAPPING];
                [GXServerDataAnalyst insertDeviceUserMappingItemIntoDatabase:deviceUserMappingArray];
            });
        }
        
        [self.delegate successfullyPaired:YES];
    } failure:^(NSError *error) {
        [self.delegate successfullyPaired:YES];
    }];
    
}

@end
