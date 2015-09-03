//
//  GXSynchronizeDeviceModel.m
//  GXSmartSlock
//
//  Created by zkey on 9/3/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSynchronizeDeviceModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_SERVER_INTERFACE.h"

#import "GXSynchronizeDeviceParam.h"
#import "GXDefaultHttpHelper.h"
#import "GXServerDataAnalyst.h"


@implementation GXSynchronizeDeviceModel

- (void)synchronizeDevice
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    GXSynchronizeDeviceParam *param = [GXSynchronizeDeviceParam paramWithUserName:userName password:password];
    [GXDefaultHttpHelper postWithSynchronizeDeviceParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:SYNCHRONIZE_DEVICE_STATUS] integerValue];
        if (status == 0) {
            [self.delegate synchronizeDeviceSuccessful:NO];
        } else if (status == 1) {
            
            NSArray *userArray = [result objectForKey:SYNCHRONIZE_DEVICE_USER];
            [GXServerDataAnalyst insertUserIntoDatabase:userArray];
            
            NSArray *deviceArray = [result objectForKey:SYNCHRONIZE_DEVICE_DEVICE];
            [GXServerDataAnalyst insertDeviceIntoDatabase:deviceArray];
            
            NSArray *deviceUserMappingArray = [result objectForKey:SYNCHRONIZE_DEVICE_MAPPING];
            [GXServerDataAnalyst insertDeviceUserMappingItemIntoDatabase:deviceUserMappingArray];
            
            [self.delegate synchronizeDeviceSuccessful:YES];
            
        } else {
            [self.delegate synchronizeDeviceSuccessful:NO];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
}

@end
