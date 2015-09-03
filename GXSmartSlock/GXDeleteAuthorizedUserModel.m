//
//  GXDeleteAuthorizedUserModel.m
//  GXSmartSlock
//
//  Created by zkey on 9/2/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXDeleteAuthorizedUserModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_SERVER_INTERFACE.h"

#import "GXDeleteAuthorizedUserParam.h"
#import "GXDefaultHttpHelper.h"
#import "GXDatabaseHelper.h"

@implementation GXDeleteAuthorizedUserModel

- (void)deleteUser:(NSString *)deletedUserName fromDevice:(NSString *)deviceIdentifire
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    GXDeleteAuthorizedUserParam *param = [GXDeleteAuthorizedUserParam paramWithUserName:userName password:password deviceIdentifire:deviceIdentifire deletedUserName:deletedUserName];
    [GXDefaultHttpHelper postWithDeleteAuthorizedUserParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:DELETE_DEVICE_STATUS] integerValue];
        if (status == 0) {
            [self.delegate deleteAuthorizedUserSuccessful:NO];
        } else if (status == 1) {
            [self.delegate deleteAuthorizedUserSuccessful:YES];
            [GXDatabaseHelper deleteUser:deletedUserName fromDevice:deviceIdentifire];
        } else if (status == 3) {
            [self.delegate userHadBeenDeleted];
            [GXDatabaseHelper deleteUser:deletedUserName fromDevice:deviceIdentifire];
        } else {
            [self.delegate deleteAuthorizedUserSuccessful:NO];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
    
}

@end
