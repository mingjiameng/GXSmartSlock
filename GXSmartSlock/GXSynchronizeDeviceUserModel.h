//
//  GXSynchronizeDeviceUserModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/2/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXSynchronizeDeviceUserModelDelegate <NSObject>
@required
- (void)noNetwork;
- (void)synchronizeDeviceUserSuccessful:(BOOL)successful;

@end

@interface GXSynchronizeDeviceUserModel : NSObject

@property (nonatomic, weak) id<GXSynchronizeDeviceUserModelDelegate> delegate;

- (void)synchronizeDeviceUser:(NSString *)deviceIdentifire;

@end
