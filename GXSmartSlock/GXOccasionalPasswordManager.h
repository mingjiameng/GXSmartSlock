//
//  GXOccasionalPasswordManager.h
//  GXBLESmartHomeFurnishing
//
//  Created by wjq on 15-1-15.
//  Copyright (c) 2015年 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GXOccasionalPasswordManager;
@protocol GXOccasionalPwdDelegate <NSObject>

- (void)addOccasionalPassword:(GXOccasionalPasswordManager *)occasionPassword password:(NSString *)password password_used:(BOOL)passwordUsed cout:(NSInteger)passwordCount;
- (void)addOccasionalPassword:(GXOccasionalPasswordManager *)occasionPassword  count:(NSInteger)passwordCount;

@end

@interface GXOccasionalPasswordManager : NSObject

@property (nonatomic, weak) id<GXOccasionalPwdDelegate> delegate;
@property (nonatomic, copy) NSString *currentDeviceName;

- (id)initWithCurrentDeviceName:(NSString *)currentDeviceName;
- (void)disconnect;

- (void)syncOccasionalPassword;
- (void)getOccasionalPassword;
@end
