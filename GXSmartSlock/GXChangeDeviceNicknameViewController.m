//
//  GXChangeDeviceNicknameViewController.m
//  GXSmartSlock
//
//  Created by zkey on 8/27/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXChangeDeviceNicknameViewController.h"

#import "MICRO_COMMON.h"

@interface GXChangeDeviceNicknameViewController () <UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *nicknameTextField;

@end

@implementation GXChangeDeviceNicknameViewController

@synthesize tableView = _tableView;

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updateDeviceNickname:)];
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
        _nicknameTextField.keyboardType = UIKeyboardTypeDecimalPad;
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
    return YES;
}

- (void)updateDeviceNickname:(UIBarButtonItem *)sender
{
    NSString *deviceNickname = _nicknameTextField.text;
    
    
}

@end
