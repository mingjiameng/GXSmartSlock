//
//  GXEnterAndSelectUserViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/6/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXEnterAndSelectUserViewController.h"

#import "MICRO_COMMON.h"


@interface GXEnterAndSelectUserViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation GXEnterAndSelectUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something...
    
    [self addUserListTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)configNavigationBar
{
    self.title = @"发送给";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUser)];
}

- (void)addUserListTableView:(CGRect)frame
{
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
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
    return self.userNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView:@"userName"];
    if (cell == nil) {
        cell = [UITableViewCell alloc] initWithStyle:uitableiv reuseIdentifier:<#(NSString *)#>
    }
}

#pragma mark - table view delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.userNameArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

#pragma mark - add user
- (void)addUser
{
    UIActionSheet *addUserActionSheet = [[UIActionSheet alloc] initWithTitle:@"输入用户名或从通讯录中批量导入" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"输入对方用户名", @"从通讯录批量导入", nil];
    addUserActionSheet.tag = 10086;
    [addUserActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 10086) {
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            return;
        }
        
        if (buttonIndex == 0) {
            
        } else if (buttonIndex == 1) {
            
        }
    
    }
}


@end
