//
//  GXUploadDeviceVersionParam.h
//  GXSmartSlock
//
//  Created by zkey on 9/22/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXUploadDeviceVersionParam : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *deviceIdentifire;
@property (nonatomic, strong) NSString *deviceVersion;

+ (GXUploadDeviceVersionParam *)paramWithUserName:(NSString *)userName password:(NSString *)password deviceIdentifire:(NSString *)deviceIdentifire deviceVersion:(NSInteger)deviceVersion;

@end
