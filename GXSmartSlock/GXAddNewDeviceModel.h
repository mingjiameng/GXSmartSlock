//
//  GXAddNewDeviceModel.h
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 6/22/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXAddNewDeviceModelDelegate <NSObject>
@required
- (void)deviceHadBeenInitialized;
- (void)setNewDeviceName;
- (void)successfullyPaired:(BOOL)success;
- (void)pressWrongButtonToInitialize;
- (void)noNetwork;

@end

@interface GXAddNewDeviceModel : NSObject

@property (nonatomic, assign) id<GXAddNewDeviceModelDelegate> delegate;

- (void)setNewDeviceName:(NSString *)deviceName;

@end
