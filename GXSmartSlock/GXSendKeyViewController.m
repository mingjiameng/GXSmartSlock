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

#import "GXSelectDeviceTableViewCell.h"

#import "GXSelectValidDeviceViewController.h"

@interface GXSendKeyViewController () <UITableViewDataSource, UITableViewDelegate>
{
    GXDatabaseEntityDevice *_selectedDeviceEntity;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UISwitch *adminAuthoritySwitch;
@end



@implementation GXSendKeyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something...
    
    [self buildUI];
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
    _alertLabel.text = @"您不是任何一把门锁的管理员\n无法向其他用户发送钥匙";
    
    [self.view addSubview:_alertLabel];
    
    
}

- (void)addSendKeyTableView:(CGRect)frame
{
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
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
    } else if (indexPath.section == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        
        cell.textLabel.text = @"门锁";
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
    } else {
        NSLog(@"error: invalid device category");
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
        selectDeviceVC.deviceSelected = ^(GXDatabaseEntityDevice *device) {
            _selectedDeviceEntity = device;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
    } else if (indexPath.section == 1) {
        
    }
}

@end
