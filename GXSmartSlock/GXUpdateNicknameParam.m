//
//  GXUpdateNicknameParam.m
//  GXSmartSlock
//
//  Created by zkey on 8/31/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXUpdateNicknameParam.h"

@implementation GXUpdateNicknameParam

+ (GXUpdateNicknameParam *)paramWithUserName:(NSString *)userName password:(NSString *)password nickname:(NSString *)nickname
{
    GXUpdateNicknameParam *param = [[GXUpdateNicknameParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    param.nickname = nickname;
    
    return param;
}

@end
