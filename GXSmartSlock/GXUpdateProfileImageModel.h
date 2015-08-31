//
//  GXUpdateProfileImageModel.h
//  GXSmartSlock
//
//  Created by zkey on 8/31/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXUpdateProfileImageModelDelegate <NSObject>
@required
- (void)updateProfileImageSuccessful:(BOOL)successful;

@optional
- (void)noNetwork;


@end

@interface GXUpdateProfileImageModel : NSObject

@property (nonatomic, weak) id<GXUpdateProfileImageModelDelegate> delegate;

- (void)updateProfileWithImageData:(NSData *)imageData;

@end
