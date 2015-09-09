//
//  GXManulUnlockModel.h
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 6/17/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GXUnlockModelDelegate.h"

@interface GXManulUnlockModel : NSObject

@property (nonatomic, weak) id<GXUnlockModelDelegate> delegate;

- (void)startScan;
- (void)stopScan;

@end
