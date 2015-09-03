//
//  GXSynchronizeDeviceModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/3/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXSynchronizeDeviceModel <NSObject>
@required
- (void)noNetwork;
- (void)synchronizeDeviceSuccessful:(BOOL)successful;

@end


@interface GXSynchronizeDeviceModel : NSObject

@property (nonatomic, weak) id<GXSynchronizeDeviceModel> delegate;

- (void)synchronizeDevice;

@end
