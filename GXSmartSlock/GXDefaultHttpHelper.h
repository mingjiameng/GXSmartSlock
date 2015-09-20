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

#import "GXLoginParam.h"
#import "GXGetVerificationCodeParam.h"
#import "GXVerifyCodeParam.h"
#import "GXRegisterParam.h"
#import "GXResetPasswordParam.h"
#import "GXChangeDeviceNicknameParam.h"
#import "GXDeleteDeviceParam.h"
#import "GXUpdateProfileImageParam.h"
#import "GXUpdateNicknameParam.h"
#import "GXUpdatePasswordParam.h"
#import "GXDeleteAuthorizedUserParam.h"
#import "GXSynchronizeDeviceUserParam.h"
#import "GXSynchronizeDeviceParam.h"
#import "GXRejectKeyParam.h"
#import "GXReceiveKeyParam.h"
#import "GXAddNewDeviceParam.h"
#import "GXSynchronizeUnlockRecordParam.h"
#import "GXSendKeyParam.h"

#import "GXGetVerificationCodeParam.h"

@interface GXDefaultHttpHelper : NSObject

+ (void)postWithLoginParam:(GXLoginParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithGetVerificationCodeParam:(GXGetVerificationCodeParam *)param codeType:(VerificationCodeType)type success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithVerifyCodeParam:(GXVerifyCodeParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithRegisterParam:(GXRegisterParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithResetPasswordParam:(GXResetPasswordParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;;
+ (void)postWithChangeDeviceNicknameParam:(GXChangeDeviceNicknameParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithDeleteDeviceParam:(GXDeleteDeviceParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postwithUpdateProfileImageParam:(GXUpdateProfileImageParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithUpdateNicknameParam:(GXUpdateNicknameParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithUpdatePasswordParam:(GXUpdatePasswordParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithDeleteAuthorizedUserParam:(GXDeleteAuthorizedUserParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithSynchronizeDeviceUserParam:(GXSynchronizeDeviceUserParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithSynchronizeDeviceParam:(GXSynchronizeDeviceParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithRejectKeyParam:(GXRejectKeyParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithReceiveKeyParam:(GXReceiveKeyParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithAddNewDeviceParam:(GXAddNewDeviceParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithSynchronizeUnlockRecordParam:(GXSynchronizeUnlockRecordParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithSendKeyParam:(GXSendKeyParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;;


+ (BOOL)isServerAvailable;

@end
