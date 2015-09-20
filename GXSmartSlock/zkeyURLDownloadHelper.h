//
//  zkeyURLDownloadHelper.h
//  ShengCiBen_Alpha
//
//  Created by Zkey on 15-4-11.
//  Copyright (c) 2015年 overcode. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTTP_METHOD) {
    HTTP_METHOD_GET = 10,
    HTTP_METHOD_POST = 20
};

@interface zkeyURLDownloadHelper : NSObject

// 使用get/post
@property (nonatomic) HTTP_METHOD httpMethod;

// post时的参数字典
@property (nonatomic, strong) NSDictionary *paramDic;

@property (nonatomic, strong) NSString *contentType;

//下载的远程url(连接到服务器的路径)
@property (nonatomic, strong) NSString *urlString;

//下载后的存储路径（文件下载到什么地方）
@property (nonatomic, strong) NSString *destinationPath;

//是否正在下载(只有下载器内部清楚)
@property(nonatomic,readonly,getter = isDownloading)BOOL downloading;

//用来监听下载进度
@property(nonatomic,copy)void (^progressHandler)(double progress);

//用来监听下载完成
@property(nonatomic,copy)void (^completionHandler)();

//用来监听下载错误
@property(nonatomic,copy)void(^failureHandler)(NSError *error);

-(void)start;
-(void)stop;

@end
