//
//  GXLoginViewController.m
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 7/9/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXLoginViewController.h"

#import "MICRO_COMMON.h"

#import "zkeyLoginView.h"

#import "GXLoginModel.h"
#import "zkeyMiPushPackage.h"

#import "GXRegisterFirstViewController.h"
#import "GXRootViewController.h"

@interface GXLoginViewController () <zkeyLoginViewDelegate, GXLoginModelDelegate>
{
    zkeyLoginView *_loginView;
    GXLoginModel *_loginModel;

}
@end

@implementation GXLoginViewController
#pragma mark - initialize
- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something...
    
    [self configNavigationBar];
    [self addLoginModel];
    
    CGRect loginViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - NAVIGATION_BASED_TOP_SPACE);
    [self addLoginView:loginViewFrame];
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"登录";
}

- (void)addLoginView:(CGRect)frame
{
    _loginView = [[zkeyLoginView alloc] initWithFrame:frame];
    _loginView.delegate = self;
    
    [self.view addSubview:_loginView];
}

- (void)addLoginModel
{
    _loginModel = [[GXLoginModel alloc] init];
    _loginModel.delegate = self;
}

#pragma mark - zkeyLoginViewDelegate
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password
{
    [_loginModel loginWithUserName:userName password:password];
}

- (void)clickForgetPasswordButton
{
    GXRegisterFirstViewController *forgetPassword = [[GXRegisterFirstViewController alloc] init];
    forgetPassword.viewType = RegisterViewTypeForgetPassword;
    [self.navigationController pushViewController:forgetPassword animated:YES];
}

- (void)clickRegisterButton
{
    GXRegisterFirstViewController *registerVC = [[GXRegisterFirstViewController alloc] init];
    registerVC.viewType = RegisterViewTypeRegister;
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - GXLoginModelDelegate
- (void)noNetworkToLogin
{
    [_loginView noNetworkToLogin];
}

- (void)wrongUserNameOrPassword
{
    [_loginView wrongUserNameOrPassword];
}

- (void)successfullyLogin
{
    [_loginView successfullyLogin];
    
    GXRootViewController *rootVC = [[GXRootViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.view.window.rootViewController = navigationController;
}


@end
