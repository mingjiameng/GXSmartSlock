//
//  GXUnlockRecordTableViewCellData.h
//  GXSmartSlock
//
//  Created by zkey on 9/7/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXUnlockRecordTableViewCellData : NSObject

// the preson who unlock the unlock
@property (nonatomic, strong) NSString *event;

@property (nonatomic, strong) NSString *profileImageURL;

// the time when the door was unlocked
@property (nonatomic, strong) NSDate *date;

// the device that user unlocked
@property (nonatomic, strong) NSString *deviceNickname;

@end
