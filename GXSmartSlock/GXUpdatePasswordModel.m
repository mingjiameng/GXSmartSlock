//
//  GXUpdatePasswordModel.m
//  GXSmartSlock
//
//  Created by zkey on 9/1/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXUpdatePasswordModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_SERVER_INTERFACE.h"

#import "GXUpdatePasswordParam.h"
#import "GXDefaultHttpHelper.h"

@implementation GXUpdatePasswordModel

- (void)updatePassword:(NSString *)nPassword
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    GXUpdatePasswordParam *param = [GXUpdatePasswordParam paramWithUserName:userName password:password nPassword:nPassword];
    [GXDefaultHttpHelper postWithUpdatePasswordParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:UPDATE_PASSWORD_STATUS] integerValue];
        if (status == 0) {
            [self.delegate updatePasswordSuccessful:NO];
        } else if (status == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:nPassword forKey:DEFAULT_USER_PASSWORD];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.delegate updatePasswordSuccessful:YES];
        } else {
            NSLog(@"invalid update password status");
            [self.delegate updatePasswordSuccessful:NO];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
}

@end
