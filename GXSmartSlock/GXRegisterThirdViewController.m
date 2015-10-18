//
//  GXRegisterThirdViewController.m
//  FenHongForIOS
//
//  Created by zkey on 8/5/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "GXRegisterThirdViewController.h"

#import "MICRO_COMMON.h"

#import "GXRegisterModel.h"
#import "zkeyIdentifierValidator.h"
#import "zkeyViewHelper.h"
#import "zkeyActivityIndicatorView.h"

#import "GXRootViewController.h"

@interface GXRegisterThirdViewController () <UITextFieldDelegate, GXRegisterModelDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UITextField *_passwordFirstTextField;
    UITextField *_passwordSecondTextField;
    
    UIButton *_nextStepButton;
    GXRegisterModel *_registerModel;
    
    UITableView *_tableView;
    
    zkeyActivityIndicatorView *_activityIndicator;
}
@end
 
@implementation GXRegisterThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.navigationItem.title = @"设置密码";
    
    
    [self addRegisterModel];
    [self addTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
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
    
    NSString *title = @"注册";
    if (self.viewType == RegisterViewTypeRegister) {
        title = @"注册";
    } else if (self.viewType == RegisterViewTypeForgetPassword) {
        title = @"重置密码";
    }
    
    [_nextStepButton setTitle:title forState:UIControlStateNormal];
    [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextStepButton.layer.masksToBounds = YES;
    _nextStepButton.layer.cornerRadius = 3.0;
    [_nextStepButton addTarget:self action:@selector(clickNextStepButton:) forControlEvents:UIControlEventTouchUpInside];
    [_withdrawView addSubview:_nextStepButton];
    
    [_tableView setTableFooterView:_withdrawView];
    
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"密码";
        
        // 密码1输入框
        _passwordFirstTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width - 100.0f, 30.0f)];
        _passwordFirstTextField.keyboardType = UIKeyboardTypeDefault;
        _passwordFirstTextField.borderStyle = UITextBorderStyleNone;
        _passwordFirstTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordFirstTextField.returnKeyType = UIReturnKeyDone;
        _passwordFirstTextField.placeholder = @"8-20位数字和字母";
        _passwordFirstTextField.delegate = self;
        _passwordFirstTextField.secureTextEntry = YES;
        cell.accessoryView = _passwordFirstTextField;
    } else if (indexPath.row == 1) {
        // 密码2输入框
        cell.textLabel.text = @"密码";
        
        // 昵称输入框
        _passwordSecondTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width - 100.0f, 30.0f)];
        _passwordSecondTextField.keyboardType = UIKeyboardTypeDefault;
        _passwordSecondTextField.borderStyle = UITextBorderStyleNone;
        _passwordSecondTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordSecondTextField.returnKeyType = UIReturnKeyDone;
        _passwordSecondTextField.placeholder = @"请再输入一次密码";
        _passwordSecondTextField.delegate = self;
        _passwordSecondTextField.secureTextEntry = YES;
        cell.accessoryView = _passwordSecondTextField;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)clickNextStepButton:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (![_passwordFirstTextField.text isEqualToString:_passwordSecondTextField.text]) {
        [self alertWithMessage:@"两次密码不一致"];
        return;
    }
    
    NSString *password = _passwordFirstTextField.text;
    
    if (password.length < 8 || password.length > 20) {
        [self alertWithMessage:@"密码长度应为8-20位"];
        return;
    }
    
    if (![zkeyIdentifierValidator isStringWithNumberAndAlphabet:password]) {
        [self alertWithMessage:@"密码应包含数字和字母"];
        return;
    }
    
    NSString *title = @"";
    if (self.viewType == RegisterViewTypeRegister) {
        title = @"正在注册...";
    } else if (self.viewType == RegisterViewTypeForgetPassword) {
        title = @"正在重置密码...";
    }
    _activityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.view.frame title:title];
    [self.view addSubview:_activityIndicator];
    
    if (self.viewType == RegisterViewTypeForgetPassword) {
        [_registerModel resetPassWordWithUserName:self.userName password:_passwordFirstTextField.text validityCode:self.validityCode];
    } else if (self.viewType == RegisterViewTypeRegister) {
        [_registerModel registerWithUserName:self.userName nickname:self.nickname password:_passwordFirstTextField.text validityCode:self.validityCode];
    }
}

- (void)noNetwork
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
    
    [self alertWithMessage:@"无法连接服务器"];
}

- (void)registerOrResetSucceed
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
    
    if (self.viewType == RegisterViewTypeForgetPassword) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"果心提示" message:@"密码重置成功，请重新登录" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (self.viewType == RegisterViewTypeRegister) {
        GXRootViewController *rootVC = [[GXRootViewController alloc] init];
        self.view.window.rootViewController = rootVC;
    }
}

- (void)registerOrResetFailed
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
    
    [self alertWithMessage:@"发生未知错误 请重试"];
}

- (void)alertWithMessage:(NSString *)message
{
    [zkeyViewHelper alertWithMessage:message inView:self.view withFrame:self.view.frame];
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
