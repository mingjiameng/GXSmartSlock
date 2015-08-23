//
//  GXResetPasswordParam.h
//  GXSmartSlock
//
//  Created by zkey on 8/23/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXResetPasswordParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *verificationCode;

+ (GXResetPasswordParam *)paramWithUserName:(NSString *)userName password:(NSString *)password verificationCode:(NSString *)code;


@end
