//
//  GXUpdateDeviceBatteryLevelParam.h
//  GXSmartSlock
//
//  Created by zkey on 9/21/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXUpdateDeviceBatteryLevelParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *deviceIdentifire;
@property (nonatomic, strong) NSString *batteryLevelString;

+ (GXUpdateDeviceBatteryLevelParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire batteryLevel:(NSInteger)batteryLevel;

@end
