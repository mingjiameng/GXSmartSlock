//
//  FHProfileImageDownloader.h
//  FenHongForIOS
//
//  Created by zkey on 8/17/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ImageDownloadedBlock)(UIImage *image, NSError *error, NSString *imageUrlString);

@interface FHProfileImageDownloader : NSObject

+ (FHProfileImageDownloader *)shareImageDownloader;

- (void)downloadImageWithUrlString:(NSString *)imageUrlString complete:(ImageDownloadedBlock)completeBlock;

@end
