//
//  GXFirewareUpdateModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/19/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXFirewareUpdateModelDelegate <NSObject>

- (void)noNetwork;
- (void)beginScanForCertainDevice;
- (void)noBluetooth;

- (void)beginUpdateFireware;
- (void)firewareUpdateProgress:(double)progress;
- (void)firewareUpdateComplete;
- (void)firewareUpdateFailed;

//- (void) getUploadTotalTime:(GXFirmwareConnect *)firmware totalTime:(NSString *)totalTime processValue:(CGFloat)value;
//
//- (void) canUploadFirmware:(GXFirmwareConnect *)firmware enable:(BOOL)enable;
//
//- (void) uploadSucceed;

@end



@interface GXFirewareUpdateModel : NSObject

@property (nonatomic, copy) NSString *deviceIdentifire;
@property (nonatomic) NSInteger downloadedVersion;
@property (nonatomic, weak) id<GXFirewareUpdateModelDelegate> delegate;


@property (nonatomic) BOOL isConnected;
@property (nonatomic) BOOL inProgramming;

// connect the guosim device, write the new fireware into device
- (void)updateFireware;

-(id)initWithCurrentDeviceName:(NSString *)currentDeviceName;
- (void)disconnect;
- (void)uploadStart;

@end
