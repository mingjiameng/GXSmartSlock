//
//  GXSynchronizeDeviceUserModel.m
//  GXSmartSlock
//
//  Created by zkey on 9/2/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSynchronizeDeviceUserModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_SERVER_INTERFACE.h"

#import "GXSynchronizeDeviceUserParam.h"
#import "GXServerDataAnalyst.h"
#import "GXDefaultHttpHelper.h"

@implementation GXSynchronizeDeviceUserModel

- (void)synchronizeDeviceUser:(NSString *)deviceIdentifire
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    GXSynchronizeDeviceUserParam *param = [GXSynchronizeDeviceUserParam paramWithUserName:userName password:password deviceIdentifire:deviceIdentifire];
    [GXDefaultHttpHelper postWithSynchronizeDeviceUserParam:param success:^(NSDictionary *result) {
        
        NSInteger status = [[result objectForKey:SYNCHRONIZE_DEVICE_USER_STATUS] integerValue];
        if (status == 0) {
            [self.delegate synchronizeDeviceUserSuccessful:NO];
        } else if (status == 1) {
            NSArray *userArray = [result objectForKey:LOGIN_USER_LIST];
            [GXServerDataAnalyst insertUserIntoDatabase:userArray];
            
            NSArray *mappingArray = [result objectForKey:LOGIN_USER_DEVICE_MAPPING];
            [GXServerDataAnalyst insertDeviceUserMappingItemIntoDatabase:mappingArray];
            
            [self.delegate synchronizeDeviceUserSuccessful:YES];
        } else {
            [self.delegate noNetwork];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
}

@end
