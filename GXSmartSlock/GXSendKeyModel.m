//
//  GXSendKeyModel.m
//  GXSmartSlock
//
//  Created by zkey on 9/6/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSendKeyModel.h"

#import "MICRO_COMMON.h"

#import "GXContactModel.h"
#import "GXSendKeyParam.h"
#import "GXDefaultHttpHelper.h"

@implementation GXSendKeyModel

+ (NSArray *)sendKey:(NSString *)deviceIdentifire to:(NSArray *)contactModelArray withAuthority:(NSString *)authorityType
{
    __block NSMutableArray *failedContactModelArray = [NSMutableArray array];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    for (GXContactModel *contactModel in contactModelArray) {
        GXSendKeyParam *param = [GXSendKeyParam paramWithUserName:userName password:password deviceIdentifire:deviceIdentifire receiverUserName:contactModel.phoneNumber authorityType:authorityType];
        [GXDefaultHttpHelper postWithSendKeyParam:param success:^(NSDictionary *result) {
            NSInteger status = [[result objectForKey:@"status"] integerValue];
            if (status == 0) {
                [failedContactModelArray addObject:contactModel];
            }
        } failure:^(NSError *error) {
            [failedContactModelArray addObject:contactModel];
        }];
    }
    
    return failedContactModelArray;
}

@end
