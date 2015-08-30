//
//  GXSelectValidDeviceViewController.h
//  GXSmartSlock
//
//  Created by zkey on 8/30/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXDatabaseEntityDevice;

@interface GXSelectValidDeviceViewController : UIViewController

@property (nonatomic, strong) NSArray *validDeviceArray;

@property (nonatomic, copy) void (^deviceSelected) (GXDatabaseEntityDevice *device);

@end
