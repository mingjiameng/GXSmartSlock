//
//  GXFirewareNewVersionUpdateModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/17/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXFirewareNewVersionUpdateModelDelegate <NSObject>
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


@interface GXFirewareNewVersionUpdateModel : NSObject

@property (nonatomic, copy) NSString *deviceIdentifire;
@property (nonatomic) NSInteger currentVersion;
@property (nonatomic) NSInteger downloadedVersion;

@property (nonatomic, weak) id<GXFirewareNewVersionUpdateModelDelegate> delegate;

- (instancetype)initWithDeviceIdentifire:(NSString *)deviceIdentifire;

- (void)checkNewVersion;

// 下载新版本固件
- (void)downloadNewVersion;


@end
