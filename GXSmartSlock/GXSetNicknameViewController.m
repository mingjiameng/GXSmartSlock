//
//  GXSetNicknameViewController.m
//  GXSmartSlock
//
//  Created by zkey on 8/31/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSetNicknameViewController.h"

#import "MICRO_COMMON.h"

#import "GXDatabaseEntityUser.h"
#import "GXDatabaseHelper.h"
#import "GXUpdateNicknameModel.h"

#import "zkeyViewHelper.h"
#import "zkeyActivityIndicatorView.h"

@interface GXSetNicknameViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GXUpdateNicknameModelDelegate>
{
    UIBarButtonItem *_doneBarButtonItem;
    UITextField *_nicknameTextField;
    zkeyActivityIndicatorView *_activityIndicator;
    GXUpdateNicknameModel *_updateNicknameModel;
    
}
@property (nonatomic, strong) UITableView *tableView;

@end



@implementation GXSetNicknameViewController

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
    self.title = @"设置昵称";
    
    _doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updateNickname:)];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.textLabel.text = @"昵称";
    
    _nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width - 110.0f, 30.0)];
    _nicknameTextField.borderStyle = UITextBorderStyleNone;
    _nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nicknameTextField.returnKeyType = UIReturnKeyDone;
    _nicknameTextField.placeholder = @"2-10位中英文字符";
    _nicknameTextField.text = [self defaultUserNickname];
    _nicknameTextField.delegate = self;
    cell.accessoryView = _nicknameTextField;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSString *)defaultUserNickname
{
    GXDatabaseEntityUser *defaultUser = [GXDatabaseHelper defaultUser];
    return defaultUser.nickname;
}



#pragma mark - user action
- (void)updateNickname:(UIBarButtonItem *)sender
{
    [_nicknameTextField resignFirstResponder];
    
    NSString *nickname = _nicknameTextField.text;
    if (nickname.length <= 0) {
        [self alertWithMessage:@"请出入昵称"];
        return;
    }
    
    if (nickname.length > 18) {
        [self alertWithMessage:@"昵称长度应小于18"];
        return;
    }
    
    _doneBarButtonItem.enabled = NO;
    
    if (_updateNicknameModel == nil) {
        _updateNicknameModel = [[GXUpdateNicknameModel alloc] init];
        _updateNicknameModel.delegate = self;
    }
    
    if (_activityIndicator == nil) {
        _activityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.view.bounds title:@"正在更改昵称..."];
    }
    
    [self.view addSubview:_activityIndicator];
    
    [_updateNicknameModel updateNickname:nickname];
}

- (void)noNetwork
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
    }
    
    [self alertWithMessage:@"无法连接服务器..."];
    
    _doneBarButtonItem.enabled = YES;
}

- (void)updateNicknameSuccessful:(BOOL)successful
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
    }
    
    if (successful) {
        if (self.defaultUserNicknameChanged) {
            self.defaultUserNicknameChanged(YES);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self alertWithMessage:@"昵称更新失败 请重试"];
        
        _doneBarButtonItem.enabled = YES;
    }
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
