//
//  GXDeletePasswordParam.h
//  GXSmartSlock
//
//  Created by zkey on 10/20/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXDeletePasswordParam : NSObject

@property (nonatomic, strong, nonnull) NSString *accessToken;
@property (nonatomic, strong, nonnull) NSString *deviceIdentifire;
@property (nonatomic, strong, nonnull) NSString *passwordIdString;
@property (nonatomic, strong, nonnull) NSString *operationType;

+ (GXDeletePasswordParam *)paramWithAccessToken:(NSString *)accessToken deviceID:(NSString *)deviceIdentifire passwordID:(NSInteger)passwordID operationType:(NSString *)operationType;

@end
