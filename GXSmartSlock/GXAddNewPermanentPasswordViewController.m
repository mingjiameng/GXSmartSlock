//
//  GXAddNewPermanentPasswordViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/12/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXAddNewPermanentPasswordViewController.h"

#import "MICRO_COMMON.h"

#import "zkeyViewHelper.h"


@interface GXAddNewPermanentPasswordViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    UITextField *_passwordNicknameTextField;
    UITextField *_passwordTextField;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GXAddNewPermanentPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configNavigationBar];
    [self addTextFieldTableView];
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"添加常用密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddNewPassword)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAddNewPassword)];
}

- (void)addTextFieldTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
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
        cell.textLabel.text = @"密码昵称";
        
        // 密码1输入框
        _passwordNicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width - 110.0f, 30.0f)];
        _passwordNicknameTextField.keyboardType = UIKeyboardTypeDefault;
        _passwordNicknameTextField.borderStyle = UITextBorderStyleNone;
        _passwordNicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordNicknameTextField.returnKeyType = UIReturnKeyDone;
        _passwordNicknameTextField.placeholder = @"8-20位数字和字母";
        _passwordNicknameTextField.delegate = self;
        cell.accessoryView = _passwordNicknameTextField;
    } else if (indexPath.row == 1) {
        // 密码2输入框
        cell.textLabel.text = @"密码";
        
        // 昵称输入框
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width - 110.0f, 30.0f)];
        _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.returnKeyType = UIReturnKeyDone;
        _passwordTextField.placeholder = @"6位数字";
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
        cell.accessoryView = _passwordTextField;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)doneAddNewPassword
{
    NSString *passwordNickname = _passwordNicknameTextField.text;
    if (passwordNickname.length <= 0) {
        [self alertWithMessage:@"密码昵称不能为空"];
        return;
    }
    
    const char *charString = [passwordNickname UTF8String];
    if (strlen(charString) > 12) {
        [self alertWithMessage:@"密码昵称至多为4个汉字或12位字母"];
        return;
    }
    
    NSString *password = _passwordTextField.text;
    if (password.length != 6) {
        [self alertWithMessage:@"密码必须为6位数字"];
        return;
    }
    
    GXDevicePermanentPsswordModel *passwordModel = [[GXDevicePermanentPsswordModel alloc] init];
    passwordModel.nickname = passwordNickname;
    passwordModel.password = password;
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.addNewPassword) {
            self.addNewPassword(passwordModel);
        }
    }];
    
}

- (void)cancelAddNewPassword
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
