//
//  GXSendKeyViewController.m
//  GXSmartSlock
//
//  Created by zkey on 8/26/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSendKeyViewController.h"

#import "MICRO_COMMON.h"
#import "MICRO_DEVICE_LIST.h"

#import "zkeySandboxHelper.h"

#import "GXDatabaseEntityDevice.h"
#import "GXDatabaseHelper.h"
#import "GXSendKeyModel.h"

#import "GXSelectDeviceTableViewCell.h"
#import "zkeyActivityIndicatorView.h"
#import "zkeyViewHelper.h"

#import "GXSelectValidDeviceViewController.h"
#import "GXEnterAndSelectUserViewController.h"

@interface GXSendKeyViewController () <UITableViewDataSource, UITableViewDelegate>
{
    GXDatabaseEntityDevice *_selectedDeviceEntity;
    NSMutableArray *_contactModelArray;
}

@property (nonatomic, strong) NSArray *validDeviceArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UISwitch *adminAuthoritySwitch;
@end

@implementation GXSendKeyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something...
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavigationBar];
    [self buildUI];
}

- (void)configNavigationBar
{
    self.title = @"发送钥匙";
}

- (void)buildUI
{
    if (self.validDeviceArray.count <= 0) {
        [self addNoDeviceAlertLabel:CGRectMake(15.0f, 30.0f, self.view.frame.size.width - 30.0f, 60.0f)];
    } else {
        [self addSendKeyTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
    }
}

- (void)addNoDeviceAlertLabel:(CGRect)frame
{
    _alertLabel = [[UILabel alloc] initWithFrame:frame];
    _alertLabel.textColor = [UIColor lightGrayColor];
    _alertLabel.textAlignment = NSTextAlignmentCenter;
    _alertLabel.numberOfLines = 2;
    _alertLabel.text = @"您不是任何设备的管理员\n无法向其他用户发送钥匙";
    
    [self.view addSubview:_alertLabel];
}

- (void)addSendKeyTableView:(CGRect)frame
{
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 80.0f)];
    _tableView.tableFooterView = view;
    
    UIButton *sendKeyButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, 25.0f, frame.size.width - 40.0f, 40.0f)];
    sendKeyButton.layer.masksToBounds = YES;
    sendKeyButton.layer.cornerRadius = DEFAULT_ROUND_RECTANGLE_CORNER_RADIUS;
    [sendKeyButton setBackgroundColor:MAIN_COLOR];
    [sendKeyButton setTitle:@"发送钥匙" forState:UIControlStateNormal];
    [sendKeyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendKeyButton addTarget:self action:@selector(sendKey) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sendKeyButton];

}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [[GXSelectDeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        if (_selectedDeviceEntity == nil) {
            _selectedDeviceEntity = [self.validDeviceArray objectAtIndex:0];
        }
        
        cell.imageView.image = [self deviceImageNameAccordingDeviceCategory:_selectedDeviceEntity.deviceCategory andDeviceIdentifire:_selectedDeviceEntity.deviceIdentifire];
        cell.textLabel.text = _selectedDeviceEntity.deviceNickname;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    } else if (indexPath.section == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        
        cell.textLabel.text = @"发送给";
        cell.detailTextLabel.text = @"?";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.textLabel.text = @"管理员权限";
        
        _adminAuthoritySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 51.0f, 31.0f)];
        _adminAuthoritySwitch.on = NO;
        cell.accessoryView = _adminAuthoritySwitch;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (UIImage *)deviceImageNameAccordingDeviceCategory:(NSString *)deviceCategory andDeviceIdentifire:(NSString *)deviceIdentifire
{
    NSString *deviceImageFilePath = [NSString stringWithFormat:@"%@/%@.png", [zkeySandboxHelper pathOfDocuments], deviceIdentifire];
    if ([zkeySandboxHelper fileExitAtPath:deviceImageFilePath]) {
        return [UIImage imageWithContentsOfFile:deviceImageFilePath];
    }
    
    NSString *imageName = nil;
    
    if ([deviceCategory isEqualToString:DEVICE_CATEGORY_DEFAULT]) {
        imageName = DEVICE_CATEGORY_DEFAULT_IMG;
    } else if ([deviceCategory isEqualToString:DEVICE_CATEGORY_ELECTRIC]) {
        imageName = DEVICE_CATEGORY_ELECTRIC_IMG;
    } else if ([deviceCategory isEqualToString:DEVICE_CATEGORY_GUARD]) {
        imageName = DEVICE_CATEGORY_GUARD_IMG;
    } else if ([deviceCategory isEqualToString:DEVICE_CATEGORY_IN_DOOR]) {
        imageName = DEVICE_CATEGORY_IN_DOOR_IMG;
    } else {
        NSLog(@"error: invalid device category:%@", deviceCategory);
    }
    
    return [UIImage imageNamed:imageName];
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60.0f;
    }
    
    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return @"选择要发送的门锁钥匙";
    } else if (section == 1) {
        return @"输入用户名\n或从通讯录中批量导入";
    } else if (section == 2) {
        return @"对方取得管理员权限后，可以查看该门锁的开锁记录、管理该门锁的授权用户、向其他用户发送该门锁的钥匙。请您慎重选择。";
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        GXSelectValidDeviceViewController *selectDeviceVC = [[GXSelectValidDeviceViewController alloc] init];
        selectDeviceVC.validDeviceArray = self.validDeviceArray;
        selectDeviceVC.viewType = SelectValidDeviceViewTypeSendKey;
        selectDeviceVC.deviceSelected = ^(GXDatabaseEntityDevice *device) {
            _selectedDeviceEntity = device;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        
        [self.navigationController pushViewController:selectDeviceVC animated:YES];
        
    } else if (indexPath.section == 1) {
        if (_contactModelArray == nil) {
            _contactModelArray = [NSMutableArray array];
        }
        
        GXEnterAndSelectUserViewController *buildUserVC = [[GXEnterAndSelectUserViewController alloc] init];
        buildUserVC.contactModelArray = _contactModelArray;
        [self.navigationController pushViewController:buildUserVC animated:YES];
    }
}

#pragma mark - user action
- (void)sendKey
{
    if (_contactModelArray == nil || _contactModelArray.count <= 0) {
        [self alertWithMessage:@"请选择或输入对方的用户名"];
        return;
    }
    
    zkeyActivityIndicatorView *activityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.view.frame title:@"正在发送钥匙..."];
    [self.view addSubview:activityIndicator];
    
    NSString *authorityStatus = DEVICE_AUTHORITY_NORMAL;
    if (_adminAuthoritySwitch.on) {
        authorityStatus = DEVICE_AUTHORITY_ADMIN;
    }
    
    __block NSArray *failedToSendArray = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        failedToSendArray = [GXSendKeyModel sendKey:_selectedDeviceEntity.deviceIdentifire to:_contactModelArray withAuthority:authorityStatus];
    });
    
    [activityIndicator removeFromSuperview];
    activityIndicator = nil;
    
    if (failedToSendArray.count > 0) {
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)alertWithMessage:(NSString *)message
{
    [zkeyViewHelper alertWithMessage:message inView:self.view withFrame:self.view.frame];
}


- (NSArray *)validDeviceArray
{
    if (_validDeviceArray == nil) {
        if (self.viewType == GXSendKeyViewTypeMutipleDevice) {
            _validDeviceArray = [GXDatabaseHelper managedDeviceArray];
        } else if (self.viewType == GXSendKeyViewTypeCertainDevice) {
            _validDeviceArray = @[[GXDatabaseHelper deviceEntityWithDeviceIdentifire:self.deviceIdentifire]];
        }
    }
    
    return _validDeviceArray;
}

@end
