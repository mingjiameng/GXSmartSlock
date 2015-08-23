//
//  GXSystemInfoHelper.h
//  FenHongForIOS
//
//  Created by zkey on 8/4/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXSystemInfoHelper : NSObject

/**
 * 获取手机型号
 */
+ (NSString*)getDeviceInfo:(NSString *)platform;

@end
