//
//  GXAddNewDeviceViewController.m
//  GXBLESmartHomeFurnishing
///Users/zkey/Desktop/login/addDevice/AddNewDeviceAnimationImage.plist
//  Created by zkey on 6/20/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXAddNewDeviceViewController.h"
#import "GXAddNewDeviceView.h"
#import "MICRO_COMMON.h"
#import "GXAddNewDeviceModel.h"

#import "zkeyActivityIndicatorView.h"

@interface GXAddNewDeviceViewController () <GXAddNewDeviceModelDelegate, GXAddNewDeviceViewDelegate>
{
    zkeyActivityIndicatorView *_activityIndicator;
    GXAddNewDeviceView *_addNewDeviceView;
    GXAddNewDeviceModel *_addNewDeviceModel;
}
@end

@implementation GXAddNewDeviceViewController
#pragma mark - initialize

- (void)viewDidLoad
{
    [super viewDidLoad];
    // ,,,
    [self configNavigationBar];
    [self addNewDeviceView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
    [self addNewDeviceModel];
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"添加门锁";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddNewDevice)];
    
}

- (void)addNewDeviceView:(CGRect)frame
{
    _addNewDeviceView = [[GXAddNewDeviceView alloc] initWithFrame:frame];
    _addNewDeviceView.delegate = self;
    [self.view addSubview:_addNewDeviceView];
}

- (void)addNewDeviceModel
{
    _addNewDeviceModel = [[GXAddNewDeviceModel alloc] init];
    _addNewDeviceModel.delegate = self;
}

#pragma mark - GXAddNewDeviceView delegate
- (void)setNewDeviceName:(NSString *)deviceName
{
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
    if (_activityIndicator == nil) {
        _activityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.view.frame title:@"正在添加设备..."];
        [self.view addSubview:_activityIndicator];
    }
    
    [_addNewDeviceModel setNewDeviceName:deviceName];
}

#pragma mark - GXAddNewDeviceModel delegate
- (void)deviceHadBeenInitialized
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"门锁添加失败" message:@"该门锁已经初始化过，若想恢复出厂设置，重新添加该门锁，请长按设置键直到听到提示音。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setNewDeviceName
{
    [_addNewDeviceView setNewDeviceName];
}

- (void)successfullyPaired:(BOOL)success
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
    
    if (!success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"配对失败 请重试" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)pressWrongButtonToInitialize
{
    // don't give alert to user in version 2.1.0
    // because of some kind of reason
    [_addNewDeviceView pressWrongButtonToInitialize];
}

- (void)noNetwork
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"配对失败" message:@"没有网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - click menu button
- (void)cancelAddNewDevice
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
