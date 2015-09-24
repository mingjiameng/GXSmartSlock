//
//  zkeyShareContentToWeiXin.m
//  FenHongForIOS
//
//  Created by zkey on 7/3/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "zkeyShareContentToWeiXin.h"
#import <UIKit/UIKit.h>

@implementation zkeyShareContentToWeiXin

+ (void)shareWebLinkToWXWith:(NSString *)title description:(NSString *)description webLink:(NSString *)link leftImage:(UIImage *)image scene:(enum WXScene)scene
{
    // messageObj
    WXMediaMessage *webMessage = [WXMediaMessage message];
    webMessage.title = title;
    webMessage.description = description;
    [webMessage setThumbImage:image];
    
    // media of messageObj
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = link;
    webMessage.mediaObject = webObj;
    
    // send request
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = webMessage;
    req.bText = NO;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

+ (void)shareTextToWX:(NSString *)text scene:(enum WXScene)scene
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = text;
    req.bText = YES;
    req.scene = scene;
    
    [WXApi sendReq:req];
}


+ (BOOL)isWeiXinShareAvailable
{
    return ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]);
}

@end
