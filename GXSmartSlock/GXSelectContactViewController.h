//
//  GXSelectContactViewController.h
//  GXSmartSlock
//
//  Created by zkey on 9/6/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXSelectContactViewController : UIViewController

@property (nonatomic, strong) void (^addUser) (NSArray *userArray);

@end
