//
//  GXDeletePasswordParam.h
//  GXSmartSlock
//
//  Created by zkey on 10/20/15.
//  Copyright © 2015 guosim. All rights reserved.
//

// from version 2.4.1, all kinds of password are abstracted into one password model

#import <Foundation/Foundation.h>

@interface GXDeletePasswordParam : NSObject

@property (nonatomic, strong, nonnull) NSString *accessToken;
@property (nonatomic, strong, nonnull) NSString *deviceIdentifire;
@property (nonatomic, strong, nonnull) NSString *passwordIdString;
@property (nonatomic, strong, nonnull) NSString *operationType;

+ (nonnull GXDeletePasswordParam*)paramWithAccessToken:(nonnull NSString*)accessToken deviceID:(nonnull NSString *)deviceIdentifire passwordID:(NSInteger)passwordID operationType:(nonnull NSString *)operationType;

@end
