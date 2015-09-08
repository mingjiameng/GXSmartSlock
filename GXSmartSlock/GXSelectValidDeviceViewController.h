//
//  GXSelectValidDeviceViewController.h
//  GXSmartSlock
//
//  Created by zkey on 8/30/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SelectValidDeviceViewType) {
    SelectValidDeviceViewTypeSendKey = 10,
    SelectValidDeviceViewTypeUnlockRecord = 20
};

@class GXDatabaseEntityDevice;

@interface GXSelectValidDeviceViewController : UIViewController

@property (nonatomic, strong) NSArray *validDeviceArray;

@property (nonatomic, copy) void (^deviceSelected) (GXDatabaseEntityDevice *device);

@property (nonatomic) SelectValidDeviceViewType viewType;

@end
