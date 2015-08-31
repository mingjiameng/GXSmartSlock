//
//  GXUpdateNicknameModel.h
//  GXSmartSlock
//
//  Created by zkey on 8/31/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXUpdateNicknameModelDelegate <NSObject>
@required
- (void)updateNicknameSuccessful:(BOOL)successful;
- (void)noNetwork;

@end


@interface GXUpdateNicknameModel : NSObject

@property (nonatomic, weak) id<GXUpdateNicknameModelDelegate> delegate;

- (void)updateNickname:(NSString *)nickname;

@end
