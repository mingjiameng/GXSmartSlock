//
//  GXSynchronizeDeviceUserParam.h
//  GXSmartSlock
//
//  Created by zkey on 9/3/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXSynchronizeDeviceUserParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *deviceIdentifire;

+ (GXSynchronizeDeviceUserParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire;

@end
