//
//  GXFirmwareConnect.h
//  GXBLESmartHomeFurnishing
//
//  Created by wjq on 15-1-19.
//  Copyright (c) 2015年 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "oad.h"

#define HI_UINT16(a) (((a) >> 8) & 0xff)
#define LO_UINT16(a) ((a) & 0xff)

@protocol GXFirewareUpdateDelegate <NSObject>

- (void)noNetwork;
- (void)noBluetooth;
- (void)beginUpdateFireware;

- (void)firewareUpdateFailed;
- (void)firewareUpdateProgress:(double)progress;
- (void)firewareUpdateComplete;

@end

@interface GXFirmwareConnect : NSObject

@property NSString * imgVersion;

@property (nonatomic, copy) NSString *currentDeviceName;
@property (nonatomic,retain) NSTimer *uploadTimer;
@property (weak, nonatomic) id<GXFirewareUpdateDelegate> delegate;
@property (nonatomic,assign) NSInteger fw_version;
@property (nonatomic,assign) BOOL inProgramming;
@property (nonatomic,assign) BOOL isConnected;

-(id)initWithCurrentDeviceName:(NSString *)currentDeviceName;
- (void)disconnect;
- (void)startScan;
//- (void)uploadStart;
@end
