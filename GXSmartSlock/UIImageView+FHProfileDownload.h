//
//  UIImageView+FHProfileDownload.h
//  FenHongForIOS
//
//  Created by zkey on 8/17/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (FHProfileDownload)

@property NSString *tag;

- (void)setProfileWithUrlString:(NSString *)imageUrlString placeholderImage:(UIImage *)placeholderImage;

@end
