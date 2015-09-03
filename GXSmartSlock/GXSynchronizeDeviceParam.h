//
//  GXSynchronizeDeviceParam.h
//  GXSmartSlock
//
//  Created by zkey on 9/3/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXSynchronizeDeviceParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;

+ (GXSynchronizeDeviceParam *)paramWithUserName:(NSString *)userName password:(NSString *)password;

@end
