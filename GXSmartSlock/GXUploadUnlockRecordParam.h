//
//  GXUploadUnlockRecordParam.h
//  GXSmartSlock
//
//  Created by zkey on 9/21/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXUploadUnlockRecordParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *deviceIdentifire;
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *timeIntervalString;



@end
