//
//  NSString+GXConvertString.h
//  GXBLESmartHomeFurnishing
//
//  Created by wjq on 14-12-30.
//  Copyright (c) 2014年 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ConvertToString)

/**
 * 去除<>和空格，从FFF4读取的值是带有<>和空格的
 */
-(NSString *)ConvertToString;

@end
