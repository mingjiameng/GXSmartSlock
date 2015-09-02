//
//  GXDeleteAuthorizedUserModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/2/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXDeleteAuthorizedUserModelDelegate <NSObject>
@required
- (void)noNetwork;
- (void)deleteAuthorizedUserSuccessful:(BOOL)successful;
- (void)userHadBeenDeleted;

@end

@interface GXDeleteAuthorizedUserModel : NSObject

@property (nonatomic, weak) id<GXDeleteAuthorizedUserModelDelegate> delegate;

- (void)deleteUser:(NSString *)deletedUserName fromDevice:(NSString *)deviceIdentifire;

@end
