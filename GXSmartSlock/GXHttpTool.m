//
//  GXHttpTool.m
//  FenHongForIOS
//
//  Created by zkey on 6/8/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "GXHttpTool.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLConnectionOperation.h"

@implementation GXHttpTool

+(void)postWithServerURL:(NSString *)urlString params:(NSDictionary *)params success:(HttpSuccess)success failure:(HttpFailure)failure
{
    
    NSURL *url = [NSURL URLWithString:urlString];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    securityPolicy.validatesCertificateChain = NO;
    
    manager.securityPolicy = securityPolicy;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
        if (success) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
            //NSLog(@"%@, %@", error, [error userInfo]);
        }
    }];
    
}


@end
