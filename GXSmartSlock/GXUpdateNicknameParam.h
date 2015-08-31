//
//  GXUpdateNicknameParam.h
//  GXSmartSlock
//
//  Created by zkey on 8/31/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXUpdateNicknameParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *nickname;

+ (GXUpdateNicknameParam *)paramWithUserName:(NSString *)userName password:(NSString *)password nickname:(NSString *)nickname;


@end
