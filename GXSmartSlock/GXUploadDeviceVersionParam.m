//
//  GXUploadDeviceVersionParam.m
//  GXSmartSlock
//
//  Created by zkey on 9/22/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXUploadDeviceVersionParam.h"

@implementation GXUploadDeviceVersionParam

+ (GXUploadDeviceVersionParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire deviceVersion:(NSInteger)deviceVersion
{
    GXUploadDeviceVersionParam *param = [[GXUploadDeviceVersionParam alloc] init];
    
    param.userName = userName;
    param.password = password;
    param.deviceIdentifire = deviceIdentifire;
    param.deviceVersion = [NSString stringWithFormat:@"%ld", deviceVersion];
    
    return param;
}

@end
