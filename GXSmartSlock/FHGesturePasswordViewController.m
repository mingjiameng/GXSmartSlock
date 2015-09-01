//
//  FHGesturePasswordViewController.m
//  FenHongForIOS
//
//  Created by zkey on 8/6/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "FHGesturePasswordViewController.h"

#import "MICRO_COMMON.h"

#import "GXLogoutModel.h"

#import "GesturePasswordView.h"

#import "GXLoginViewController.h"

#define MAIN_TITLE_COLOR [UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]

@interface FHGesturePasswordViewController () <TouchEndDelegate, UIAlertViewDelegate>
{
    NSString *_currentPassword;
    NSString *_newPassword;
    GesturePasswordView *_gestureView;
}
@end

@implementation FHGesturePasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeGestureView];
    
    if (self.viewType != GesturePasswordViewTypeVerification) {
        [self addDismissButton];
    }
}

- (void)initializeGestureView
{
    _currentPassword = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_GESTURE_PASSWORD];
    _newPassword = nil;
    
    _gestureView = [[GesturePasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_gestureView.tentacleView setTouchEndDelegate:self];
    [self.view addSubview:_gestureView];
    
    [self resetGestureViewWithMessage:@"请输入密码" color:MAIN_TITLE_COLOR];
    
    // 忘记密码按钮
    // 如果用户忘记了手势密码，可以点击忘记密码
    // 此时系统提示用户登出，登出后手势密码即被清除
    if (self.viewType != GesturePasswordViewTypeSet) {
        UIButton *forgetPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50.0f, self.view.frame.size.width, 50.0f)];
        [forgetPasswordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [forgetPasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [forgetPasswordButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:forgetPasswordButton aboveSubview:_gestureView];
    }
    
}

- (void)resetGestureViewWithMessage:(NSString *)message color:(UIColor *)color
{
    [_gestureView.state setTextColor:color];
    [_gestureView.state setText:message];
}

- (void)addDismissButton
{
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f ,20.0f, 40.0f, 44.0f)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:cancelButton aboveSubview:_gestureView];
}

- (void)dismissVC
{
    if (self.gesturePasswordChanged) {
        self.gesturePasswordChanged(YES);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - delegate
- (BOOL)gestureTouchDidEnd:(NSString *)result
{
    if (self.viewType == GesturePasswordViewTypeVerification || self.viewType == GesturePasswordViewTypeClear) {
        if ([result isEqualToString:_currentPassword]) {
            if (self.viewType == GesturePasswordViewTypeVerification) {
                [self verifyPassword];
            } else {
                [self clearGesturePassword];
            }
            
            return YES;
        }
        
        [self resetGestureViewWithMessage:@"密码错误" color:[UIColor redColor]];
        return NO;
        
    } else if (self.viewType == GesturePasswordViewTypeSet) {
        if (_newPassword == nil) {
            _newPassword = [result copy];
            [self resetGestureViewWithMessage:@"请再输入一次密码" color:MAIN_TITLE_COLOR];
            return YES;
        } else {
            if ([result isEqualToString:_newPassword]) {
                [self resetGestureViewWithMessage:@"密码设置成功" color:MAIN_TITLE_COLOR];
                [self setGesturePassword:_newPassword];
                return YES;
            } else {
                [self resetGestureViewWithMessage:@"两次密码不一致" color:[UIColor redColor]];
                _newPassword = nil;
                return NO;
            }
        }
        
    } else if (self.viewType == GesturePasswordViewTypeReset) {
        if (_currentPassword != nil && _newPassword == nil) {
            if ([result isEqualToString:_currentPassword]) {
                [self resetGestureViewWithMessage:@"请输入新密码" color:MAIN_TITLE_COLOR];
                _currentPassword = nil;
                return YES;
            } else {
                [self resetGestureViewWithMessage:@"密码错误" color:[UIColor redColor]];
                return NO;
            }
        } else if (_newPassword == nil) {
            _newPassword = [result copy];
            [self resetGestureViewWithMessage:@"请再输入一次新密码" color:MAIN_TITLE_COLOR];
            return YES;
        } else {
            if ([result isEqualToString:_newPassword]) {
                [self setGesturePassword:_newPassword];
                [self resetGestureViewWithMessage:@"密码重置成功" color:MAIN_TITLE_COLOR];
                return YES;
            } else {
                [self resetGestureViewWithMessage:@"两次密码不一致 请重新输入" color:[UIColor redColor]];
                _currentPassword = @"";
                _newPassword = nil;
            }
        }
    }
    
    return NO;
}

// 设置新密码
- (void)setGesturePassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:_newPassword forKey:DEFAULT_GESTURE_PASSWORD];
    
    if (self.gesturePasswordChanged) {
        self.gesturePasswordChanged(YES);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

// 关闭手势密码
- (void)clearGesturePassword
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEFAULT_GESTURE_PASSWORD];
    
    if (self.gesturePasswordChanged) {
        self.gesturePasswordChanged(YES);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)verifyPassword
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)logout
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"忘记密码?" message:@"如果您忘记了手势密码，您可以通过登出来清除手势密码，登出后需要重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登出", nil];
    alert.tag = 10086;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10086) {
        if (buttonIndex == 0) {
            return;
        }
        
        GXLoginViewController *loginViewController = [[GXLoginViewController alloc] init];
        UINavigationController *loginNavigation = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        self.view.window.rootViewController = loginNavigation;
        
        [GXLogoutModel logout];
    }
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
