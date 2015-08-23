//
//  GXRegisterFirstViewController.m
//  FenHongForIOS
//
//  Created by zkey on 8/5/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "GXRegisterFirstViewController.h"

#import "MICRO_COMMON.h"

#import "GXRegisterModel.h"
#import "zkeyIndentifierValidator.h"

#import "zkeyViewHelper.h"
#import "zkeyActivityIndicatorView.h"

#import "FHRegisterSecondViewController.h"
#import "FHRegisterThirdViewController.h"

@interface GXRegisterFirstViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GXRegisterModelDelegate>
{
    UITableView *_tableView;
    UIButton *_nextStepButton;
    
    UITextField *_userNameTextField;
    
    UITextField *_verificationCodeTextField;
    // accessory view of _verificationCodeTextField
    // play the left valid seconds
    UILabel *_leftValidSecondsLabel;
    NSTimer *_leftValidSecondsTimer;
    NSInteger _leftValidSeconds;
    BOOL _isVerificationCodeSended;
    
    zkeyActivityIndicatorView *_activityIndicator;
    
    GXRegisterModel *_registerModel;
    
    NSString *_userName;
    NSString *_validityCode;
}
@end

@implementation GXRegisterFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isVerificationCodeSended = NO;
    [self configNavigationBar];
    [self addRegisterModel];
    [self addTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)configNavigationBar
{
    if (self.viewType == RegisterViewTypeForgetPassword) {
        self.navigationItem.title = @"重置密码";
    } else if (self.viewType == RegisterViewTypeRegister) {
        self.navigationItem.title = @"注册";
    }
}

- (void)addRegisterModel
{
    _registerModel = [[GXRegisterModel alloc] init];
    _registerModel.delegate = self;
}

- (void)addTableView:(CGRect)frame
{
    // table view
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // withdraw button
    UIView *_withdrawView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
    _nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(15.0f, 10, frame.size.width - 30.0f, 40.0f)];
    _nextStepButton.backgroundColor = MAIN_COLOR;
    [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextStepButton.layer.masksToBounds = YES;
    _nextStepButton.layer.cornerRadius = 3.0;
    [_nextStepButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    _nextStepButton.enabled = NO;
    [_withdrawView addSubview:_nextStepButton];
    
    [_tableView setTableFooterView:_withdrawView];
    
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"手机号";
        
        // 手机号输入框
        _userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width - 110.0f, 30.0)];
        _userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
        _userNameTextField.borderStyle = UITextBorderStyleNone;
        _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameTextField.returnKeyType = UIReturnKeyDone;
        _userNameTextField.placeholder = @"请输入您的手机号";
        _userNameTextField.delegate = self;
        cell.accessoryView = _userNameTextField;
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"验证码";
        
        _verificationCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width - 110.0f, 30.0)];
        _verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _verificationCodeTextField.borderStyle = UITextBorderStyleNone;
        _verificationCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _verificationCodeTextField.returnKeyType = UIReturnKeyDone;
        _verificationCodeTextField.placeholder = @"点击获取验证码";
        _verificationCodeTextField.delegate = self;
        cell.accessoryView = _verificationCodeTextField;
        
        // valid seconds label
        _leftValidSecondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90.0f, 21.0f)];
        _leftValidSecondsLabel.textColor = [UIColor lightGrayColor];
        _leftValidSecondsLabel.backgroundColor = [UIColor clearColor];
        _leftValidSecondsLabel.textAlignment = NSTextAlignmentRight;
        _leftValidSecondsLabel.font = [UIFont systemFontOfSize:14.0];
        _leftValidSecondsLabel.text = @"";
        _verificationCodeTextField.rightView = _leftValidSecondsLabel;
        _verificationCodeTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - table view delegate
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return @"该手机号将作为您的用户名";
    } else if (section == 1) {
        return @"验证码300秒内有效";
    }
    
    return nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _verificationCodeTextField) {
        [_userNameTextField resignFirstResponder];
        
        if (_isVerificationCodeSended) {
            [UIView animateWithDuration:0.2f animations:^{
                [_tableView setContentInset:UIEdgeInsetsMake(-70.0f, 0, 0, 0)];
            }];
            return YES;
        } else {
            _userName = _userNameTextField.text;
            if (![zkeyIndentifierValidator isValidChinesePhoneNumber:_userName]) {
                [self alertWithMessage:@"请输入正确的手机号"];
                return NO;
            }
            
            // get verify code
            _activityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.view.frame title:@"正在获取验证码..."];
            [self.view addSubview:_activityIndicator];
            [_registerModel getValidCode:_userName withType:self.viewType];
            
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2f animations:^{
        [_tableView setContentInset:UIEdgeInsetsZero];
    }];
    
    return YES;
}

#pragma mark - registerModelDelegate
// 没有网络连接
- (void)noNetwork
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
    
    [self alertWithMessage:@"没有网络连接"];
}

// 不合法的用户名
- (void)invalidUserName
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
    
    if (self.viewType == RegisterViewTypeRegister) {
        [self alertWithMessage:@"该账号已注册过"];
    } else if (self.viewType == RegisterViewTypeForgetPassword) {
        [self alertWithMessage:@"该账号还未注册"];
    }
}

// 合法的用户名，系统向用户发送手机号后开始倒计时
- (void)validUserName
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
    
    // 开始倒计时
    _isVerificationCodeSended = YES;
    _verificationCodeTextField.placeholder = @"请输入验证码";
    _nextStepButton.enabled = YES;
    
    [self addTimerAndLabel];
}

#pragma mark - left seconds timer
- (void)addTimerAndLabel
{
    _leftValidSeconds = 300;
    _leftValidSecondsLabel.text = @"300秒后失效";
    _leftValidSecondsTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateLeftSecondsLabel) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_leftValidSecondsTimer forMode:NSRunLoopCommonModes];
}

- (void)updateLeftSecondsLabel
{
    if (_leftValidSeconds <= 1) {
        [_leftValidSecondsTimer invalidate];
        
        _leftValidSecondsLabel.text = @"";
        
        [_verificationCodeTextField resignFirstResponder];
        _verificationCodeTextField.text = @"";
        _verificationCodeTextField.placeholder = @"点击发送验证码";
        
        _isVerificationCodeSended = NO;
        
        return;
    }
    
    _leftValidSeconds -= 1;
    _leftValidSecondsLabel.text = [NSString stringWithFormat:@"%ld秒后失效", (long)_leftValidSeconds];
}



// 验证码错误
- (void)wrongValidCode
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
    
    [self alertWithMessage:@"验证码错误"];
}

// 验证码正确
- (void)correctValidCode
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
    
    if (self.viewType == RegisterViewTypeForgetPassword) {
        FHRegisterThirdViewController *registerThridStep = [[FHRegisterThirdViewController alloc] init];
        registerThridStep.userName = _userName;
        registerThridStep.validityCode = _validityCode;
        registerThridStep.viewType = self.viewType;
        
        [self.navigationController pushViewController:registerThridStep animated:YES];
    } else if (self.viewType == RegisterViewTypeRegister) {
        FHRegisterSecondViewController *registerSecondStep = [[FHRegisterSecondViewController alloc] init];
        registerSecondStep.userName = _userName;
        registerSecondStep.validityCode = _validityCode;
        registerSecondStep.viewType = self.viewType;
        
        [self.navigationController pushViewController:registerSecondStep animated:YES];
    }
}

- (void)alertWithMessage:(NSString *)message
{
    [zkeyViewHelper alertWithMessage:message inView:self.view withFrame:self.view.frame];
}
#pragma mark - user action
- (void)nextStep:(UIButton *)sender
{
    [_verificationCodeTextField resignFirstResponder];
    
    _validityCode = _verificationCodeTextField.text;
    if (_validityCode.length != 4) {
        [self alertWithMessage:@"验证码错误"];
        return;
    }
    
    _activityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.view.frame title:@"正在核对验证码..."];
    [self.view addSubview:_activityIndicator];
    
    [_registerModel checkValidCode:_validityCode withUserName:_userName];
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
