//
//  GXChangeDeviceNicknameModel.h
//  GXSmartSlock
//
//  Created by zkey on 8/27/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXChangeDeviceNicknameModelDelegate <NSObject>
@required
- (void)changeDeviceNicknameSuccess:(BOOL)successful;
- (void)noNetwork;
@end

@interface GXChangeDeviceNicknameModel : NSObject

@property (nonatomic, weak) id<GXChangeDeviceNicknameModelDelegate> delegate;

- (void)changeDeviceName:(NSString *)deviceIdentifire deviceNickname:(NSString *)nickname;

@end
