//
//  GXDefaultHttpHelper.h
//  GXSmartSlock
//
//  Created by zkey on 8/23/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HttpSuccess)(NSDictionary *result);
typedef void(^HttpFailure)(NSError *error);

@class GXLoginParam, GXGetVerificationCodeParam, GXVerifyCodeParam, GXResetPasswordParam, GXRegisterParam, GXChangeDeviceNicknameParam;

#import "GXGetVerificationCodeParam.h"

@interface GXDefaultHttpHelper : NSObject

+ (void)postWithLoginParam:(GXLoginParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithGetVerificationCodeParam:(GXGetVerificationCodeParam *)param codeType:(VerificationCodeType)type success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithVerifyCodeParam:(GXVerifyCodeParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithRegisterParam:(GXRegisterParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithResetPasswordParam:(GXResetPasswordParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;;
+ (void)POstWithChangeDeviceNicknameParam:(GXChangeDeviceNicknameParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;

@end
