//
//  GXPairBluetoothModel.h
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 7/25/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol GXPairBluetoothModelDelegate <NSObject>
@required
- (void)getDeviceNameOfPeripheral:(CBPeripheral *)peripheral forService:(CBService *)service;
- (void)pairSuccess:(BOOL)succeed;

@optional
- (void)noNetwork;
- (void)pressWrongButton;
- (void)deviceHasBeenInitialized;
@end



@interface GXPairBluetoothModel : NSObject

@property (nonatomic, weak) id<GXPairBluetoothModelDelegate> delegate;

- (instancetype)initWithDelegate:(id<GXPairBluetoothModelDelegate>)delegate;

- (void)initializePeripheral:(CBPeripheral *)peripheral withName:(NSString *)deviceName inService:(CBService *)service;

@end
