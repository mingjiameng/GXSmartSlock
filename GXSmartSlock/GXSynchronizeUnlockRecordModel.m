//
//  GXSynchronizeUnlockRecordModel.m
//  GXSmartSlock
//
//  Created by zkey on 9/7/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSynchronizeUnlockRecordModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_SERVER_INTERFACE.h"

#import "GXSynchronizeUnlockRecordParam.h"
#import "GXDefaultHttpHelper.h"
#import "GXServerDataAnalyst.h"

@implementation GXSynchronizeUnlockRecordModel

- (void)synchronizeUnlockRecord
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    __block BOOL synchronizeDeviceSuccessful = NO;
    
    GXSynchronizeDeviceParam *paramDevice = [GXSynchronizeDeviceParam paramWithUserName:userName password:password];
    [GXDefaultHttpHelper postWithSynchronizeDeviceParam:paramDevice success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        if (status == 0) {
            [self.delegate synchronizeRecordSuccessful:NO];
        } else if (status == 1) {
            
            NSArray *userArray = [result objectForKey:SYNCHRONIZE_DEVICE_USER];
            [GXServerDataAnalyst insertUserIntoDatabase:userArray];
            
            NSArray *deviceArray = [result objectForKey:SYNCHRONIZE_DEVICE_DEVICE];
            [GXServerDataAnalyst insertDeviceIntoDatabase:deviceArray];
            
            NSArray *deviceUserMappingArray = [result objectForKey:SYNCHRONIZE_DEVICE_MAPPING];
            [GXServerDataAnalyst insertDeviceUserMappingItemIntoDatabase:deviceUserMappingArray];
            
            synchronizeDeviceSuccessful = YES;
        } else {
            [self.delegate synchronizeRecordSuccessful:NO];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
    
    
    if (!synchronizeDeviceSuccessful) {
        return;
    }
    
    GXSynchronizeUnlockRecordParam *paramRecord = [GXSynchronizeUnlockRecordParam paramWithUserName:userName password:password];
    [GXDefaultHttpHelper postWithSynchronizeUnlockRecordParam:paramRecord success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        if (status== 0) {
            [self.delegate synchronizeRecordSuccessful:NO];
        } else if (status == 1) {
            NSArray *recordArray = [result objectForKey:@"records"];
            [GXServerDataAnalyst insertUnlockRecordIntoDatabase:recordArray];
            
            [self.delegate synchronizeRecordSuccessful:YES];
        } else {
            [self.delegate synchronizeRecordSuccessful:NO];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
}

@end
