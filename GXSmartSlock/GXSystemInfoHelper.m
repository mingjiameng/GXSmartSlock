//
//  GXSystemInfoHelper.m
//  FenHongForIOS
//
//  Created by zkey on 8/4/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "GXSystemInfoHelper.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIDevice.h>

@implementation GXSystemInfoHelper

/**
 * 获取手机型号
 */
+ (NSString*)getDeviceInfo:(NSString *)platform
{
    NSString *deviceVersion;
    if ([platform isEqualToString:@"iPhone1,1"]) deviceVersion = @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) deviceVersion = @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) deviceVersion = @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) deviceVersion = @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) deviceVersion = @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) deviceVersion = @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) deviceVersion = @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) deviceVersion = @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) deviceVersion = @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) deviceVersion = @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) deviceVersion = @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) deviceVersion = @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) deviceVersion = @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) deviceVersion = @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) deviceVersion = @"iPhone 6";
    
    if ([platform isEqualToString:@"iPod1,1"])   deviceVersion = @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   deviceVersion = @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   deviceVersion = @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   deviceVersion = @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   deviceVersion = @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   deviceVersion = @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   deviceVersion = @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])   deviceVersion = @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])   deviceVersion = @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])   deviceVersion = @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   deviceVersion = @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   deviceVersion = @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   deviceVersion = @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   deviceVersion = @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   deviceVersion = @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   deviceVersion = @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   deviceVersion = @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   deviceVersion = @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   deviceVersion = @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   deviceVersion = @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   deviceVersion = @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   deviceVersion = @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])   deviceVersion = @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   deviceVersion = @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   deviceVersion = @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      deviceVersion = @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    deviceVersion = @"iPhone Simulator";

    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSString *phone_info = [NSString stringWithFormat:@"%@,系统版本：%@",deviceVersion,phoneVersion];
    NSLog(@"%@", phone_info);
    return phone_info;
}


@end
