//
//  GXSynchronizeUnlockRecordModel.m
//  GXSmartSlock
//
//  Created by zkey on 9/7/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSynchronizeUnlockRecordModel.h"

#import "MICRO_COMMON.h"

#import "GXSynchronizeUnlockRecordParam.h"
#import "GXDefaultHttpHelper.h"

@implementation GXSynchronizeUnlockRecordModel

- (void)synchronizeUnlockRecord
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    GXSynchronizeUnlockRecordParam *param = [GXSynchronizeUnlockRecordParam paramWithUserName:userName password:password];
    [GXDefaultHttpHelper postWithSynchronizeUnlockRecordParam:param success:^(NSDictionary *result) {
        
    } failure:^(NSError *error) {
        
    }];
}

@end
