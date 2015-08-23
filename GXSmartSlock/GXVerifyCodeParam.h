//
//  GXVerifyCodeParam.h
//  GXSmartSlock
//
//  Created by zkey on 8/23/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXVerifyCodeParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *verificationCode;

+ (GXVerifyCodeParam *)paramWithUserName:(NSString *)userName verificationCode:(NSString *)code;

@end
