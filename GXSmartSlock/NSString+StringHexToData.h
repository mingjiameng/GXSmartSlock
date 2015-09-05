//
//  NSString+StringHexToData.h
//  GXBLESmartHomeFurnishing
//
//  Created by wjq on 14-12-25.
//  Copyright (c) 2014年 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringHexToData)

-(NSData*) hexToBytes:(NSInteger)index;

@end
