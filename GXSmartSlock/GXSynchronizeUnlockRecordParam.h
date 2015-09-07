//
//  GXSynchronizeUnlockRecordParam.h
//  GXSmartSlock
//
//  Created by zkey on 9/7/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXSynchronizeUnlockRecordParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;

+ (GXSynchronizeUnlockRecordParam *)paramWithUserName:(NSString *)userName password:(NSString *)password;

@end
