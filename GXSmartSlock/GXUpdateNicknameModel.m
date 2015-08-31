//
//  GXUpdateNicknameModel.m
//  GXSmartSlock
//
//  Created by zkey on 8/31/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXUpdateNicknameModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_SERVER_INTERFACE.h"

#import "GXUpdateNicknameParam.h"
#import "GXDefaultHttpHelper.h"
#import "GXDatabaseHelper.h"

@implementation GXUpdateNicknameModel

- (void)updateNickname:(NSString *)nickname
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    GXUpdateNicknameParam *param = [GXUpdateNicknameParam paramWithUserName:userName password:password nickname:nickname];
    [GXDefaultHttpHelper postWithUpdateNicknameParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:UPDATE_NICKNAME_STATUS] integerValue];
        if (status == 0) {
            [self.delegate updateNicknameSuccessful:NO];
        } else if (status == 1) {
            [GXDatabaseHelper updateDefaultUserNickname:nickname];
            [self.delegate updateNicknameSuccessful:YES];
        } else {
            [self.delegate updateNicknameSuccessful:NO];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
    
}

@end
