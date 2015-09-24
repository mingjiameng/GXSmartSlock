//
//  GXRefreshOneTimePasswordViewController.h
//  GXSmartSlock
//
//  Created by zkey on 9/25/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXRefreshOneTimePasswordViewController : UIViewController

@property (nonatomic, copy) NSString *deviceIdentifire;
@property (nonatomic, copy) void (^passwordArrayReceived) (NSArray *passwordArray);

@end
