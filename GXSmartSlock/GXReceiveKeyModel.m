//
//  GXReceiveKeyModel.m
//  GXSmartSlock
//
//  Created by zkey on 9/4/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXReceiveKeyModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_SERVER_INTERFACE.h"

#import "GXReceiveKeyParam.h"
#import "GXSynchronizeDeviceParam.h"
#import "GXDefaultHttpHelper.h"
#import "GXServerDataAnalyst.h"
#import "GXDatabaseHelper.h"

@implementation GXReceiveKeyModel

- (void)receiveKey:(NSString *)deviceIdentifire deviceNickname:(NSString *)nickname
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];

    typeof(self) __weak weakSelf = self;
    
    GXReceiveKeyParam *param = [GXReceiveKeyParam paramWithUserName:userName password:password deviceNickname:nickname forDevice:deviceIdentifire];
    [GXDefaultHttpHelper postWithReceiveKeyParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:REJECT_KEY_STATUS] integerValue];
        if (status == 0) {
            [self.delegate receiveKeySuccessful:NO];
        } else if (status == 1) {
            [weakSelf synchronizeDevice];
        } else if (status == 3) {
            [self.delegate deviceHadBeenDelete];
            [GXDatabaseHelper deleteDeviceWithIdentifire:deviceIdentifire];
        } else {
            [self.delegate receiveKeySuccessful:NO];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
}

- (void)synchronizeDevice
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    GXSynchronizeDeviceParam *param = [GXSynchronizeDeviceParam paramWithUserName:userName password:password];
    [GXDefaultHttpHelper postWithSynchronizeDeviceParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:SYNCHRONIZE_DEVICE_STATUS] integerValue];
        if (status == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *userArray = [result objectForKey:SYNCHRONIZE_DEVICE_USER];
                [GXServerDataAnalyst insertUserIntoDatabase:userArray];
                
                NSArray *deviceArray = [result objectForKey:SYNCHRONIZE_DEVICE_DEVICE];
                [GXServerDataAnalyst insertDeviceIntoDatabase:deviceArray];
                
                NSArray *deviceUserMappingArray = [result objectForKey:SYNCHRONIZE_DEVICE_MAPPING];
                [GXServerDataAnalyst insertDeviceUserMappingItemIntoDatabase:deviceUserMappingArray];
            });
            
            [self.delegate receiveKeySuccessful:YES];
        }
    } failure:^(NSError *error) {
        
        [self.delegate receiveKeySuccessful:YES];
    }];
    
    
}


@end
