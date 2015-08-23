//
//  GXHttpTool.h
//  FenHongForIOS
//
//  Created by zkey on 6/8/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXHttpTool : NSObject

typedef void(^HttpSuccess)(NSDictionary *result);
typedef void(^HttpFailure)(NSError *error);

+(void)postWithServerURL:(NSString *)urlString params:(NSDictionary *)params success:(HttpSuccess)success failure:(HttpFailure)failure;

@end
