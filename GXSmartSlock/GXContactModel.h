//
//  GXContactModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/6/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXContactModel : NSObject

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *nickname;

+ (GXContactModel *)modelWithUserName:(NSString *)phoneNumber nickname:(NSString *)nickname;

@end
