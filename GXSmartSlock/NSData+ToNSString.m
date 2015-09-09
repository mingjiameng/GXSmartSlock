//
//  NSData+ToNSString.m
//  GXBLESmartHomeFurnishing
//
//  Created by wjq on 14-12-25.
//  Copyright (c) 2014年 guosim. All rights reserved.
//

#import "NSData+ToNSString.h"

@implementation NSData (ToNSString)

- (NSString *)ConvertToNSString
{
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[self length]*2];
    
    
    const unsigned char *szBuffer = [self bytes];
    
    
    for (NSInteger i=0; i < [self length]; ++i) {
        
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
        
    }
    
    
    return strTemp;
}

@end
