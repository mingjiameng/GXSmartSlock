//
//  GXRegisterParam.h
//  GXSmartSlock
//
//  Created by zkey on 8/23/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXRegisterParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *verificationCode;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *phoneInfo;

+ (GXRegisterParam *)paramWithUserName:(NSString *)userName nickname:(NSString *)nickname password:(NSString *)password verificationCode:(NSString *)code phoneInfo:(NSString *)phoneInfo;

@end
