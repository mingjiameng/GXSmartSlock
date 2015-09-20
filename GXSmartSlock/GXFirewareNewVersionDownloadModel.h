//
//  GXFirewareNewVersionDownloadModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/17/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXFirewareNewVersionDownloadModelDelegate <NSObject>
@required
- (void)noNetwork;
- (void)beginCheckNewVersion;
- (void)firewareUpdateNeeded:(BOOL)needed;
- (void)newVersionDownloadNeeded:(BOOL)needed;
- (void)beginDownloadNewVersion;
- (void)newVersionDownloadProgress:(double)progress;
- (void)newVersionDownloadComplete;
- (void)newVersionDownloadFailed;

@end


@interface GXFirewareNewVersionDownloadModel : NSObject

@property (nonatomic, copy) NSString *deviceIdentifire;
@property (nonatomic) NSInteger currentVersion;
@property (nonatomic) NSInteger downloadedVersion;
@property (nonatomic, copy) NSString *deviceCategory;
@property (nonatomic) NSInteger latestVersion;

@property (nonatomic, weak) id<GXFirewareNewVersionDownloadModelDelegate> delegate;

- (void)checkNewVersion;

// 下载新版本固件
- (void)downloadNewVersion;


@end
