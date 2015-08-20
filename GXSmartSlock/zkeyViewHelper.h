//
//  zkeyViewHelper.h
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 6/19/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface zkeyViewHelper : NSObject

+ (void)hideExtraSeparatorLine:(UITableView *)tableView;
+ (void)presentLocalNotificationWithMessage:(NSString *)message;
+ (void)alertWithMessage:(NSString *)message inView:(UIView *)view withFrame:(CGRect)frame;

@end
