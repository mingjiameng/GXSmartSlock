//
//  FHUserSetting+HandGestureSecretViewController.m
//  FenHongForIOS
//
//  Created by zkey on 8/6/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "FHUserSetting+HandGestureSecretViewController.h"

#import "MICRO_COMMON.h"

#import "FHGesturePasswordViewController.h"

@interface FHUserSetting_HandGestureSecretViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation FHUserSetting_HandGestureSecretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"手势密码";
    [self addTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addTableView:(CGRect)frame
{
    // table view
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self gesturePasswordExist]) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"手势密码";
        
        UISwitch *gestureSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 51, 31)];
        gestureSwitch.on = ([self gesturePasswordExist]) ? YES : NO;
        [gestureSwitch addTarget:self action:@selector(switchGesturePassword:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = gestureSwitch;
    } else {
        cell.textLabel.text = @"更改密码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return @"利用手势密码保护您的帐号安全。打开手势密码后，每次进入应用都需要绘制手势解锁。";
    } else if (section == 1) {
        return @"设定新的手势密码";
    }
    
    return nil;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        // 更改手势密码
        FHGesturePasswordViewController *gesturePasswordVC = [[FHGesturePasswordViewController alloc] init];
        gesturePasswordVC.viewType = GesturePasswordViewTypeReset;
        [self.navigationController presentViewController:gesturePasswordVC animated:YES completion:^{
            
        }];
    }
}




- (void)switchGesturePassword:(UISwitch *)sender
{
    GesturePasswordViewType viewType = GesturePasswordViewTypeClear;
    
    if ([self gesturePasswordExist]) {
        // 关闭手势密码
        viewType = GesturePasswordViewTypeClear;
    } else {
        // 打开手势密码
        viewType = GesturePasswordViewTypeSet;
    }
    
    FHGesturePasswordViewController *gesturePasswordVC = [[FHGesturePasswordViewController alloc] init];
    gesturePasswordVC.viewType = viewType;
    gesturePasswordVC.gesturePasswordChanged = ^(BOOL changed) {
        if (changed) {
            [_tableView reloadData];
        }
    };
    
    [self presentViewController:gesturePasswordVC animated:YES completion:^{
        
    }];
}

- (BOOL)gesturePasswordExist
{
    BOOL existGesturePassword = NO;
    
    NSString *gesturePassword = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_GESTURE_PASSWORD];
    if (gesturePassword != nil && gesturePassword.length > 0) {
        existGesturePassword = YES;
    }

    return existGesturePassword;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.tabBarController.tabBar setHidden:YES];
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
