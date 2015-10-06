//
//  GXDeviceAuthorizedUserListViewController.m
//  GXSmartSlock
//
//  Created by zkey on 8/29/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXDeviceAuthorizedUserListViewController.h"

#import "MICRO_COMMON.h"
#import "MICRO_DEVICE_LIST.h"

#import "GXAuthorizedUserTableViewCellDataModel.h"
#import "GXDatabaseHelper.h"
#import "GXDatabaseEntityDeviceUserMappingItem.h"
#import "GXDatabaseEntityUser.h"
#import "GXDeleteAuthorizedUserModel.h"
#import "GXSynchronizeDeviceUserModel.h"

#import "GXAuthorizedUserTableView.h"
#import "zkeyViewHelper.h"
#import "zkeyActivityIndicatorView.h"

#import "GXChangeRemarkOfAuthorizedUserViewController.h"

#import <CoreData/CoreData.h>

@interface GXDeviceAuthorizedUserListViewController () <zkeyTableViewWithPullFreshDataSource, zkeyTableViewWithPullFreshDelegate, UIActionSheetDelegate, GXDeleteAuthorizedUserModelDelegate, GXSynchronizeDeviceUserModelDelegate, NSFetchedResultsControllerDelegate>
{
    NSIndexPath *_deletedIndexPath; // store the indexPath of GXDatabaseEntityDeviceUserMappingItem which need to deleted
    GXDeleteAuthorizedUserModel *_deleteUserModel;
    zkeyActivityIndicatorView *_activityIndicator;
    GXSynchronizeDeviceUserModel *_synchronizeDeviceUserModel;
    
    NSString *_defaultUserName;
    BOOL _dataSynchronized;
}

@property (nonatomic, strong) GXAuthorizedUserTableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation GXDeviceAuthorizedUserListViewController

@synthesize tableView = _tableView;
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something...
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSynchronized = NO;
    
    [self addDatasource];
    [self configNavigationBar];
    [self addUserListTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
}

- (void)configNavigationBar
{
    self.title = @"授权用户";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUser)];
}

- (void)addDatasource
{
    _fetchedResultsController = [GXDatabaseHelper deviceUserMappingModelFetchedResultsController:self.deviceIdentifire];
    _fetchedResultsController.delegate = self;
    
    _defaultUserName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
}

- (void)addUserListTableView:(CGRect)frame
{
    _tableView = [[GXAuthorizedUserTableView alloc] initWithFrame:frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableView.separatorInset = UIEdgeInsetsMake(0, 0.0f, 0, 0);
    
    [self.view addSubview:_tableView];
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
    if (_fetchedResultsController == nil) {
        return 0;
    }
    
    return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (NSObject *)tableView:(zkeyTableViewWithPullFresh *)tableView cellDataForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXAuthorizedUserTableViewCellDataModel *cellData = [[GXAuthorizedUserTableViewCellDataModel alloc] init];
    
    GXDatabaseEntityDeviceUserMappingItem *deviceUserMappingEntity = [_fetchedResultsController objectAtIndexPath:indexPath];
    GXDatabaseEntityUser *user = deviceUserMappingEntity.user;
    
    if (user == nil) {
        cellData.nickname = deviceUserMappingEntity.userName;
        cellData.profileImageURL = nil;
    } else {
        cellData.nickname = user.nickname;
        cellData.profileImageURL = user.headImageURL;
    }
    
    if ([deviceUserMappingEntity.deviceStatus isEqualToString:DEVICE_STATUS_INVALID]) {
        cellData.detailText = @"等待接受";
    } else {
        if ([deviceUserMappingEntity.deviceAuthority isEqualToString:DEVICE_AUTHORITY_ADMIN]) {
            cellData.detailText = @"管理员";
        } else if ([deviceUserMappingEntity.deviceAuthority isEqualToString:DEVICE_AUTHORITY_NORMAL]) {
            cellData.detailText = @"普通用户";
        }
    }
    
    return cellData;
}

#pragma mark - table view delegate
- (void)tableViewRequestNewData:(zkeyTableViewWithPullFresh *)tableView
{
    if (_synchronizeDeviceUserModel == nil) {
        _synchronizeDeviceUserModel = [[GXSynchronizeDeviceUserModel alloc] init];
        _synchronizeDeviceUserModel.delegate = self;
    }
    
    [_synchronizeDeviceUserModel synchronizeDeviceUser:self.deviceIdentifire];
}

- (void)tableView:(zkeyTableViewWithPullFresh *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // you can't deleate yourself
        GXDatabaseEntityDeviceUserMappingItem *deviceUserMappingEntity = [_fetchedResultsController objectAtIndexPath:indexPath];
        if ([deviceUserMappingEntity.user.userName isEqualToString:_defaultUserName]) {
            [self alertWithMessage:@"您不能删除自己"];
            return;
        }
        
        _deletedIndexPath = indexPath;
        UIActionSheet *deleteActionSheet = [[UIActionSheet alloc] initWithTitle:@"删除该授权用户后，该用户将无法打开对应的门锁，确定要删除该用户吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认删除" otherButtonTitles:nil];
        [deleteActionSheet showInView:self.view];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        GXDatabaseEntityDeviceUserMappingItem *deviceUserMappingEntity = [_fetchedResultsController objectAtIndexPath:indexPath];
        GXDatabaseEntityUser *user = deviceUserMappingEntity.user;
        
        GXChangeRemarkOfAuthorizedUserViewController *changeRemarkVC = [[GXChangeRemarkOfAuthorizedUserViewController alloc] init];
        changeRemarkVC.remarkName = user.remarkName;
    }
    
}

- (void)synchronizeDeviceUserSuccessful:(BOOL)successful
{
    [_tableView didEndLoadingData];
}
#pragma mark - user action

// delete user
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.destructiveButtonIndex) {
        return;
    }
    
    self.view.userInteractionEnabled = NO;
    
    if (_activityIndicator == nil) {
        _activityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.view.frame title:@"正在删除用户..."];
    }
    [self.view addSubview:_activityIndicator];
    
    GXDatabaseEntityDeviceUserMappingItem *deviceUserMappingEntity = [self.fetchedResultsController objectAtIndexPath:_deletedIndexPath];
    
    if (_deleteUserModel == nil) {
        _deleteUserModel = [[GXDeleteAuthorizedUserModel alloc] init];
        _deleteUserModel.delegate = self;
    }
    
    [_deleteUserModel deleteUser:deviceUserMappingEntity.userName fromDevice:deviceUserMappingEntity.deviceIdentifire];
}

- (void)deleteAuthorizedUserSuccessful:(BOOL)successful
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
    }
    
    if (successful) {
        [self alertWithMessage:@"成功删除用户"];
    } else {
        [self alertWithMessage:@"删除用户失败 请重试"];
    }
    
    self.view.userInteractionEnabled = YES;
}

- (void)noNetwork
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
    }
    
    [self alertWithMessage:@"无法连接服务器"];
    
    [_tableView didEndLoadingData];
    
    self.view.userInteractionEnabled = YES;
}

- (void)userHadBeenDeleted
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
    }
    
    [self alertWithMessage:@"该用户已被其他管理员删除"];
    self.view.userInteractionEnabled = YES;
}

- (void)alertWithMessage:(NSString *)message
{
    [zkeyViewHelper alertWithMessage:message inView:self.view withFrame:self.view.frame];
}

#pragma mark - database change
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                          withRowAnimation:UITableViewRowAnimationFade];
    } else if (type == NSFetchedResultsChangeDelete) {
        [self.tableView.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                          withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    UITableView *tableView = self.tableView.tableView;
    
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
    [self.tableView.tableView endUpdates];
}


// TODO
- (void)addUser
{
    
}

#pragma mark - 
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ...
    if (!_dataSynchronized) {
        if (self.tableView) {
            [self.tableView forceToRefresh];
        }
        
        _dataSynchronized = YES;
    }
}
@end
