//
//  GXRejectKeyModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/4/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXRejectKeyModelDelegate <NSObject>
@required
- (void)noNetwork;
- (void)rejectKeySuccessful:(BOOL)successful;
- (void)deviceHadBeenDelete;

@end

@interface GXRejectKeyModel : NSObject

@property (nonatomic, weak) id<GXRejectKeyModelDelegate> delegate;

- (void)rejectKey:(NSString *)deviceIdentifire;

@end
