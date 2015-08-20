//
//  zkeyViewHelper.m
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 6/19/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "zkeyViewHelper.h"
#import "zkeyAlertBanner.h"

@implementation zkeyViewHelper
+ (void)hideExtraSeparatorLine:(UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

+ (void)presentLocalNotificationWithMessage:(NSString *)message
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = message;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

+ (void)alertWithMessage:(NSString *)message inView:(UIView *)view withFrame:(CGRect)frame
{
    zkeyAlertBanner *alertBarnner = [[zkeyAlertBanner alloc] initWithFrame:frame message:message];
    alertBarnner.alpha = 0;
    [view addSubview:alertBarnner];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        alertBarnner.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
            alertBarnner.alpha = 0;
        } completion:^(BOOL finished) {
            [alertBarnner removeFromSuperview];
        }];
    }];
}


@end
