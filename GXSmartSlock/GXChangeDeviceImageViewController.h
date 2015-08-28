//
//  GXChangeDeviceImageViewController.h
//  GXSmartSlock
//
//  Created by zkey on 8/27/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXDatabaseEntityDevice;

@interface GXChangeDeviceImageViewController : UIViewController

@property (nonatomic, strong) GXDatabaseEntityDevice *deviceEntity;

@property (nonatomic, copy) void (^deviceImageChanged) (BOOL changed);

@end
