//
//  GXDeviceDetailViewController.m
//  GXSmartSlock
//
//  Created by zkey on 8/26/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXDeviceDetailViewController.h"

#import "MICRO_COMMON.h"
#import "MICRO_DEVICE_LIST.h"

#import "GXDatabaseEntityDevice.h"
#import "zkeySandboxHelper.h"

#import "GXChangeDeviceImageViewController.h"

@interface GXDeviceDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleNameArray;
@property (nonatomic, strong) UIButton *deleteDeviceButton;

@end

@implementation GXDeviceDetailViewController

@synthesize tableView = _tableView;
@synthesize titleNameArray = _titleNameArray;
@synthesize deleteDeviceButton = _deleteDeviceButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something
    
    [self configNavigationBar];
    [self addDeviceDetailTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
}

- (void)configNavigationBar
{
    self.title = @"门锁详情";
}

- (void)addDeviceDetailTableView:(CGRect)frame
{
    _titleNameArray = @[ @[@"门锁图片", @"门锁昵称"], @[@"授权用户", @"开锁记录"], @[@"常用密码管理", @"临时密码管理"], @[@"固件升级"] ];
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 80.0f)];
    _tableView.tableFooterView = view;
    
    _deleteDeviceButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, 25.0f, frame.size.width - 40.0f, 40.0f)];
    [_deleteDeviceButton setBackgroundColor:[UIColor redColor]];
    [_deleteDeviceButton setTitle:@"删除门锁" forState:UIControlStateNormal];
    [_deleteDeviceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deleteDeviceButton addTarget:self action:@selector(deleteDevice:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_deleteDeviceButton];

}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.deviceEntity.deviceAuthority isEqualToString:DEVICE_AUTHORITY_ADMIN]) {
        return 4;
    } else {
        return 1;
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1 || section == 2) {
        return 2;
    } else if (section == 3){
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    cell.textLabel.text = [self cellTitleForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        CGFloat imageViewSize = 60.0f;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewSize, imageViewSize)];
        
        imageView.image = [self deviceImage];
        cell.accessoryView = imageView;
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.detailTextLabel.text = self.deviceEntity.deviceNickname;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIImage *)deviceImage
{
    NSString *deviceImageFilePath = [NSString stringWithFormat:@"%@/%@.png", [zkeySandboxHelper pathOfDocuments], self.deviceEntity.deviceIdentifire];
    
    UIImage *image = nil;
    if ([zkeySandboxHelper fileExitAtPath:deviceImageFilePath]) {
        image = [UIImage imageWithContentsOfFile:deviceImageFilePath];
    } else {
        image = [UIImage imageNamed:[self deviceImageNameAccordingDeviceCategory]];
    }
    
    return image;
}

- (NSString *)deviceImageNameAccordingDeviceCategory
{
    NSString *deviceCategory = self.deviceEntity.deviceCategory;
    if ([deviceCategory isEqualToString:DEVICE_CATEGORY_DEFAULT]) {
        return DEVICE_CATEGORY_DEFAULT_IMG;
    } else if ([deviceCategory isEqualToString:DEVICE_CATEGORY_ELECTRIC]) {
        return DEVICE_CATEGORY_ELECTRIC_IMG;
    } else if ([deviceCategory isEqualToString:DEVICE_CATEGORY_GUARD]) {
        return DEVICE_CATEGORY_GUARD_IMG;
    } else {
        NSLog(@"error: invalid device category");
    }
    
    return DEVICE_CATEGORY_DEFAULT_IMG;
}

- (NSString *)cellTitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tmpArray = [_titleNameArray objectAtIndex:indexPath.section];
    
    return [tmpArray objectAtIndex:indexPath.row];
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80.0f;
    }
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            GXChangeDeviceImageViewController *changeDeviceImageVC = [[GXChangeDeviceImageViewController alloc] init];
            changeDeviceImageVC.deviceEntity = self.deviceEntity;
            changeDeviceImageVC.deviceImageChanged = ^(BOOL changed) {
                if (changed) {
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    if (self.deviceInformationChanged) {
                        self.deviceInformationChanged(YES);
                    }
                }
            };
            
            [self.navigationController pushViewController:changeDeviceImageVC animated:YES];
        }
        
    }
}

#pragma mark - user action
- (void)deleteDevice:(UIButton *)sender
{
    
}

@end
