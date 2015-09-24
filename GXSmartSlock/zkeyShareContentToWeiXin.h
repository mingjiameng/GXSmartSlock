//
//  zkeyShareContentToWeiXin.h
//  FenHongForIOS
//
//  Created by zkey on 7/3/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"

@interface zkeyShareContentToWeiXin : NSObject

+ (BOOL)isWeiXinShareAvailable;
+ (void)shareWebLinkToWXWith:(NSString *)title description:(NSString *)description webLink:(NSString *)link leftImage:(UIImage *)image scene:(enum WXScene)scene;
+ (void)shareTextToWX:(NSString *)text scene:(enum WXScene)scene;

@end
