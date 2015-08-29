//
//  GXChangeDeviceNicknameViewController.m
//  GXSmartSlock
//
//  Created by zkey on 8/27/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXChangeDeviceNicknameViewController.h"

#import "MICRO_COMMON.h"

#import "GXChangeDeviceNicknameModel.h"

#import "zkeyActivityIndicatorView.h"
#import "zkeyViewHelper.h"

@interface GXChangeDeviceNicknameViewController () <UITableViewDataSource, UITextFieldDelegate, GXChangeDeviceNicknameModelDelegate>
{
    GXChangeDeviceNicknameModel *_changeDeviceNicknameModel;
    zkeyActivityIndicatorView *_activityIndicator;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *nicknameTextField;
@property (nonatomic, strong) UIBarButtonItem *doneBarButtonItem;
@end

@implementation GXChangeDeviceNicknameViewController

@synthesize tableView = _tableView;
@synthesize nicknameTextField = _nicknameTextField;
@synthesize doneBarButtonItem = _doneBarButtonItem;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something ...
    
    [self configNavigationBar];
    [self addNicknameTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
}


- (void)configNavigationBar
{
    self.title = @"修改门锁昵称";
    
    _doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updateDeviceNickname:)];
    self.navigationItem.rightBarButtonItem = _doneBarButtonItem;
}

- (void)addNicknameTableView:(CGRect)frame
{
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    
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
    UITableViewCell *cell = nil;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"门锁昵称";
        
        _nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width - 110.0f, 30.0)];
        _nicknameTextField.borderStyle = UITextBorderStyleNone;
        _nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nicknameTextField.returnKeyType = UIReturnKeyDone;
        _nicknameTextField.placeholder = @"请输入门锁昵称";
        _nicknameTextField.text = self.deviceEntity.deviceNickname;
        _nicknameTextField.delegate = self;
        cell.accessoryView = _nicknameTextField;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)updateDeviceNickname:(UIBarButtonItem *)sender
{
    [_nicknameTextField resignFirstResponder];
    
    sender.enabled = NO;
    
    _activityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.view.frame title:@"正在更新门锁昵称..."];
    [self.view addSubview:_activityIndicator];
    
    NSString *deviceNickname = _nicknameTextField.text;
    
    if (_changeDeviceNicknameModel == nil) {
        _changeDeviceNicknameModel = [[GXChangeDeviceNicknameModel alloc] init];
        _changeDeviceNicknameModel.delegate = self;
    }
    
    [_changeDeviceNicknameModel changeDeviceName:self.deviceEntity.deviceIdentifire deviceNickname:deviceNickname];
}

- (void)changeDeviceNicknameSuccess:(BOOL)successful
{
    if (successful) {
        if (self.deviceNicknameChanged) {
            self.deviceNicknameChanged(YES);
        }
        
        if (_activityIndicator != nil) {
            [_activityIndicator removeFromSuperview];
        }
        _activityIndicator = nil;
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (_activityIndicator != nil) {
            [_activityIndicator removeFromSuperview];
        }
        
        [self alertWithMessage:@"更新昵称失败 请重新尝试"];
        _doneBarButtonItem.enabled = YES;
    }
}

- (void)noNetwork
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
    }
    
    [self alertWithMessage:@"无法连接服务器"];
    _doneBarButtonItem.enabled = YES;
}

- (void)deviceHasBeenDeleted
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
    }
    
    [self alertWithMessage:@"该门锁已被管理员删除"];
    _doneBarButtonItem.enabled = YES;
}

- (void)alertWithMessage:(NSString *)message
{
    [zkeyViewHelper alertWithMessage:message inView:self.view withFrame:self.view.frame];
}

@end
