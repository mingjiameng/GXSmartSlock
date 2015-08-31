//
//  zkeyWebImageCache.m
//  FenHongForIOS
//
//  Created by zkey on 7/30/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "zkeyWebImageCache.h"



@interface zkeyWebImageCache ()
{
    dispatch_queue_t _ioQueue;
    NSCache *_memoryCache;
    NSFileManager *_fileManager;
    NSString *_cacheDirectory;
}
@end

@implementation zkeyWebImageCache

+ (zkeyWebImageCache *)sharedCache
{
    static zkeyWebImageCache *imageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[zkeyWebImageCache alloc] init];
    });
    
    return imageCache;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _ioQueue = dispatch_queue_create("com.overcode.zkey", DISPATCH_QUEUE_SERIAL);
        
        _memoryCache = [[NSCache alloc] init];
        _memoryCache.name = @"image_cache";
        
        _fileManager = [NSFileManager defaultManager];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _cacheDirectory = [paths objectAtIndex:0];
    }
    
    return self;
}


- (void)cacheImageToMemory:(UIImage *)image forKey:(NSString *)key
{
    if (image != nil && key != nil) {
        [_memoryCache setObject:image forKey:key];
    }
}

- (UIImage *)getImageFromMemoryForKey:(NSString *)key
{
    return [_memoryCache objectForKey:key];
}

- (void)cacheImageToFile:(UIImage *)image forKey:(NSString *)key
{
    if (image == nil || key == nil) {
        return;
    }
    
    dispatch_async(_ioQueue, ^{
        // 从URL中分离出文件名
        NSRange range = [key rangeOfString:@"/" options:NSBackwardsSearch];
        
        NSString *filename = nil;
        if (range.length == 0) {
            filename = key;
        } else {
            filename = [key substringFromIndex:range.location+1];
        }
        
        // 从URL中分离出文件类型
        NSString *extension = [[key substringFromIndex:(key.length - 3)] lowercaseString];
        NSString *imageType = @"jpg";
        
        if ([extension isEqualToString:@"jpg"]) {
            imageType = @"jpg";
        } else if ([extension isEqualToString:@"png"]) {
            imageType = @"png";
        }
        
        NSString *filepath = [_cacheDirectory stringByAppendingPathComponent:filename];
        NSData *data = nil;
        
        if ([imageType isEqualToString:@"jpg"]) {
            data = UIImageJPEGRepresentation(image, 1.0);
        }else{
            data = UIImagePNGRepresentation(image);
        }
        
        if (data) {
            [data writeToFile:filepath atomically:YES];
        }
    });
}

- (UIImage *)getImageFromFileForKey:(NSString *)key
{
    if (key == nil) {
        return nil;
    }
    
    NSRange range = [key rangeOfString:@"/" options:NSBackwardsSearch];
    
    NSString *filename = nil;
    if (range.length == 0) {
        filename = key;
    } else {
        filename = [key substringFromIndex:range.location+1];
    }
    
    NSString *filepath = [_cacheDirectory stringByAppendingPathComponent:filename];
    
    if ([_fileManager fileExistsAtPath:filepath]) {
        UIImage *image = [UIImage imageWithContentsOfFile:filepath];
        return image;
    }
    
    return nil;
}

@end
