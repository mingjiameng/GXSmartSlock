//
//  GXUpdateProfileImageParam.m
//  GXSmartSlock
//
//  Created by zkey on 8/31/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXUpdateProfileImageParam.h"

@implementation GXUpdateProfileImageParam

+ (GXUpdateProfileImageParam *)paramWithUserName:(NSString *)userName password:(NSString *)password imageString:(NSString *)imageString
{
    GXUpdateProfileImageParam *param = [[GXUpdateProfileImageParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    param.imageBase64String = imageString;
    
    return param;
}

@end
