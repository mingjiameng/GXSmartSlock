//
//  GXSetNicknameViewController.h
//  GXSmartSlock
//
//  Created by zkey on 8/31/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXSetNicknameViewController : UIViewController

@property (nonatomic, copy) void (^defaultUserNicknameChanged) (BOOL changed);

@end
