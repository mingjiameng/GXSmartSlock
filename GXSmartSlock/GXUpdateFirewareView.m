//
//  GXUpdateFirewareView.m
//  GXSmartSlock
//
//  Created by zkey on 9/17/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXUpdateFirewareView.h"

#import "MICRO_COMMON.h"

@interface GXUpdateFirewareView ()
{
    UIImageView *_logoImageView;
    UILabel *_messageLabel;
    UIButton *_actionButton;
    UIProgressView *_progressBar;

    UITextView *_tipsTextView;
    UIImageView *_animationView;
}
@end

@implementation GXUpdateFirewareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // logo imageView
        CGFloat imageSize = frame.size.width / 2.0;
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - imageSize) / 2.0, 30.0f, imageSize, imageSize)];
        _logoImageView.image = [UIImage imageNamed:@"logoForFirewareUpdate@800"];
        [self addSubview:_logoImageView];
        
        // message label
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 40.0f + imageSize, frame.size.width, 21.0f)];
        _messageLabel.textColor = [UIColor lightGrayColor];
        _messageLabel.font = [UIFont systemFontOfSize:15.0f];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.text = @"固件升级过程中请打开蓝牙 保持网络畅通";
        [self addSubview:_messageLabel];
        
        // action button - may be binded with different action
        _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, 80.0f + imageSize, frame.size.width - 40.0f, 40.0f)];
        _actionButton.layer.masksToBounds = YES;
        _actionButton.layer.cornerRadius = DEFAULT_ROUND_RECTANGLE_CORNER_RADIUS;
        _actionButton.layer.borderWidth = 1.0f;
        _actionButton.layer.borderColor = [MAIN_COLOR CGColor];
        [_actionButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [_actionButton setTitle:@"检查固件更新" forState:UIControlStateNormal];
        [_actionButton addTarget:self.delegate action:@selector(checkNewVersion) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_actionButton];
        
        // progress view indicates the data writing/download progress
        _progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(20.0f, 71.0f + imageSize, frame.size.width - 40.0f, 2.0f)];
        _progressBar.progressViewStyle = UIProgressViewStyleDefault;
        _progressBar.progressTintColor = MAIN_COLOR;
        _progressBar.trackTintColor = [UIColor lightGrayColor];
        [_progressBar setHidden:YES];
        [self addSubview:_progressBar];
    }
    
    return self;
}

- (void)addTips:(CGRect)frame
{
    _tipsTextView = [[UITextView alloc] initWithFrame:frame];
    _tipsTextView.text = @"请按下门锁上的设置键并将手机靠近门锁\n在固件升级过程中请保持手机蓝牙打开、电量充足，固件升级可能花费数分钟";
    _tipsTextView.textColor = [UIColor blackColor];
    _tipsTextView.font = [UIFont systemFontOfSize:17.0];
    _tipsTextView.userInteractionEnabled = NO;
    
    [self addSubview:_tipsTextView];
}

- (void)addAnimation:(CGRect)frame
{
    _animationView = [[UIImageView alloc] initWithFrame:frame];
    _animationView.userInteractionEnabled = NO;
    
    NSArray *imageArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AddNewDeviceAnimationImage" ofType:@"plist"]];
    NSMutableArray *images = [NSMutableArray array];
    for (NSString *oneImage in imageArray) {
        [images addObject:[UIImage imageNamed:oneImage]];
    }
    
    _animationView.animationImages = (NSArray *)images;
    _animationView.animationDuration = 0.3 * imageArray.count;
    _animationView.animationRepeatCount = 0;
    [_animationView startAnimating];
    
    [self addSubview:_animationView];
}


/*
 * action from fireware download
 */
- (void)noNetwork
{
    [_progressBar setHidden:YES];
    
    _messageLabel.text = @"无法连接服务器";
    [_messageLabel setHidden:NO];
    
    // noNetwork可能是在“下载固件”时被调用 也可能是在“固件更新时被调用
    // 因此我们需要移除所有action
    [_actionButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    
    [_actionButton setTitle:@"检查固件更新" forState:UIControlStateNormal];
    [_actionButton addTarget:self.delegate action:@selector(checkNewVersion) forControlEvents:UIControlEventTouchUpInside];
    
    [_actionButton setHidden:NO];
}

- (void)beginCheckNewVersion
{
    [_progressBar setHidden:YES];
    [_actionButton setHidden:YES];
    
    _messageLabel.text = @"正在检查新版本...";
    [_messageLabel setHidden:NO];
}

- (void)firewareUpdateNeeded:(BOOL)needed
{
    if (!needed) {
        [_progressBar setHidden:YES];
        [_actionButton setHidden:YES];
        
        _messageLabel.text = @"您的固件已是最新版本 无需更新";
        [_messageLabel setHidden:NO];
    }
    
}

- (void)newVersionDownloadNeeded:(BOOL)needed
{
    [_progressBar setHidden:YES];
    [_messageLabel setHidden:YES];
    
    // 移除之前的action
    [_actionButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    
    if (needed) {
        [_actionButton setTitle:@"下载新版本固件" forState:UIControlStateNormal];
        [_actionButton addTarget:self.delegate action:@selector(downloadNewVersion) forControlEvents:UIControlEventTouchUpInside];
    } else {
        _messageLabel.text = @"您已下载了新版本固件";
        [_messageLabel setHidden:NO];
        
        [_actionButton setTitle:@"更新固件" forState:UIControlStateNormal];
        [_actionButton addTarget:self.delegate action:@selector(updateFireware) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [_actionButton setHidden:NO];
}

- (void)beginDownloadNewVersion
{
    [_actionButton setHidden:YES];
    
    _messageLabel.text = @"正在下载...";
    [_messageLabel setHidden:NO];
    
    _progressBar.progress = 0.01f;
    [_progressBar setHidden:NO];
}

- (void)newVersionDownloadProgress:(double)progress
{
    _progressBar.progress = progress;
}

- (void)newVersionDownloadComplete
{
    [_progressBar setHidden:YES];
    
    _messageLabel.text = @"下载完毕";
    [_messageLabel setHidden:NO];
    
    // 移除之前的action
    [_actionButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    
    [_actionButton setTitle:@"更新固件" forState:UIControlStateNormal];
    [_actionButton addTarget:self.delegate action:@selector(updateFireware) forControlEvents:UIControlEventTouchUpInside];
    [_actionButton setHidden:NO];
}

- (void)newVersionDownloadFailed
{
    [_progressBar setHidden:YES];
    
    _messageLabel.text = @"下载失败 请重试";
    [_messageLabel setHidden:NO];
    
    [_actionButton setTitle:@"下载新版本固件" forState:UIControlStateNormal];
    
    // 之前的action就是downloadNewVersion 无需重复添加
    //[_actionButton addTarget:self.delegate action:@selector(downloadNewVersion) forControlEvents:UIControlEventTouchUpInside];
}

/*
 * action from fireware update
 */
- (void)beginScanForCertainDevice
{
    [_logoImageView setHidden:YES];
    [_messageLabel setHidden:YES];
    [_progressBar setHidden:YES];
    [_actionButton setHidden:YES];
    
    const CGFloat verticalSpace = 15.0;
    CGFloat tipsFrameHeight = 120;
    CGRect tipsFrame = CGRectMake(20, verticalSpace, self.frame.size.width - 40, tipsFrameHeight);
    [self addTips:tipsFrame];
    
    CGRect animationFrame = CGRectMake(0, 2 * verticalSpace + tipsFrameHeight, self.frame.size.width, self.frame.size.width / 1.6);
    [self addAnimation:animationFrame];
}

- (void)noBluetooth
{
    [_tipsTextView setHidden:YES];
    [_animationView setHidden:YES];
    
    [_logoImageView setHidden:NO];
    
    _messageLabel.text = @"请打开蓝牙";
    [_messageLabel setHidden:NO];
    
    [_progressBar setHidden:YES];
    
    [_actionButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [_actionButton setTitle:@"更新固件" forState:UIControlStateNormal];
    [_actionButton addTarget:self.delegate action:@selector(updateFireware) forControlEvents:UIControlEventTouchUpInside];
    [_actionButton setHidden:NO];
}

- (void)beginUpdateFireware
{
    [_tipsTextView setHidden:YES];
    [_animationView setHidden:YES];
    [_actionButton setHidden:YES];
    
    [_logoImageView setHidden:NO];
    
    _messageLabel.text = @"正在更新固件...";
    [_messageLabel setHidden:NO];
    
    _progressBar.progress = 0.01f;
    [_progressBar setHidden:NO];
}

- (void)firewareUpdateProgress:(double)progress
{
    _progressBar.progress = progress;
}

- (void)firewareUpdateComplete
{
    [_progressBar setHidden:YES];
    [_actionButton setHidden:YES];
    
    _messageLabel.text = @"固件升级完成";
    [_messageLabel setHidden:NO];
}

- (void)firewareUpdateFailed
{
    [_progressBar setHidden:YES];
    
    _messageLabel.text = @"固件升级失败 请重试";
    [_messageLabel setHidden:NO];
    
    [_actionButton setTitle:@"更新固件" forState:UIControlStateNormal];
    [_actionButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [_actionButton addTarget:self.delegate action:@selector(updateFireware) forControlEvents:UIControlEventTouchUpInside];
    [_actionButton setHidden:NO];
}



@end
