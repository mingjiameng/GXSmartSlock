//
//  GXUpdateFirewareViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/17/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXUpdateFirewareViewController.h"

#import "MICRO_COMMON.h"

#import "GXFirewareNewVersionUpdateModel.h"

#import "GXUpdateFirewareView.h"

@interface GXUpdateFirewareViewController () <GXFirewareNewVersionUpdateModelDelegate, GXUpdateFirewareViewDelegate>
{
    GXFirewareNewVersionUpdateModel *_newVersionUpdateModel;
    GXUpdateFirewareView *_updateFirewareView;
}
@end

@implementation GXUpdateFirewareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavigationBar];
    [self addLogicModel];
    [self addUpdateFirewareView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
}

- (void)configNavigationBar
{
    self.title = @"固件升级";
}

- (void)addLogicModel
{
    _newVersionUpdateModel = [[GXFirewareNewVersionUpdateModel alloc] init];
    _newVersionUpdateModel.deviceIdentifire = self.deviceIdentifire;
    _newVersionUpdateModel.downloadedVersion = self.downloadedVersion;
    _newVersionUpdateModel.currentVersion = self.currentVersion;
    _newVersionUpdateModel.deviceCategory = self.deviceCategory;
    _newVersionUpdateModel.delegate = self;
}

- (void)addUpdateFirewareView:(CGRect)frame
{
    _updateFirewareView = [[GXUpdateFirewareView alloc] initWithFrame:frame];
    _updateFirewareView.delegate = self;
    
    [self.view addSubview:_updateFirewareView];
}


#pragma mark - GXFirewareNewVersionUpdateModelDelegate
- (void)noNetwork
{
    [_updateFirewareView noNetwork];
}

- (void)beginCheckNewVersion
{
    [_updateFirewareView beginCheckNewVersion];
}

- (void)firewareUpdateNeeded:(BOOL)needed
{
    [_updateFirewareView firewareUpdateNeeded:needed];
}

- (void)newVersionDownloadNeeded:(BOOL)needed
{
    [_updateFirewareView newVersionDownloadNeeded:needed];
}

- (void)beginDownloadNewVersion
{
    [_updateFirewareView beginDownloadNewVersion];
}

- (void)newVersionDownloadProgress:(double)progress
{
    [_updateFirewareView newVersionDownloadProgress:progress];
}

- (void)newVersionDownloadComplete
{
    [_updateFirewareView newVersionDownloadComplete];
}

- (void)newVersionDownloadFailed
{
    [_updateFirewareView newVersionDownloadFailed];
}


#pragma mark -  user action
- (void)checkNewVersion
{
    [_newVersionUpdateModel checkNewVersion];
}

- (void)downloadNewVersion
{
    [_newVersionUpdateModel downloadNewVersion];
}

- (void)updateFireware
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
