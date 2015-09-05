//
//  GXReceiveKeyParam.h
//  GXSmartSlock
//
//  Created by zkey on 9/5/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXReceiveKeyParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *deviceIdentifire;

+ (GXReceiveKeyParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceNickname:(NSString *)nickname forDevice:(NSString *)deviceIdentifire;

@end
