//
//  GXUnlockRecordViewController.h
//  GXSmartSlock
//
//  Created by zkey on 9/7/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UnlockRecordViewType) {
    UnlockRecordViewTypeFromRootView = 10,
    UnlockRecordViewTypeFromDeviceDetailView = 20
};

@interface GXUnlockRecordViewController : UIViewController

@property (nonatomic) UnlockRecordViewType viewType;

@property (nonatomic, strong) NSString *deviceIdentifire;

@end
