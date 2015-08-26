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

@interface GXDeviceDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleNameArray;

@end

@implementation GXDeviceDetailViewController

@synthesize tableView = _tableView;
@synthesize titleNameArray = _titleNameArray;

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
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.detailTextLabel.text = self.deviceEntity.deviceNickname;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSString *)cellTitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tmpArray = [_titleNameArray objectAtIndex:indexPath.section];
    
    return [tmpArray objectAtIndex:indexPath.row];
}

#pragma mark - table view delegate



@end
