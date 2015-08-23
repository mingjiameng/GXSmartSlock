//
//  GXLoginModel.h
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 7/9/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXLoginModelDelegate <NSObject>
@required
- (void)noNetworkToLogin;
- (void)successfullyLogin;
- (void)wrongUserNameOrPassword;
@end

@interface GXLoginModel : NSObject

@property (nonatomic, weak) id<GXLoginModelDelegate> delegate;

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password;

+ (void)initializeDatabaseWithData:(NSDictionary *)result userName:(NSString *)userName password:(NSString *)password;

@end
