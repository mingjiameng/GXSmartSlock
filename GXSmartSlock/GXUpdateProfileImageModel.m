//
//  GXUpdateProfileImageModel.m
//  GXSmartSlock
//
//  Created by zkey on 8/31/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXUpdateProfileImageModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_SERVER_INTERFACE.h"

#import "GXUpdateProfileImageParam.h"
#import "GXDefaultHttpHelper.h"

@implementation GXUpdateProfileImageModel

- (void)updateProfileWithImageData:(NSData *)imageData
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    NSString *imageString = [imageData base64EncodedStringWithOptions:0];
    
    GXUpdateProfileImageParam *param = [GXUpdateProfileImageParam paramWithUserName:userName password:password imageString:imageString];
    [GXDefaultHttpHelper postwithUpdateProfileImageParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:UPDATE_PROFILE_IMAGE_STATUS] integerValue];
        if (status == 0) {
            [self.delegate updateProfileImageSuccessful:NO];
        } else if (status == 1) {
            [self.delegate updateProfileImageSuccessful:YES];
        } else {
            [self.delegate updateProfileImageSuccessful:NO];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
}

@end
