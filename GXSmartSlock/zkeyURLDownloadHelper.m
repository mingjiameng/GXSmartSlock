//
//  zkeyURLDownloadHelper.m
//  ShengCiBen_Alpha
//
//  Created by Zkey on 15-4-11.
//  Copyright (c) 2015年 overcode. All rights reserved.
//

#import "zkeyURLDownloadHelper.h"
@interface zkeyURLDownloadHelper() <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSFileHandle *fileWriteHandle;
@property (nonatomic, assign) long long currentLength;
@property (nonatomic, assign) long long totalLength;
@end

@implementation zkeyURLDownloadHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.totalLength = 0;
        self.currentLength = 0;
        self.httpMethod = HTTP_METHOD_GET;
    }
    
    return self;
}

- (void)start
{
    
    // create a request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    
    // set http method
    if (self.httpMethod == HTTP_METHOD_GET) {
        [request setHTTPMethod:@"GET"];
    } else {
        [request setHTTPMethod:@"POST"];
        
        // set http body - param list
        [request setHTTPBody:[self httpBodyWithParamDictionary:self.paramDic]];
    }
    
    // set request header information
    
    // reread from self.currentLength;
    NSString *value = [NSString stringWithFormat:@"bytes=%lld-", self.currentLength];
    [request setValue:value forHTTPHeaderField:@"Range"];
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    _downloading = YES;
}

- (void)stop
{
    _downloading = NO;
    
    [self.connection cancel];
    self.connection = nil;
}

- (NSData *)httpBodyWithParamDictionary:(NSDictionary *)paramDic
{
    if (paramDic == nil) {
        return [@"" dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSString *bodyString = @"";
    for (NSString *key in [paramDic allKeys]) {
        bodyString = [bodyString stringByAppendingFormat:@"%@=%@&", key, [paramDic objectForKey:key]];
    }
    
    if (bodyString.length > 1) {
        bodyString = [bodyString substringToIndex:(bodyString.length - 1)];
    }
    
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    return bodyData;
}

#pragma mark - URL connection delegate
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // is the first connection
    if (self.totalLength) return;
    
    //NSLog(@"recieve response");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:self.destinationPath contents:nil attributes:nil];
    self.fileWriteHandle = [NSFileHandle fileHandleForWritingAtPath:self.destinationPath];
    self.totalLength = response.expectedContentLength;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // update download progress
    self.currentLength += data.length;
    double progress = (double)self.currentLength / self.totalLength;
    if (self.progressHandler) {
        self.progressHandler(progress);
    }
    //相当于在此处调用了下面的代码
    //        ^(double progress)
    //        {
    //            //把进度的值，传递到控制器中进度条，以进行显示
    //            vc.progress.progress=progress;
    //        };
    
    // write data to file
    [self.fileWriteHandle seekToEndOfFile];
    [self.fileWriteHandle writeData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"download completed with file length:%ld", self.totalLength);
    // close fileHandle
    [self.fileWriteHandle closeFile];
    self.fileWriteHandle = nil;
    
    self.currentLength = 0;
    self.totalLength = 0;
    
    if (self.completionHandler) {
        self.completionHandler();
    }
    //相当于下面的代码
    //        ^{
    //            NSLog(@"下载完成");
    //            [self.btn setTitle:@"下载已经完成" forState:UIControlStateNormal];
    //        }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.failureHandler) {
        self.failureHandler(error);
        //相当于调用了下面的代码
        //        ^{
        //            NSLog(@"下载错误！");
        //        }
    }
}

@end
