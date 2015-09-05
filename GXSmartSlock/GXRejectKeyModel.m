//
//  GXRejectKeyModel.m
//  GXSmartSlock
//
//  Created by zkey on 9/4/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXRejectKeyModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_SERVER_INTERFACE.h"

#import "GXRejectKeyParam.h"
#import "GXDefaultHttpHelper.h"
#import "GXDatabaseHelper.h"

@implementation GXRejectKeyModel

- (void)rejectKey:(NSString *)deviceIdentifire
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    GXRejectKeyParam *param = [GXRejectKeyParam paramWithUserName:userName password:password deviceIdentifire:deviceIdentifire];
    [GXDefaultHttpHelper postWithRejectKeyParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:REJECT_KEY_STATUS] integerValue];
        if (status == 0) {
            [self.delegate rejectKeySuccessful:NO];
        } else if (status == 1) {
            [GXDatabaseHelper deleteDeviceWithIdentifire:deviceIdentifire];
            [self.delegate rejectKeySuccessful:YES];
        } else if (status == 3) {
            [GXDatabaseHelper deleteDeviceWithIdentifire:deviceIdentifire];
            [self.delegate deviceHadBeenDelete];
        } else {
            [self.delegate rejectKeySuccessful:NO];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
}

@end
