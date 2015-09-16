//
//  GXUpdateUnlockRecordParam.h
//  GXSmartSlock
//
//  Created by zkey on 9/12/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXUpdateUnlockRecordParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *deviceIdentifire;
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *dateTimeIntervalString;

@end
