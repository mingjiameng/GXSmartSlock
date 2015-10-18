//
//  GXPasswordModel.m
//  GXSmartSlock
//
//  Created by zkey on 10/18/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXPasswordModel.h"

#import "MICRO_PASSWORD.h"

@implementation GXPasswordModel

+ (GXPasswordType)passwordTypeAccordingToString:(NSString *)passwordString
{
    if ([passwordString isEqualToString:PASSWORD_TYPE_NORMAL]) {
        return GXPasswordTypeNormal;
    } else if ([passwordString isEqualToString:PASSWORD_TYPE_ONCE]) {
        return GXPasswordTypeOnce;
    } else if ([passwordString isEqualToString:PASSWORD_TYPE_TEMPORARY]) {
        return GXPasswordTypeTemporary;
    }
    
    return GXPasswordTypeOnce;
}

@end
