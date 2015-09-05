//
//  GXReceiveKeyModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/4/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXReceiveKeyModelDelegate <NSObject>
@required
- (void)noNetwork;
- (void)receiveKeySuccessful:(BOOL)successful;
- (void)deviceHadBeenDelete;

@end

@interface GXReceiveKeyModel : NSObject

@property (nonatomic, weak) id<GXReceiveKeyModelDelegate> delegate;\

- (void)receiveKey:(NSString *)deviceIdentifire deviceNickname:(NSString *)nickname;

@end
