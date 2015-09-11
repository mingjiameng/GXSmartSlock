//
//  GXShakeUnlockModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/11/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GXUnlockModelDelegate.h"

@interface GXShakeUnlockModel : NSObject

@property (nonatomic, weak) id<GXUnlockModelDelegate> delegate;

// temporary not used
- (void)stopScan;

@end
