//
//  GXDeleteAuthorizedUserParam.h
//  GXSmartSlock
//
//  Created by zkey on 9/2/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXDeleteAuthorizedUserParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *deviceIdentifire;
@property (nonatomic, strong) NSString *deletedUserName;

+ (GXDeleteAuthorizedUserParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire deletedUserName:(NSString *)deletedUserName;

@end
