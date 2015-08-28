//
//  GXChangeDeviceNicknameParam.h
//  GXSmartSlock
//
//  Created by zkey on 8/27/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXChangeDeviceNicknameParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *deviceIdentifire;
@property (nonatomic, strong) NSString *deviceNickname;

+ (GXChangeDeviceNicknameParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire newDeviceNickname:(NSString *)deviceNickname;

@end
