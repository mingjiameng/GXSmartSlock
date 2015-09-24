//
//  GXAcceptKeyViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/4/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXAcceptKeyViewController.h"

#import "MICRO_COMMON.h"

#import "GXRejectKeyModel.h"
#import "GXReceiveKeyModel.h"

#import "zkeyViewHelper.h"

#import "zkeyActivityIndicatorView.h"

@interface GXAcceptKeyViewController () <UITableViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, GXRejectKeyModelDelegate, GXReceiveKeyModelDelegate>
{
    zkeyActivityIndicatorView *_activityIndicator;
    
    GXRejectKeyModel *_rejectKeyModel;
    GXReceiveKeyModel *_receiveKeyModel;

}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *nicknameTextField;

@end


@implementation GXAcceptKeyViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something ...
    
    [self configNavigationBar];
    [self addNicknameTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
}


- (void)configNavigationBar
{
    self.title = @"新的钥匙";
}

- (void)addNicknameTableView:(CGRect)frame
{
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 120.0f)];
    _tableView.tableFooterView = view;
    
    CGFloat leadingSpace = 15.0f;
    UIButton *rejectButton = [[UIButton alloc] initWithFrame:CGRectMake(leadingSpace, 20.0f, frame.size.width - 2 * leadingSpace, 40.0f)];
    [rejectButton setTitle:@"拒绝钥匙" forState:UIControlStateNormal];
    [rejectButton addTarget:self action:@selector(rejectKey:) forControlEvents:UIControlEventTouchUpInside];
    [rejectButton setBackgroundColor:[UIColor whiteColor]];
    rejectButton.layer.masksToBounds = YES;
    rejectButton.layer.cornerRadius = DEFAULT_ROUND_RECTANGLE_CORNER_RADIUS;
    [rejectButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [view addSubview:rejectButton];
    
    
    UIButton *acceptButton = [[UIButton alloc] initWithFrame:CGRectMake(leadingSpace, 70.0f, frame.size.width - 2 * leadingSpace, 40.0f)];
    [acceptButton setTitle:@"接受钥匙" forState:UIControlStateNormal];
    [acceptButton setBackgroundColor:[UIColor whiteColor]];
    [acceptButton addTarget:self action:@selector(acceptKey:) forControlEvents:UIControlEventTouchUpInside];
    acceptButton.layer.masksToBounds = YES;
    acceptButton.layer.cornerRadius = DEFAULT_ROUND_RECTANGLE_CORNER_RADIUS;
    [acceptButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    
    [view addSubview:acceptButton];
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
        _nicknameTextField.placeholder = @"2-10位中英字符";
        _nicknameTextField.text = self.defaultDeviceNickname;
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

- (void)acceptKey:(UIButton *)sender
{
    NSString *nickname = _nicknameTextField.text;
    
    if (nickname.length <= 0) {
        [self alertWithMessage:@"请输入门锁昵称"];
        return;
    }
    
    if (nickname.length < 2 || nickname.length > 10) {
        [self alertWithMessage:@"门锁昵称应为2-10位中英文字符"];
        return;
    }
    
    if (_activityIndicator == nil) {
        _activityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.view.frame title:@"正在处理中..."];
    }
    [self.view addSubview:_activityIndicator];
    
    if (_receiveKeyModel == nil) {
        _receiveKeyModel = [[GXReceiveKeyModel alloc] init];
        _receiveKeyModel.delegate = self;
    }
    
    [_receiveKeyModel receiveKey:self.deviceIdentifire deviceNickname:nickname];
}

- (void)rejectKey:(UIButton *)sender
{
    UIActionSheet *rejectActionSheet = [[UIActionSheet alloc] initWithTitle:@"确定拒绝钥匙？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拒绝" otherButtonTitles:nil];
    rejectActionSheet.tag = 10086;
    [rejectActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 10086) {
        if (buttonIndex != actionSheet.destructiveButtonIndex) {
            return;
        }

        self.view.userInteractionEnabled = NO;
        if (_activityIndicator == nil) {
            _activityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.view.frame title:@"正在处理中..."];
        }
        
        [self.view addSubview:_activityIndicator];
        
        if (_rejectKeyModel == nil) {
            _rejectKeyModel = [[GXRejectKeyModel alloc] init];
            _rejectKeyModel.delegate = self;
        }
        
        [_rejectKeyModel rejectKey:self.deviceIdentifire];
    }
    
    
}

#pragma mark - rejectKeyModel delegate
- (void)noNetwork
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
    }
    
    [self alertWithMessage:@"无法连接服务器"];
    
    self.view.userInteractionEnabled = YES;
}

- (void)deviceHadBeenDelete
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
    }
    
    [self alertWithMessage:@"该门锁已被管理员删除"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rejectKeySuccessful:(BOOL)successful
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
    }
    
    if (successful) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self alertWithMessage:@"拒绝钥匙失败 请重试"];
        self.view.userInteractionEnabled = YES;
    }
    
}

- (void)receiveKeySuccessful:(BOOL)successful
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
    }
    
    if (successful) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self alertWithMessage:@"接收钥匙失败 请重试"];
        self.view.userInteractionEnabled = YES;
    }
}

- (void)alertWithMessage:(NSString *)message
{
    [zkeyViewHelper alertWithMessage:message inView:self.view withFrame:self.view.frame];
}


@end
