//
//  GXDeviceAuthorizedUserListViewController.m
//  GXSmartSlock
//
//  Created by zkey on 8/29/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXDeviceAuthorizedUserListViewController.h"

#import "MICRO_COMMON.h"

#import "GXAuthorizedUserTableViewCellDataModel.h"
#import "GXDatabaseHelper.h"
#import "GXDatabaseEntityDeviceUserMappingItem.h"
#import "GXDatabaseEntityUser.h"

#import "GXAuthorizedUserTableView.h"

#import <CoreData/CoreData.h>

@interface GXDeviceAuthorizedUserListViewController () <zkeyTableViewWithPullFreshDataSource, zkeyTableViewWithPullFreshDelegate>
{
    
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
    
    [self addDatasource];
    [self addUserListTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
}

- (void)configNavigationBar
{
    self.title = @"授权用户";
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUser)];
}

- (void)addDatasource
{
    _fetchedResultsController = [GXDatabaseHelper deviceUserMappingModelFetchedResultsController:self.deviceIdentifire];
}

- (void)addUserListTableView:(CGRect)frame
{
    _tableView = [[GXAuthorizedUserTableView alloc] initWithFrame:frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableView.separatorInset = UIEdgeInsetsMake(0, 80.0f, 0, 0);
    
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
    
    return cellData;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(zkeyTableViewWithPullFresh *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableViewRequestNewData:(zkeyTableViewWithPullFresh *)tableView
{
    [tableView didEndLoadingData];
}

#pragma mark - user action

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
@end
