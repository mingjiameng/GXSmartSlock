//
//  FHGesturePasswordViewController.h
//  FenHongForIOS
//
//  Created by zkey on 8/6/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GesturePasswordViewType) {
    GesturePasswordViewTypeVerification = 1 << 0, // 应用进入前台验证
    GesturePasswordViewTypeReset = 1 << 2, // 重置
    GesturePasswordViewTypeClear = 1 << 3,  // 关闭
    GesturePasswordViewTypeSet = 1 << 4 // 打开
};

@interface FHGesturePasswordViewController : UIViewController

@property (nonatomic) GesturePasswordViewType viewType;

@property (nonatomic, copy) void (^gesturePasswordChanged) (BOOL changed);

@end
