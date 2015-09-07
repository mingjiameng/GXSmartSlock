//
//  GXEnterUserNameViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/6/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXEnterUserNameViewController.h"

#import "MICRO_COMMON.h"

#import "zkeyIdentifierValidator.h"
#import "GXContactModel.h"

#import "zkeyViewHelper.h"


@interface GXEnterUserNameViewController () <UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *userNameTextField;

@end



@implementation GXEnterUserNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something ...
    
    [self configNavigationBar];
    [self addUserNameTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
}

- (void)configNavigationBar
{
    self.title = @"添加用户";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddUser)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAddUser)];
}

- (void)addUserNameTableView:(CGRect)frame
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
        cell.textLabel.text = @"用户名";
        
        _userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width - 110.0f, 30.0)];
        _userNameTextField.borderStyle = UITextBorderStyleNone;
        _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _userNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _userNameTextField.returnKeyType = UIReturnKeyDone;
        _userNameTextField.placeholder = @"请输入对方的用户名";
        _userNameTextField.delegate = self;
        cell.accessoryView = _userNameTextField;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)doneAddUser
{
    [_userNameTextField resignFirstResponder];
    
    NSString *userName = _userNameTextField.text;
    if (![zkeyIdentifierValidator isValidChinesePhoneNumber:userName] && ![zkeyIdentifierValidator isValidEmailAddress:userName]) {
        [self alertWithMessage:@"请输入正确的用户名"];
        return;
    }
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.addContact) {
            GXContactModel *contactModel = [GXContactModel modelWithUserName:userName nickname:userName];
            self.addContact(contactModel);
        }
    }];
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

- (void)cancelAddUser
{
    [_userNameTextField resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end

