//
//  GXSynchronizeUnlockRecordModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/7/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXSynchronizeUnlockRecordModelDelegate <NSObject>
@required
- (void)noNetwork;
- (void)synchronizeRecordSuccessful:(BOOL)successful;

@end

@interface GXSynchronizeUnlockRecordModel : NSObject

@end
