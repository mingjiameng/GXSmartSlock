//
//  GXDeleteDeviceModel.h
//  GXSmartSlock
//
//  Created by zkey on 8/29/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXDeleteDeviceModelDelegate <NSObject>

- (void)deleteDeviceSuccessful:(BOOL)successful;
- (void)deviceHasBeenDeleted;
- (void)noNetwork;

@end

@interface GXDeleteDeviceModel : NSObject

@property (nonatomic, weak) id<GXDeleteDeviceModelDelegate> delegate;

- (void)deleteDeviceWithIdentifire:(NSString *)deviceIdentifire authorityStatus:(NSString *)deviceAuthority;

@end
