//
//  GXContactModel.m
//  GXSmartSlock
//
//  Created by zkey on 9/6/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXContactModel.h"

@implementation GXContactModel

+ (GXContactModel *)modelWithUserName:(NSString *)phoneNumber nickname:(NSString *)nickname
{
    GXContactModel *model = [[GXContactModel alloc] init];
    
    model.phoneNumber = phoneNumber;
    model.nickname = nickname;
    
    return model;
}

@end
