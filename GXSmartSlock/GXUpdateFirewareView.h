//
//  GXUpdateFirewareView.h
//  GXSmartSlock
//
//  Created by zkey on 9/17/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GXUpdateFirewareViewDelegate <NSObject>

- (void)checkNewVersion;
- (void)downloadNewVersion;
- (void)updateFireware;

@end


@interface GXUpdateFirewareView : UIView

@property (nonatomic, weak) id<GXUpdateFirewareViewDelegate> delegate;

/*
 * action methods for fireware download
 */
- (void)noNetwork;
- (void)beginCheckNewVersion;
- (void)firewareUpdateNeeded:(BOOL)needed;
- (void)newVersionDownloadNeeded:(BOOL)needed;
- (void)beginDownloadNewVersion;
- (void)newVersionDownloadProgress:(double)progress;
- (void)newVersionDownloadComplete;
- (void)newVersionDownloadFailed;

/*
 * action methods for fireware update
 */


- (void)beginScanForCertainDevice;
- (void)beginUpdateFireware;
- (void)firewareUpdateProgress:(double)progress;
- (void)firewareUpdateComplete;
- (void)firewareUpdateFailed;

@end
