//
//  GXSendKeyParam.h
//  GXSmartSlock
//
//  Created by zkey on 9/7/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXSendKeyParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *deviceIdentifire;
@property (nonatomic, strong) NSString *receiverUserName;
@property (nonatomic, strong) NSString *authorityType;

+ (GXSendKeyParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire receiverUserName:(NSString *)receiver authorityType:(NSString *)type;

@end
