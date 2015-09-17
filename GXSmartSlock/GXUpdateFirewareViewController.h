//
//  GXUpdateFirewareViewController.h
//  GXSmartSlock
//
//  Created by zkey on 9/17/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXUpdateFirewareViewController : UIViewController

@property (nonatomic, strong) NSString *deviceIdentifire;
@property (nonatomic) NSInteger downloadedVersion; // 本地下载的固件的版本号
@property (nonatomic) NSInteger currentVersion; // 设备当前的版本号

@end
