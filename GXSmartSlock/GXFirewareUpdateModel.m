//
//  GXFirewareUpdateModel.m
//  GXSmartSlock
//
//  Created by zkey on 9/19/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXFirewareUpdateModel.h"

#import "GXDefaultHttpHelper.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface GXFirewareUpdateModel () <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    CBCentralManager *_updateFirewareCenterManager;
}
@end

@implementation GXFirewareUpdateModel

- (void)updateFireware
{
    if (![GXDefaultHttpHelper isServerAvailable]) {
        [self.delegate noNetwork];
    }
    
    if (_updateFirewareCenterManager == nil) {
        _updateFirewareCenterManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    
    [self startScan];
}

- (void)startScan
{
    
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        [self.delegate noBluetooth];
        return;
    }
}



@end
