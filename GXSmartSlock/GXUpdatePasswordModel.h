//
//  GXUpdatePasswordModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/1/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXUpdatePasswordModelDelegate <NSObject>
@required
- (void)noNetwork;
- (void)updatePasswordSuccessful:(BOOL)successful;

@end

@interface GXUpdatePasswordModel : NSObject

@property (nonatomic, weak) id<GXUpdatePasswordModelDelegate> delegate;

- (void)updatePassword:(NSString *)nPassword;

@end
