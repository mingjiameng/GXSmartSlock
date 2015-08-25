//
//  GXDeviceListViewController.m
//  GXSmartSlock
//
//  Created by zkey on 8/25/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXDeviceListViewController.h"

#import "MICRO_COMMON.h"
#import "MICRO_DEVICE_LIST.h"

#import "GXDatabaseHelper.h"
#import "GXDatabaseEntityDevice.h"
#import "GXDeviceListTableViewCellDataModel.h"

#import "GXDeviceListTableView.h"

#import <CoreData/CoreData.h>

@interface GXDeviceListViewController () <zkeyTableViewWithPullFreshDataSource, zkeyTableViewWithPullFreshDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) GXDeviceListTableView *deviceListTableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation GXDeviceListViewController

@synthesize deviceListTableView = _deviceListTableView;
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something...
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBar];
    [self addDeviceListDataSource];
    [self addDeviceList:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
    
}

- (void)configNavigationBar
{
    self.title = @"我的门锁";
}

- (void)addDeviceList:(CGRect)frame
{
    _deviceListTableView = [[GXDeviceListTableView alloc] initWithFrame:frame];
    _deviceListTableView.dataSource = self;
    _deviceListTableView.delegate = self;
    
    [self.view addSubview:_deviceListTableView];
}

- (void)addDeviceListDataSource
{
    _fetchedResultsController = [GXDatabaseHelper allDeviceFetchedResultsController];
    _fetchedResultsController.delegate = self;
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(zkeyTableViewWithPullFresh *)tableView
{
    if (_fetchedResultsController == nil) {
        return 0;
    }
    
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(zkeyTableViewWithPullFresh *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSObject *)tableView:(zkeyTableViewWithPullFresh *)tableView cellDataForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXDatabaseEntityDevice *deviceEntity = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    //NSLog(@"%@", deviceEntity);
    
    GXDeviceListTableViewCellDataModel *cellData = [[GXDeviceListTableViewCellDataModel alloc] init];
    
    cellData.title = deviceEntity.deviceNickname;
    
    if ([deviceEntity.deviceStatus isEqualToString:DEVICE_STATUS_VALID]) {
        cellData.subtitle = @"普通用户";
        if ([deviceEntity.deviceAuthority isEqualToString:DEVICE_AUTHORITY_ADMIN]) {
            cellData.subtitle = @"管理员";
        } else if ([deviceEntity.deviceAuthority isEqualToString:DEVICE_AUTHORITY_NORMAL]) {
            cellData.subtitle = @"普通用户";
        } else {
            NSLog(@"error: invalid device authority:%@", deviceEntity.deviceAuthority);
        }
    } else if ([deviceEntity.deviceStatus isEqualToString:DEVICE_STATUS_INVALID]) {
        cellData.subtitle = @"等待接受";
    } else {
        NSLog(@"error: invalid device status");
    }
    
    cellData.deviceCategory = deviceEntity.deviceCategory;
    cellData.batteryLevel = [deviceEntity.deviceBattery integerValue];
    
    return cellData;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(zkeyTableViewWithPullFresh *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(zkeyTableViewWithPullFresh *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
