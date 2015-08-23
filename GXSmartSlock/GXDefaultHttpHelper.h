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

@class GXLoginParam, GXGetVerificationCodeParam;

#import "GXGetVerificationCodeParam.h"

@interface GXDefaultHttpHelper : NSObject

+ (void)postWithLoginParam:(GXLoginParam *)param success:(HttpSuccess)success failure:(HttpFailure)failure;
+ (void)postWithGetVerificationCodeParam:(GXGetVerificationCodeParam *)param codeType:(VerificationCodeType)type success:(HttpSuccess)success failure:(HttpFailure)failure;

@end
