//
//  GXFirewareNewVersionUpdateModel.m
//  GXSmartSlock
//
//  Created by zkey on 9/17/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXFirewareNewVersionUpdateModel.h"

#import "AFNetworking.h"
#import "zkeyURLDownloadHelper.h"
#import "zkeySandboxHelper.h"

@interface GXFirewareNewVersionUpdateModel ()
{
    NSInteger _lastVersion;
}
@end

@implementation GXFirewareNewVersionUpdateModel

- (instancetype)initWithDeviceIdentifire:(NSString *)deviceIdentifire
{
    self = [super init];
    
    if (self) {
        self.deviceIdentifire = deviceIdentifire;
    }
    
    return self;
}

- (void)checkNewVersion
{
    [self.delegate beginCheckNewVersion];
    
    AFHTTPRequestOperationManager * requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://115.28.226.149/fw_version"]];
    
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [AFHTTPRequestOperationManager manager].securityPolicy = securityPolicy;
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    securityPolicy.validatesCertificateChain = NO;
    requestOperationManager.securityPolicy = securityPolicy;
    
    id __weak weakDelegate = self.delegate;
    NSInteger __block newVersion = -1;
    [requestOperationManager GET:@"https://115.28.226.149/fw_version" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)operation.responseObject;
        NSLog(@"result:%@", result);
        newVersion = [[result objectForKey:@"fw_version"] integerValue];
        if (newVersion <= self.currentVersion) {
            [weakDelegate firewareUpdateNeeded:NO];
        } else {
            if (newVersion <= self.downloadedVersion) {
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
    NSString *urlString = [NSString stringWithFormat:@"http://115.28.226.149/source_file?latest=%ld&current=%ld", (long)_lastVersion, (long)self.currentVersion];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [zkeySandboxHelper pathOfDocuments], self.deviceIdentifire];
    [zkeySandboxHelper deleteFileAtPath:filePath];
    
    id __weak weakDelegate = self.delegate;;
    
    zkeyURLDownloadHelper *downloader = [[zkeyURLDownloadHelper alloc] init];
    downloader.urlString = urlString;
    downloader.destinationPath = filePath;
    
    downloader.progressHandler = ^(double progress) {
        [weakDelegate newVersionDownloadProgress:progress];
    };
    
    downloader.completionHandler = ^{
        [weakDelegate newVersionDownloadComplete];
    };
    
    downloader.failureHandler = ^(NSError *error){
        [weakDelegate newVersionDownloadFailed];
    };
}

@end
