//
//  GXFirewareNewVersionDownloadModel.m
//  GXSmartSlock
//
//  Created by zkey on 9/17/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXFirewareNewVersionDownloadModel.h"

#import "MICRO_COMMON.h"
#import "MICRO_HTTP.h"

#import "AFNetworking.h"
#import "zkeyURLDownloadHelper.h"
#import "zkeySandboxHelper.h"
#import "GXDatabaseHelper.h"

@interface GXFirewareNewVersionDownloadModel ()
{
    NSInteger _lastVersion;
}
@end


@implementation GXFirewareNewVersionDownloadModel
- (void)checkNewVersion
{
    [self.delegate beginCheckNewVersion];
    
    NSString *urlString = [NSString stringWithFormat:@"%@fw_version?typecode=%@",GXBaseURL, self.deviceCategory];
    AFHTTPRequestOperationManager * requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GXBaseURL]];
    
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [AFHTTPRequestOperationManager manager].securityPolicy = securityPolicy;
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    securityPolicy.validatesCertificateChain = NO;
    requestOperationManager.securityPolicy = securityPolicy;
    
    id __weak weakDelegate = self.delegate;
    GXFirewareNewVersionDownloadModel *__weak weakSelf = self;
    __block NSInteger newVersion = -1;
    [requestOperationManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)operation.responseObject;
        NSLog(@"result:%@", result);
        newVersion = [[result objectForKey:@"fw_version"] integerValue];
        weakSelf.latestVersion = newVersion;
        if (newVersion <= self.currentVersion) {
            [weakDelegate firewareUpdateNeeded:NO];
        } else {
            if (newVersion <= self.downloadedVersion && [zkeySandboxHelper fileExitAtPath:[self firewareFilePath]]) {
                [weakDelegate newVersionDownloadNeeded:NO];
            } else {
                [weakDelegate newVersionDownloadNeeded:YES];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakDelegate noNetwork];
    }];
}

- (void)downloadNewVersion
{
    NSString *filePath = [self firewareFilePath];
    
//    if ([zkeySandboxHelper fileExitAtPath:filePath]) {
//        NSData *data = [NSData dataWithContentsOfFile:filePath];
//        NSLog(@"file length:%ld", (long)data.length);
//        return;
//    }
    
    [zkeySandboxHelper deleteFileAtPath:filePath];
    
    id __weak weakDelegate = self.delegate;;
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    
    zkeyURLDownloadHelper *downloader = [[zkeyURLDownloadHelper alloc] init];
    downloader.urlString = [NSString stringWithFormat:@"%@source_file?", GXBaseURL_HTTP];
    downloader.destinationPath = filePath;
    downloader.httpMethod = HTTP_METHOD_POST;
    downloader.paramDic = @{@"username" : userName,
                            @"password" : password,
                            @"typecode" : self.deviceCategory,
                            @"current" : @(self.currentVersion),
                            @"latest" : @(self.latestVersion)};
    //downloader.contentType = @"application/x-download";
    
    
    //NSLog(@"download param dic:%@", downloader.paramDic);
    
    
    downloader.progressHandler = ^(double progress) {
        [weakDelegate newVersionDownloadProgress:progress];
    };
    
    downloader.completionHandler = ^{
        [weakDelegate newVersionDownloadComplete];
        [GXDatabaseHelper updateDonwloadedFirewareVersion:self.latestVersion ofDevice:self.deviceIdentifire];
    };
    
    downloader.failureHandler = ^(NSError *error){
        [weakDelegate newVersionDownloadFailed];
    };
    
    [self.delegate beginDownloadNewVersion];
    [downloader start];
}

- (NSString *)firewareFilePath
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.bin", [zkeySandboxHelper pathOfDocuments], self.deviceIdentifire];
    
    return filePath;
}

@end
