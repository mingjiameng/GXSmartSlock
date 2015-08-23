//
//  GXRegisterSecondViewController.m
//  FenHongForIOS
//
//  Created by zkey on 8/5/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "GXRegisterSecondViewController.h"

#import "MICRO_COMMON.h"

#import "zkeyViewHelper.h"

#import "FHRegisterThirdViewController.h"

@interface GXRegisterSecondViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITextField *_nicknameTextField;
    UIButton *_nextStepButton;
    
    UITableView *_tableView;
}
@end

@implementation GXRegisterSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    [self configNavigationBar];
    [self addTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"昵称";
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.textLabel.text = @"昵称";
    
    // 昵称输入框
    _nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width - 100.0f, 30.0)];
    _nicknameTextField.keyboardType = UIKeyboardTypeDefault;
    _nicknameTextField.borderStyle = UITextBorderStyleNone;
    _nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nicknameTextField.returnKeyType = UIReturnKeyDone;
    _nicknameTextField.placeholder = @"2-14个字符";
    _nicknameTextField.delegate = self;
    cell.accessoryView = _nicknameTextField;
    
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
    
    NSString *nickname = _nicknameTextField.text;
    if (nickname.length <= 0) {
        [self alertWithMessage:@"请输入昵称"];
        return;
    }
    
    FHRegisterThirdViewController *registerThirdVC = [[FHRegisterThirdViewController alloc] init];
    registerThirdVC.userName = self.userName;
    registerThirdVC.validityCode = self.validityCode;
    registerThirdVC.nickname = nickname;
    registerThirdVC.viewType = self.viewType;
    
    [self.navigationController pushViewController:registerThirdVC animated:YES];
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
