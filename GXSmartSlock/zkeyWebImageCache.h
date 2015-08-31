//
//  zkeyWebImageCache.h
//  FenHongForIOS
//
//  Created by zkey on 7/30/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface zkeyWebImageCache : NSObject

+ (zkeyWebImageCache *)sharedCache;
- (void)cacheImageToMemory:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)getImageFromMemoryForKey:(NSString *)key;
- (UIImage *)getImageFromFileForKey:(NSString *)key;
- (void)cacheImageToFile:(UIImage *)image forKey:(NSString *)key;

@end
