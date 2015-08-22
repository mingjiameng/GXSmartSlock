//
//  GXDeviceUserMappingModel.h
//  GXSmartSlock
//
//  Created by zkey on 8/22/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXDeviceUserMappingModel : NSObject

@property (nonatomic) NSInteger deviceUserMappingID;

@property (nonatomic, strong) NSString *deviceIdentifire;

// the owner of the device
@property (nonatomic, strong) NSString *userName;


/*
 * the following data may be used to set the property of default user's device
 */

// nickname of the device setted by user, every user can set their perfered nickname for device
@property (nonatomic, strong) NSString *deviceNickname;

// deviceStatus = “pending” - 等待接受
// deviceStatus = “active” - 可用
@property (nonatomic, strong) NSString *deviceStatus;

// deviceAuthority = “admin” - the user is a administrator who can unlock the door, send key, set permanent/temporary key, manage uses of the device
// deviceAuthority = “anytime” - the user is a normal user who can only unlock the door
@property (nonatomic, strong) NSString *deviceAuthority;

@end
