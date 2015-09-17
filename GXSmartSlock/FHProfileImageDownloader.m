//
//  FHProfileImageDownloader.m
//  FenHongForIOS
//
//  Created by zkey on 8/17/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "FHProfileImageDownloader.h"

#import "zkeyWebImageCache.h"

@interface FHProfileImageDownloader ()

@end



@implementation FHProfileImageDownloader

+ (FHProfileImageDownloader *)shareImageDownloader
{
    static FHProfileImageDownloader *profileImageDownloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        profileImageDownloader = [[FHProfileImageDownloader alloc] init];
    });
    
    return profileImageDownloader;
}

- (void)downloadImageWithUrlString:(NSString *)imageUrlString complete:(ImageDownloadedBlock)completeBlock
{
    if (imageUrlString == nil) {
        if (completeBlock) {
            completeBlock(nil, nil, imageUrlString);
        }
        
        return;
    }
    
    zkeyWebImageCache *imageCache = [zkeyWebImageCache sharedCache];
    UIImage *image = [imageCache getImageFromMemoryForKey:imageUrlString];
    
    if (image != nil) {
        if (completeBlock) {
            completeBlock(image, nil, imageUrlString);
        }
    }
    
    if (image == nil) {
        image = [imageCache getImageFromFileForKey:imageUrlString];
        if (image != nil) {
            if (completeBlock) {
                completeBlock(image, nil, imageUrlString);
            }
        }
    }
    
    // 用户的头像随时可能发生变化
    // 因此不管本地是否有用户头像的数据，都要进行下载和更新
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *realUrlString = [imageUrlString substringToIndex:(imageUrlString.length - 4)];
        NSURL *imageURL = [NSURL URLWithString:realUrlString];
        
        NSError *error = nil;
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL options:NSDataReadingMappedIfSafe error:&error];
        
        
        if (imageData == nil || imageData.length < 25) {
            // for that server may return client a string with 0 lenght
            // we have reason to assume that user does not set profile image if the length of return data if shorter than 25
            return;
        }
        
        
        imageData = [[NSData alloc] initWithBase64EncodedData:imageData options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil) {
                if (completeBlock) {
                    completeBlock(nil, error, imageUrlString);
                }
                
                return;
            }
            
            if (imageData == nil) {
                return;
            }
            
            UIImage *image = [UIImage imageWithData:imageData];
            if (image == nil) {
                return;
            }
            
            [imageCache cacheImageToMemory:image forKey:imageUrlString];
            [imageCache cacheImageToFile:image forKey:imageUrlString];
            
            if (completeBlock) {
                completeBlock(image, nil, imageUrlString);
            }
        });
        
    });
    
}


@end
