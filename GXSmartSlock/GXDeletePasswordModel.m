//
//  GXDeletePasswordModel.m
//  GXSmartSlock
//
//  Created by zkey on 10/20/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXDeletePasswordModel.h"

#import "GXDeletePasswordParam.h"
#import "GXDefaultHttpHelper.h"

@implementation GXDeletePasswordModel

+ (void)deletePassword:(NSInteger)passwordID ofDevice:(NSString *)deviceIdentifire byApproach:(NSString *)approach
{
    NSString *accessToken = nil;
    
    GXDeletePasswordParam *param = [GXDeletePasswordParam paramWithAccessToken:accessToken deviceID:deviceIdentifire passwordID:passwordID operationType:approach];
    [GXDefaultHttpHelper postWithDeletePasswordParam:param success:^(NSDictionary *result) {
        
    } failure:^(NSError *error) {
        
    }];
}

@end
