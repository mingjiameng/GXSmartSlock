//
//  GXUserSettingViewController.m
//  GXSmartSlock
//
//  Created by zkey on 8/31/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXUserSettingViewController.h"

#import "MICRO_COMMON.h"

#import "UIImageView+FHProfileDownload.h"

#import "GXDatabaseHelper.h"
#import "GXDatabaseEntityUser.h"
#import "GXLogoutModel.h"

#import "GXLoginViewController.h"
#import "GXSetProfileImageViewController.h"
#import "GXSetNicknameViewController.h"
#import "FHUserSetting+HandGestureSecretViewController.h"
#import "GXSetPasswordViewController.h"

@interface GXUserSettingViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableViewCellTitleArray;

@end

@implementation GXUserSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something...
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavigationBar];
    
    [self addUserSettingTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"用户设置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissVC)];
}

- (void)addUserSettingTableView:(CGRect)frame
{
    _tableViewCellTitleArray = @[ @[@"头像", @"帐号", @"昵称"], @[@"账户密码", @"手势密码"] ];
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 80.0f)];
    _tableView.tableFooterView = view;
    
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, 25.0f, frame.size.width - 40.0f, 40.0f)];
    [logoutButton setBackgroundColor:[UIColor redColor]];
    [logoutButton setTitle:@"登出" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(clickLogoutButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:logoutButton];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_tableViewCellTitleArray != nil) {
        return [_tableViewCellTitleArray count];
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableViewCellTitleArray != nil) {
        NSArray *tmpArray = [_tableViewCellTitleArray objectAtIndex:section];
        return [tmpArray count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    NSArray *tmpArray = [_tableViewCellTitleArray objectAtIndex:indexPath.section];
    
    cell.textLabel.text = (NSString *)[tmpArray objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50.0f, 50.0f)];
            [self setHeadImage:headImageView];
            cell.accessoryView = headImageView;
        } else if (indexPath.row == 1) {
            cell.detailTextLabel.text = [self defaultUserName];
        } else if (indexPath.row == 2) {
            cell.detailTextLabel.text = [self defaultUserNickname];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"立即更改";
        } else if (indexPath.row == 1) {
            cell.detailTextLabel.text = @"立即设置";
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)setHeadImage:(UIImageView *)imageView
{
    UIImage *placeHolderImage = [UIImage imageNamed:@"defaultUserHeadImage"];
    
    GXDatabaseEntityUser *defaultUser = [GXDatabaseHelper defaultUser];
    
    [imageView setProfileWithUrlString:defaultUser.headImageURL placeholderImage:placeHolderImage];
}

- (NSString *)defaultUserName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
}

- (NSString *)defaultUserNickname
{
    GXDatabaseEntityUser *defaultUser = [GXDatabaseHelper defaultUser];
    return defaultUser.nickname;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60.0f;
    }
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            GXSetProfileImageViewController *setProfileVC = [[GXSetProfileImageViewController alloc] init];
            setProfileVC.profileImageChanged = ^(BOOL changed) {
                if (changed) {
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            };
            
            [self.navigationController pushViewController:setProfileVC animated:YES];
        } else if (indexPath.row == 2) {
            GXSetNicknameViewController *setNicknameVC = [[GXSetNicknameViewController alloc] init];
            setNicknameVC.defaultUserNicknameChanged = ^(BOOL changed) {
                if (changed) {
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            };
            
            [self.navigationController pushViewController:setNicknameVC animated:YES];
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            GXSetPasswordViewController *setPasswordVC = [[GXSetPasswordViewController alloc] init];
            [self.navigationController pushViewController:setPasswordVC animated:YES];
        } else if (indexPath.row == 1) {
            FHUserSetting_HandGestureSecretViewController *gesturePasswordVC = [[FHUserSetting_HandGestureSecretViewController alloc] init];
            [self.navigationController pushViewController:gesturePasswordVC animated:YES];
        }
        
    }
}

#pragma mark - user action
- (void)clickLogoutButton:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"登出后当前账号的相关数据将会被清除，确定要登出吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"登出" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.destructiveButtonIndex) {
        return;
    }
    
    [GXLogoutModel logout];
    
    GXLoginViewController *loginVC = [[GXLoginViewController alloc] init];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.view.window.rootViewController = navigationVC;
    
}

- (void)dismissVC
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
