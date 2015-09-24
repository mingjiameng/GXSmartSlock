//
//  GXUnlockRecordDetailViewDataModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/24/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXUnlockRecordDetailViewDataModel : NSObject

@property (nonatomic, strong) NSString *deviceIdentifire;
@property (nonatomic, strong) NSString *deviceNickname;
@property (nonatomic, strong) NSString *deviceCategory;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSString *relatedUserNickname;

@end
