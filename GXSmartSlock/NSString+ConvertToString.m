//
//  NSString+GXConvertString.m
//  GXBLESmartHomeFurnishing
//
//  Created by wjq on 14-12-30.
//  Copyright (c) 2014年 guosim. All rights reserved.
//

#import "NSString+ConvertToString.h"

@implementation NSString (ConvertToString)

-(NSString *)ConvertToString
{
    NSMutableString *str = [[NSMutableString alloc]initWithString:self];
    [str replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0,[str length])];
    [str replaceOccurrencesOfString:@"<" withString:@"" options:0 range:NSMakeRange(0,[str length])];
    [str replaceOccurrencesOfString:@">" withString:@"" options:0 range:NSMakeRange(0,[str length])];
    return str;
}

@end
