//
//  GXRegisterModel.h
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 7/15/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MICRO_LOGIN.h"

@protocol GXRegisterModelDelegate <NSObject>
@optional

// 没有网络连接
- (void)noNetwork;

// 不合法的用户名
- (void)invalidUserName;

// 合法的用户名
- (void)validUserName;

// 验证码错误
- (void)wrongValidCode;

// 验证码正确
- (void)correctValidCode;

// 注册/重置 成功
- (void)registerOrResetSucceed;

// 注册/重置 失败
- (void)registerOrResetFailed;

@end

@interface GXRegisterModel : NSObject

@property (nonatomic, weak) id<GXRegisterModelDelegate> delegate;

- (void)getValidCode:(NSString *)userName withType:(RegisterViewType)type;
- (void)checkValidCode:(NSString *)validCode withUserName:(NSString *)userName;
- (void)resetPassWordWithUserName:(NSString *)userName password:(NSString *)password validityCode:(NSString *)validityCode;
- (void)registerWithUserName:(NSString *)userName nickname:(NSString *)nickname password:(NSString *)password validityCode:(NSString *)validityCode;

@end
