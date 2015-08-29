//
//  GXDeleteDeviceModel.m
//  GXSmartSlock
//
//  Created by zkey on 8/29/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXDeleteDeviceModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_SERVER_INTERFACE.h"

#import "GXDeleteDeviceParam.h"
#import "GXDefaultHttpHelper.h"
#import "GXDatabaseHelper.h"

@implementation GXDeleteDeviceModel

- (void)deleteDeviceWithIdentifire:(NSString *)deviceIdentifire authorityStatus:(NSString *)deviceAuthority
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    GXDeleteDeviceParam *param = [GXDeleteDeviceParam paramWithUserName:userName password:password deviceIdentifire:deviceIdentifire deviceAuthority:deviceAuthority];
    [GXDefaultHttpHelper postWithDeleteDeviceParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:DELETE_DEVICE_STATUS] integerValue];
        if (status == 0) {
            [self.delegate deleteDeviceSuccessful:NO];
        } else if (status == 1) {
            [self.delegate deleteDeviceSuccessful:YES];
            [GXDatabaseHelper deleteDeviceWithIdentifire:deviceIdentifire];
        } else if (status == 3) {
            [self.delegate deviceHasBeenDeleted];
            [GXDatabaseHelper deleteDeviceWithIdentifire:deviceIdentifire];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
}

@end
