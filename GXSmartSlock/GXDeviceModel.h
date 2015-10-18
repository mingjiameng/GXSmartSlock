//
//  GXDeviceModel.h
//  GXSmartSlock
//
//  Created by zkey on 8/22/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXDeviceModel : NSObject

/*
 * the following data is provided in "Mapping" table in server
 */

// deviceAuthority = “admin” - the user is a administrator who can unlock the door, send key, set permanent/temporary key, manage uses of the device
// deviceAuthority = “anytime” - the user is a normal user who can only unlock the door
@property (nonatomic, strong) NSString *deviceAuthority;

// nickname of the device setted by user, every user can set their perfered nickname for device
@property (nonatomic, strong) NSString *deviceNickname;

// deviceStatus = “pending” - 等待接受
// deviceStatus = “active” - 可用
@property (nonatomic, strong) NSString *deviceStatus;



/*
 * the following data is provided in "Device" table in server
 */

@property (nonatomic) NSInteger deviceBattery;

// deviceCategory = "0101" - 普通门锁
// deviceCategory = "0201" － 门禁
// deviceCategory = "0301" - 电机
// deviceCategory = "0401" - 室内锁
@property (nonatomic, strong) NSString *deviceCategory;

@property (nonatomic) NSInteger deviceID;

// deviceIdentifire is a string with prefix "Slock"
@property (nonatomic, strong) NSString *deviceIdentifire;

// device key is used to write into door lock chip so that we can unlock the door
@property (nonatomic, strong) NSString *deviceKey;



// deviceVersion is a integer which indicate the verson of door lock hardware
@property (nonatomic) NSInteger deviceVersion;


@property (nonatomic) BOOL repeaterSupported;

@end
