//
//  GXDeleteDeviceParam.h
//  GXSmartSlock
//
//  Created by zkey on 8/29/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXDeleteDeviceParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *deviceIdentifire;
@property (nonatomic, strong) NSString *deviceAuthority;

+ (GXDeleteDeviceParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire deviceAuthority:(NSString *)deviceAuthority;

@end
