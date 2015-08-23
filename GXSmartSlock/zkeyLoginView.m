//
//  zkeyLoginView.m
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 7/9/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "zkeyLoginView.h"

#import "MICRO_LOGIN.h"
#import "MICRO_COMMON.h"


#import "zkeyViewHelper.h"
#import "zkeyActivityIndicatorView.h"




@interface zkeyLoginView () <UITextFieldDelegate, UIScrollViewDelegate>
{
    UIScrollView *_loginScrollView;
    UITextField *_userNameTextField;
    UITextField *_passwordTextField;
    UIButton *_loginButton;
    
    zkeyActivityIndicatorView *_loginActivityIndicator;
}
@end


@implementation zkeyLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        
        // login scorll view (deal with keyboard)
        CGRect loginScrollViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addLoginScrollView:loginScrollViewFrame];
        
        // app icon
        CGFloat appIconWidth = 80.0f;
        CGFloat verticalSpace = 20.0f;
        CGRect appIconImageViewFrame = CGRectMake(frame.size.width / 2.0 - appIconWidth / 2.0, 30.0f, appIconWidth, appIconWidth);
        [self addAppIconImageView:appIconImageViewFrame];
        
        // inputField
        CGFloat inputFieldWidth = self.frame.size.width - 30.0;
        CGRect inputFieldFrame = CGRectMake((frame.size.width - inputFieldWidth) / 2.0, appIconImageViewFrame.origin.y + appIconImageViewFrame.size.height + 1.5 * verticalSpace, inputFieldWidth, 89.0f);
        [self addInputField:inputFieldFrame];
        
        // login button
        CGRect loginButtonFrame = CGRectMake(15.0, inputFieldFrame.origin.y + inputFieldFrame.size.height + verticalSpace, frame.size.width - 30, 40);
        [self addloginButton:loginButtonFrame];
        
        // forget password button
        CGRect forgetPasswordButtonFrame = CGRectMake(loginButtonFrame.origin.x + loginButtonFrame.size.width - 80, loginButtonFrame.origin.y + loginButtonFrame.size.height, 80, 40);
        [self addForgetPasswordButton:forgetPasswordButtonFrame];
        
        // register button
        CGRect registerButtonFrame = CGRectMake(frame.size.width / 2.0 - 40.0f, frame.size.height - 50.0f, 80.0f, 40);
        [self addRegisterButton:registerButtonFrame];
        
    }
    
    return self;
}

- (void)addLoginScrollView:(CGRect)frame
{
    _loginScrollView = [[UIScrollView alloc] initWithFrame:frame];
    _loginScrollView.scrollEnabled = NO;
    _loginScrollView.contentSize = CGSizeMake(frame.size.width, 1.5 * frame.size.height);
    _loginScrollView.contentOffset = CGPointZero;
    _loginScrollView.delegate = self;
    [self addSubview:_loginScrollView];
}

- (void)addAppIconImageView:(CGRect)frame
{
    UIImageView *appIconImageView = [[UIImageView alloc] initWithFrame:frame];
    appIconImageView.image = [UIImage imageNamed:APP_LOGO_FOR_LOGIN];
    [_loginScrollView addSubview:appIconImageView];
}

- (void)addInputField:(CGRect)frame
{
    CGFloat inputTextFieldHeight = (frame.size.height - 1.0) / 2.0;
    
    // user name
    _userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, inputTextFieldHeight)];
    _userNameTextField.backgroundColor = [UIColor whiteColor];
    _userNameTextField.layer.masksToBounds = YES;
    _userNameTextField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1.0] CGColor];
    _userNameTextField.layer.borderWidth = 1.0;
    _userNameTextField.layer.cornerRadius = 2.0;
    _userNameTextField.placeholder = @"手机号或邮箱";
    _userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameTextField.returnKeyType = UIReturnKeyNext;
    
    UIImageView *userNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 20, 20)];
    userNameImageView.image = [UIImage imageNamed:USER_NAME_TEXT_FIELD_ICON];
    UIView *userNameTextFieldLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [userNameTextFieldLeftView addSubview:userNameImageView];
    
    _userNameTextField.leftView = userNameTextFieldLeftView;
    _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    _userNameTextField.delegate = self;
    [_userNameTextField addTarget:self action:@selector(textfieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_loginScrollView addSubview:_userNameTextField];
    
    // password
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + inputTextFieldHeight - 1.0, frame.size.width, inputTextFieldHeight)];
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.layer.masksToBounds = YES;
    _passwordTextField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1.0] CGColor];
    _passwordTextField.layer.borderWidth = 1.0;
    _passwordTextField.layer.cornerRadius = 2.0;
    _passwordTextField.placeholder = @"密码";
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    
    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 20, 20)];
    passwordImageView.image = [UIImage imageNamed:PASSWORD_TEXT_FIELD_ICON];
    UIView *passwordTextFieldLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [passwordTextFieldLeftView addSubview:passwordImageView];
    
    _passwordTextField.leftView = passwordTextFieldLeftView;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    _passwordTextField.delegate = self;
    [_passwordTextField addTarget:self action:@selector(textfieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_loginScrollView addSubview:_passwordTextField];
}

- (void)addloginButton:(CGRect)frame
{
    _loginButton = [[UIButton alloc] initWithFrame:frame];
    _loginButton.backgroundColor = MAIN_COLOR;
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 5.0;
    
    
    
    [_loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 只有输入了用户名和密码用户才可以点击登录
    _loginButton.enabled = NO;
    [_loginScrollView addSubview:_loginButton];
}

- (void)addRegisterButton:(CGRect)frame
{
    UIButton *registButton = [[UIButton alloc] initWithFrame:frame];
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    [registButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    registButton.titleLabel.textAlignment = NSTextAlignmentRight;
    registButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    [registButton addTarget:self action:@selector(clickRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginScrollView addSubview:registButton];
}

- (void)addForgetPasswordButton:(CGRect)frame
{
    UIButton *forgetPasswordButton = [[UIButton alloc] initWithFrame:frame];
    [forgetPasswordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPasswordButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    forgetPasswordButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    [forgetPasswordButton addTarget:self action:@selector(clickForgetPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginScrollView addSubview:forgetPasswordButton];
}

#pragma mark - action
- (void)clickLoginButton:(UIButton *)sender
{
    [self endEditing:YES];
    
    if (_loginActivityIndicator == nil) {
        _loginActivityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.frame title:@"正在登录..."];
    }
    
    [self addSubview:_loginActivityIndicator];
    
    NSString *userName = _userNameTextField.text;
    NSString *password = _passwordTextField.text;
    
    [self.delegate loginWithUserName:userName password:password];
}

- (void)clickForgetPasswordButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(clickForgetPasswordButton)]) {
        [self.delegate clickForgetPasswordButton];
    }
}

- (void)clickRegisterButton:(UIButton *)sender
{
    [self.delegate clickRegisterButton];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [_loginScrollView setContentOffset:CGPointMake(0, 25.0) animated:YES];
    _loginScrollView.scrollEnabled = YES;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_loginScrollView setContentOffset:CGPointZero animated:YES];
    _loginScrollView.scrollEnabled = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == _userNameTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _loginButton.enabled = NO;
    
    return YES;
}


// 监视textField的值变化
- (void)textfieldTextDidChange:(UITextField *)textField
{
    if (_userNameTextField.text.length > 0 && _passwordTextField.text.length > 0) {
        _loginButton.enabled = YES;
    } else {
        _loginButton.enabled = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_loginScrollView setContentOffset:CGPointZero animated:YES];
    _loginScrollView.scrollEnabled = NO;
}

#pragma mark - action feedback
- (void)noNetworkToLogin
{
    [_loginActivityIndicator removeFromSuperview];
    [zkeyViewHelper alertWithMessage:@"网络连接异常" inView:self withFrame:self.frame];
}

- (void)successfullyLogin
{
    [_loginActivityIndicator removeFromSuperview];
}

- (void)wrongUserNameOrPassword
{
    [_loginActivityIndicator removeFromSuperview];
    [zkeyViewHelper alertWithMessage:@"用户名或密码错误" inView:self withFrame:self.frame];
}

@end
