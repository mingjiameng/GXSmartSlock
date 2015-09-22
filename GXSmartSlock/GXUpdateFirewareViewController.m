//
//  GXUpdateFirewareViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/17/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXUpdateFirewareViewController.h"

#import "MICRO_COMMON.h"

#import "GXFirewareNewVersionDownloadModel.h"
#import "GXFirewareUpdateModel.h"

#import "GXUpdateFirewareView.h"

@interface GXUpdateFirewareViewController () <GXFirewareNewVersionDownloadModelDelegate, GXUpdateFirewareViewDelegate, GXFirewareUpdateModelDelegate>
{
    GXFirewareNewVersionDownloadModel *_newVersionDownloadModel;
    GXFirewareUpdateModel *_updateFirewareModel;
    
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
    _newVersionDownloadModel = [[GXFirewareNewVersionDownloadModel alloc] init];
    _newVersionDownloadModel.deviceIdentifire = self.deviceIdentifire;
    _newVersionDownloadModel.downloadedVersion = self.downloadedVersion;
    _newVersionDownloadModel.currentVersion = self.currentVersion;
    _newVersionDownloadModel.deviceCategory = self.deviceCategory;
    _newVersionDownloadModel.delegate = self;
    
    _updateFirewareModel = [[GXFirewareUpdateModel alloc] init];
    _updateFirewareModel.deviceIdentifire = self.deviceIdentifire;
    _updateFirewareModel.delegate = self;
}

- (void)addUpdateFirewareView:(CGRect)frame
{
    _updateFirewareView = [[GXUpdateFirewareView alloc] initWithFrame:frame];
    _updateFirewareView.delegate = self;
    
    [self.view addSubview:_updateFirewareView];
}


#pragma mark - GXFirewareNewVersionDownloadModelDelegate
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


#pragma mark - GXFirewareUpdateModelDelegate
- (void)beginScanForCertainDevice
{
    [_updateFirewareView beginScanForCertainDevice];
}

- (void)noBluetooth
{
    [_updateFirewareView noBluetooth];
}

- (void)beginUpdateFireware
{
    [_updateFirewareView beginUpdateFireware];
}

- (void)firewareUpdateProgress:(double)progress
{
    [_updateFirewareView firewareUpdateProgress:progress];
}

- (void)firewareUpdateComplete
{
    [_updateFirewareView firewareUpdateComplete];
}

- (void)firewareUpdateFailed
{
    [_updateFirewareView firewareUpdateFailed];
}

#pragma mark -  user action
- (void)checkNewVersion
{
    [_newVersionDownloadModel checkNewVersion];
}

- (void)downloadNewVersion
{
    [_newVersionDownloadModel downloadNewVersion];
}

- (void)updateFireware
{
    if (_updateFirewareModel == nil) {
        _updateFirewareModel = [[GXFirewareUpdateModel alloc] init];
        _updateFirewareModel.deviceIdentifire = self.deviceIdentifire;
        _updateFirewareModel.downloadedVersion = MAX(_newVersionDownloadModel.latestVersion, _newVersionDownloadModel.downloadedVersion);
    }
    
    _updateFirewareModel.isConnected = NO;
    _updateFirewareModel.inProgramming = NO;
    [_updateFirewareModel updateFireware];
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
