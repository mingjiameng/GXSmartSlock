//
//  GXSetPasswordViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/1/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSetPasswordViewController.h"

#import "MICRO_COMMON.h"

#import "zkeyIdentifierValidator.h"
#import "GXUpdatePasswordModel.h"


#import "zkeyViewHelper.h"
#import "zkeyActivityIndicatorView.h"

@interface GXSetPasswordViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GXUpdatePasswordModelDelegate>
{
    UIBarButtonItem *_doneBarButtonItem;
    
    UITextField *_oldPasswordTextField;
    UITextField *_newPasswordOnceTextField;
    UITextField *_newPasswordTwiceTextField;
    
    zkeyActivityIndicatorView *_activityIndicator;
    
    GXUpdatePasswordModel *_updatePasswordModel;
    
    NSString *_newPassword;
    
}

@property (nonatomic, strong) UITableView *tableView;
@end


@implementation GXSetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something...
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavigationBar];
    [self addSetNicknameTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
}

- (void)configNavigationBar
{
    self.title = @"更改密码";
    
    _doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updatePassword)];
    self.navigationItem.rightBarButtonItem = _doneBarButtonItem;
}

- (void)addSetNicknameTableView:(CGRect)frame
{
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSString *title = nil;
    if (indexPath.row == 0) {
        title = @"当前密码";
    } else if (indexPath.row == 1) {
        title = @"新密码";
    } else if (indexPath.row == 2) {
        title = @"确认密码";
    }
    cell.textLabel.text = title;
    
    if (indexPath.row == 0) {
        if (_oldPasswordTextField == nil) {
            _oldPasswordTextField = [self passwordTextField:CGRectMake(0, 0, tableView.frame.size.width - 110.0f, 30.0) withPlaceHolder:@"请输入当前的帐号密码"];
        }
        
        cell.accessoryView = _oldPasswordTextField;
    } else if (indexPath.row == 1) {
        if (_newPasswordOnceTextField == nil) {
            _newPasswordOnceTextField = [self passwordTextField:CGRectMake(0, 0, tableView.frame.size.width - 110.0f, 30.0) withPlaceHolder:@"8-20位数字或字母"];
        }
        
        cell.accessoryView = _newPasswordOnceTextField;
    } else if (indexPath.row == 2) {
        if (_newPasswordTwiceTextField == nil) {
            _newPasswordTwiceTextField = [self passwordTextField:CGRectMake(0, 0, tableView.frame.size.width - 110.0f, 30.0) withPlaceHolder:@"请再输入一次新密码"];
        }
        
        cell.accessoryView = _newPasswordTwiceTextField;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UITextField *)passwordTextField:(CGRect)frame withPlaceHolder:(NSString *)placeHolder
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = YES;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.returnKeyType = UIReturnKeyDone;
    textField.placeholder = placeHolder;
    textField.delegate = self;
    
    return textField;
}

#pragma mark - user action
- (void)updatePassword
{
    self.view.userInteractionEnabled = NO;
    
    if (_activityIndicator == nil) {
        _activityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.view.frame title:@"正在更改密码..."];
    }
    
    [self.view addSubview:_activityIndicator];
    
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    if (![password isEqualToString:_oldPasswordTextField.text]) {
        [_activityIndicator removeFromSuperview];
        [self alertWithMessage:@"当前密码错误"];
        self.view.userInteractionEnabled = YES;
        return;
    }
    
    if (![_newPasswordOnceTextField.text isEqualToString:_newPasswordTwiceTextField.text]) {
        [_activityIndicator removeFromSuperview];
        [self alertWithMessage:@"两次输入的新密码不一致"];
        self.view.userInteractionEnabled = YES;
        return;
    }
    
    NSString *newPassword = _newPasswordOnceTextField.text;
    if (newPassword.length < 8 || newPassword.length > 20 || ![zkeyIdentifierValidator isStringWithNumberAndAlphabet:newPassword]) {
        [_activityIndicator removeFromSuperview];
        [self alertWithMessage:@"密码应为8-20位数字或字母"];
        self.view.userInteractionEnabled = YES;
        return;
    }
    
    _newPassword = newPassword;
    
    if (_updatePasswordModel == nil) {
        _updatePasswordModel = [[GXUpdatePasswordModel alloc] init];
        _updatePasswordModel.delegate = self;
    }
    
    [_updatePasswordModel updatePassword:_newPassword];
}

- (void)updatePasswordSuccessful:(BOOL)successful
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
    }
    
    if (successful) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self alertWithMessage:@"修改密码失败 请重试"];
        self.view.userInteractionEnabled = YES;
    }
}

- (void)noNetwork
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
    }
    
    [self alertWithMessage:@"无法连接服务器..."];
    
    self.view.userInteractionEnabled = YES;
}

- (void)alertWithMessage:(NSString *)message
{
    [zkeyViewHelper alertWithMessage:message inView:self.view withFrame:self.view.frame];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


@end
