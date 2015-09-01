//
//  GXUpdatePasswordParam.h
//  GXSmartSlock
//
//  Created by zkey on 9/1/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXUpdatePasswordParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *nPassword;

+ (GXUpdatePasswordParam *)paramWithUserName:(NSString *)userName password:(NSString *)password nPassword:(NSString *)nPassword;

@end
