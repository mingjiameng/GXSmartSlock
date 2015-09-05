//
//  GXAddNewDeviceParam.h
//  GXSmartSlock
//
//  Created by zkey on 9/5/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXAddNewDeviceParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *deviceIdentifire;
@property (nonatomic, strong) NSString *secretKey;
@property (nonatomic, strong) NSString *deviceNickname;
@property (nonatomic, strong) NSString *batteryLevel;
@property (nonatomic, strong) NSString *deviceLocation;
@property (nonatomic, strong) NSString *deviceVersion;

@end
