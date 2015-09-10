//
//  GXUnlockRecordModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/10/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXUnlockRecordModel : NSObject

@property (nonatomic) NSInteger unlockRecordID;
@property (nonatomic, strong) NSString *deviceIdentifire;
@property (nonatomic, strong) NSString *relatedUserName;
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) NSInteger eventType;

@end
