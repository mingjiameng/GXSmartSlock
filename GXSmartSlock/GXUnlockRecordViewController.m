//
//  GXUnlockRecordViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/7/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXUnlockRecordViewController.h"

#import "MICRO_COMMON.h"

#import "GXDatabaseHelper.h"
#import "GXDatabaseEntityDevice.h"
#import "GXUnlockRecordTableViewCellData.h"

#import "GXUnlockRecordTableView.h"

#import "GXSelectValidDeviceViewController.h"

@interface GXUnlockRecordViewController () <zkeyTableViewWithPullFreshDataSource, zkeyTableViewWithPullFreshDelegate>
{
    UIButton *_selectUnlockModeButton;
    GXDatabaseEntityDevice *_selectedDeviceEntity;
}
@property (nonatomic, strong) GXUnlockRecordTableView *tableView;
@property (nonatomic, strong) NSArray *validDeviceArray;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end




@implementation GXUnlockRecordViewController

@synthesize validDeviceArray = _validDeviceArray;
@synthesize tableView = _tableView;
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something...
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self buildUI];
}

- (void)buildUI
{
    [self configNavigationBarTitleView];
    
    [self addUnlockRecordTableView];
    
    [self configDataSource];
}

- (void)configNavigationBarTitleView
{
    if (self.viewType == UnlockRecordViewTypeFromRootView) {
        _selectUnlockModeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 30.0f)];
        _selectUnlockModeButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [_selectUnlockModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectUnlockModeButton addTarget:self action:@selector(selectDevice) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.title = nil;
        self.navigationItem.titleView = _selectUnlockModeButton;
    } else if (self.viewType == UnlockRecordViewTypeFromDeviceDetailView) {
        self.title = @"开锁记录";
    }
}

- (NSString *)currentDeviceDescription
{
    if (_selectedDeviceEntity == nil) {
        return @"所有开锁记录";
    }
    
    return _selectedDeviceEntity.deviceNickname;
}

- (void)addUnlockRecordTableView
{
    if (self.viewType == UnlockRecordViewTypeFromRootView) {
        if (self.validDeviceArray.count <= 0) {
            [self addNoDeviceAlertLabel:CGRectMake(15.0f, 30.0f, self.view.frame.size.width - 30.0f, 60.0f)];
            return;
        }
    }
    
    _tableView = [[GXUnlockRecordTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

- (void)addNoDeviceAlertLabel:(CGRect)frame
{
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:frame];
    alertLabel.textColor = [UIColor lightGrayColor];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.numberOfLines = 2;
    alertLabel.text = @"您不是任何一把门锁的管理员\n无法向其他用户发送钥匙";
    
    [self.view addSubview:alertLabel];
    
}

- (void)configDataSource
{
    if (self.viewType == UnlockRecordViewTypeFromDeviceDetailView) {
        _fetchedResultsController = [GXDatabaseHelper unlockRecordOfDevice:self.deviceIdentifire];
    } else if (self.viewType == UnlockRecordViewTypeFromRootView) {
        _fetchedResultsController = [GXDatabaseHelper unlockRecordOfDevice:nil];
    }
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
    GXUnlockRecordTableViewCellData *cellData = [[GXUnlockRecordTableViewCellData alloc] init];
    
    return cellData;
}

#pragma mark - table view delegate
- (void)tableViewRequestNewData:(zkeyTableViewWithPullFresh *)tableView
{
    
}

- (void)selectDevice
{
    GXSelectValidDeviceViewController *selectValidDeviceVC = [[GXSelectValidDeviceViewController alloc] init];
    selectValidDeviceVC.viewType = SelectValidDeviceViewTypeUnlockRecord;
    selectValidDeviceVC.validDeviceArray = self.validDeviceArray;
    selectValidDeviceVC.deviceSelected = ^(GXDatabaseEntityDevice *selectedDevice){
        _selectedDeviceEntity = selectedDevice;
        [self reloadViewData];
    };
    
    UINavigationController *navigator = [[UINavigationController alloc] initWithRootViewController:selectValidDeviceVC];
    [self presentViewController:navigator animated:YES completion:^{
        
    }];
}

- (void)reloadViewData
{
    [_selectUnlockModeButton setTitle:[self currentDeviceDescription] forState:UIControlStateNormal];
    
    if (_selectedDeviceEntity == nil) {
        self.fetchedResultsController = [GXDatabaseHelper unlockRecordOfDevice:nil];
    } else {
        self.fetchedResultsController = [GXDatabaseHelper unlockRecordOfDevice:_selectedDeviceEntity.deviceIdentifire];
    }
    
    [_tableView.tableView reloadData];
}

- (NSArray *)validDeviceArray
{
    if (_validDeviceArray != nil) {
        return _validDeviceArray;
    }
    
    _validDeviceArray = [GXDatabaseHelper managedDeviceArray];
    
    return _validDeviceArray;
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

@end