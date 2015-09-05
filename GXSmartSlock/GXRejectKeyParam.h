//
//  GXRejectKeyParam.h
//  GXSmartSlock
//
//  Created by zkey on 9/4/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXRejectKeyParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *deviceIdentifire;

+ (GXRejectKeyParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire;

@end
