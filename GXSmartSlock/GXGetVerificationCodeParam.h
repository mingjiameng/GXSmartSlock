//
//  GXGetVerificationCodeParam.h
//  GXSmartSlock
//
//  Created by zkey on 8/23/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VerificationCodeType) {
    VerificationCodeTypeRegister = 10,
    VerificationCodeTypeResetPassword = 20
};

@interface GXGetVerificationCodeParam : NSObject

@property (nonatomic, strong) NSString *userName;

+ (GXGetVerificationCodeParam *)paramWithUserName:(NSString *)userName;

@end
