//
//  NSString+StringHexToData.m
//  GXBLESmartHomeFurnishing
//
//  Created by wjq on 14-12-25.
//  Copyright (c) 2014年 guosim. All rights reserved.
//

#import "NSString+StringHexToData.h"

@implementation NSString (StringHexToData)

-(NSData*) hexToBytes:(NSInteger)index
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+index <= self.length; idx+=index) {
        NSRange range = NSMakeRange(idx, index);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

@end
