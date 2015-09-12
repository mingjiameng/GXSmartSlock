//
//  NSUUID+help.h
//  GXBLESmartHomeFurnishing
//
//  Created by blue on 14-5-1.
//  Copyright (c) 2014年 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface NSUUID (help)
/**
 *  随机UUID
 */
+ (NSString *)randomUUID;

/**
 *  通过宏定义16进制数获取UUID
 */
- (CBUUID *)UUIDWithCharacteristicUUID:(int16_t)characteristicUUID;

/**
 *  判断UUID是否相同
 */
+ (int)compareCBUUID:(CBUUID *)UUID1 UUID2:(CBUUID *)UUID2;

@end
