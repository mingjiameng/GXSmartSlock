//
//  GXDeviceDetailViewController.h
//  GXSmartSlock
//
//  Created by zkey on 8/26/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXDatabaseEntityDevice;

@interface GXDeviceDetailViewController : UIViewController

@property (nonatomic, strong)  GXDatabaseEntityDevice *deviceEntity;

@property (nonatomic, copy) void (^deviceInformationChanged) (BOOL changed);

@end
