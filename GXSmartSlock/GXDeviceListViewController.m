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
#import "GXSynchronizeDeviceModel.h"

#import "zkeyViewHelper.h"
#import "GXDeviceListTableView.h"
#import "GXDeviceDetailViewController.h"
#import "GXAcceptKeyViewController.h"

#import <CoreData/CoreData.h>

@interface GXDeviceListViewController () <zkeyTableViewWithPullFreshDataSource, zkeyTableViewWithPullFreshDelegate, NSFetchedResultsControllerDelegate, GXSynchronizeDeviceModel>
{
    GXSynchronizeDeviceModel *_synchronizeDeviceModel;
    
}

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
    self.title = @"设备列表";
}

- (void)addDeviceList:(CGRect)frame
{
    _deviceListTableView = [[GXDeviceListTableView alloc] initWithFrame:frame];
    _deviceListTableView.dataSource = self;
    _deviceListTableView.delegate = self;
    _deviceListTableView.tableView.separatorInset = UIEdgeInsetsMake(0, 85.0f, 0, 0);
    
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
    
    cellData.deviceIdentifire = deviceEntity.deviceIdentifire;
    
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
- (void)tableView:(zkeyTableViewWithPullFresh *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GXDatabaseEntityDevice *deviceEntity = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([deviceEntity.deviceStatus isEqualToString:DEVICE_STATUS_INVALID]) {
        GXAcceptKeyViewController *acceptKeyVC = [[GXAcceptKeyViewController alloc] init];
        acceptKeyVC.deviceIdentifire = deviceEntity.deviceIdentifire;
        acceptKeyVC.defaultDeviceNickname = deviceEntity.deviceNickname;
        [self.navigationController pushViewController:acceptKeyVC animated:YES];
        
    } else {
        GXDeviceDetailViewController *deviceDetailVC = [[GXDeviceDetailViewController alloc] init];
        deviceDetailVC.deviceEntity = deviceEntity;
        deviceDetailVC.deviceInformationChanged = ^(BOOL changed) {
            if (changed) {
                [tableView.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        };
        
        [self.navigationController pushViewController:deviceDetailVC animated:YES];
    }
    
}

- (void)tableViewRequestNewData:(zkeyTableViewWithPullFresh *)tableView
{
    if (_synchronizeDeviceModel == nil) {
        _synchronizeDeviceModel = [[GXSynchronizeDeviceModel alloc] init];
        _synchronizeDeviceModel.delegate = self;
    }
    
    [_synchronizeDeviceModel synchronizeDevice];
}

- (void)synchronizeDeviceSuccessful:(BOOL)successful
{
    [_deviceListTableView didEndLoadingData];
}

- (void)noNetwork
{
    [self alertWithMessage:@"无法连接服务器"];
    
    [_deviceListTableView didEndLoadingData];
}


- (void)alertWithMessage:(NSString *)message
{
    [zkeyViewHelper alertWithMessage:message inView:self.view withFrame:self.view.frame];
}


#pragma mark - database change
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.deviceListTableView.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    if (type == NSFetchedResultsChangeInsert) {
        [self.deviceListTableView.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                      withRowAnimation:UITableViewRowAnimationFade];
    } else if (type == NSFetchedResultsChangeDelete) {
        [self.deviceListTableView.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                      withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    UITableView *tableView = self.deviceListTableView.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            //让tableView在newIndexPath位置插入一个cell
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //让tableView刷新indexPath位置上的cell
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.deviceListTableView.tableView endUpdates];
}

@end
