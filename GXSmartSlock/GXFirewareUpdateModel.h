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

@end



@interface GXFirewareUpdateModel : NSObject

@property (nonatomic, copy) NSString *deviceIdentifire;
@property (nonatomic, weak) id<GXFirewareUpdateModelDelegate> delegate;

// connect the guosim device, write the new fireware into device
- (void)updateFireware;

@end
