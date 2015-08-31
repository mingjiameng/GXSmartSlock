//
//  UIImageView+FHProfileDownload.m
//  FenHongForIOS
//
//  Created by zkey on 8/17/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "UIImageView+FHProfileDownload.h"

#import "FHProfileImageDownloader.h"

@implementation UIImageView (FHProfileDownload)

- (void)setProfileWithUrlString:(NSString *)imageUrlString placeholderImage:(UIImage *)placeholderImage
{
    self.image = placeholderImage;
    
    if (imageUrlString == nil) {
        return;
    }
    
    self.tag = imageUrlString;
    
    FHProfileImageDownloader *profileImageDownloader = [FHProfileImageDownloader shareImageDownloader];
    
    [profileImageDownloader downloadImageWithUrlString:imageUrlString complete:^(UIImage *image, NSError *error, NSString *imageUrlString) {
        if (error != nil) {
            NSLog(@"image download error: %@, %@", error, [error userInfo]);
            //self.image = [UIImage imageNamed:@"imageFailedToLoad"];
            return;
        }
        
        // 通过设置imageTag保证图片不错位
        if (image != nil && [self.tag isEqualToString:imageUrlString]) {
            self.image = image;
        }
        
    }];
}

@end
