//
//  GXLocalUnlockRecordModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/21/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

// 暂未上传到服务器的开锁记录（开锁行为由当前用户产生）

@interface GXLocalUnlockRecordModel : NSObject

@property (nonatomic, strong) NSString *deviceIdentifire;
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) NSInteger eventType;


@end
