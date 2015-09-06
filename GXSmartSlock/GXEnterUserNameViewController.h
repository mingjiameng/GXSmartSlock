//
//  GXEnterUserNameViewController.h
//  GXSmartSlock
//
//  Created by zkey on 9/6/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXEnterUserNameViewController : UIViewController

@property (nonatomic, copy) void (^addUser) (NSString *userName);

@end
