//
//  GXChangeDeviceNicknameModel.m
//  GXSmartSlock
//
//  Created by zkey on 8/27/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXChangeDeviceNicknameModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_SERVER_INTERFACE.h"

#import "GXChangeDeviceNicknameParam.h"
#import "GXDefaultHttpHelper.h"
#import "GXDatabaseHelper.h"

@implementation GXChangeDeviceNicknameModel

- (void)changeDeviceName:(NSString *)deviceIdentifire deviceNickname:(NSString *)nickname
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    GXChangeDeviceNicknameParam *param = [GXChangeDeviceNicknameParam paramWithUserName:userName password:password deviceIdentifire:deviceIdentifire newDeviceNickname:nickname];
    
    [GXDefaultHttpHelper postWithChangeDeviceNicknameParam:param success:^(NSDictionary *result) {
        
        NSInteger status = [[result objectForKey:CHANGE_DEVICE_NICKNAME_STATUS] integerValue];
        if (status == 0) {
            [self.delegate changeDeviceNicknameSuccess:NO];
        } else if (status == 1) {
            [GXDatabaseHelper changeDeviceNickname:deviceIdentifire deviceNickname:nickname];
            [self.delegate changeDeviceNicknameSuccess:YES];
        } else if (status == 3) {
            [self.delegate deviceHasBeenDeleted];
        } else {
            NSLog(@"change device nickname invalid status:%ld", (long)status);
        }
        
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
    
}

@end
