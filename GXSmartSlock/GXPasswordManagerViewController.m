//
//  GXPasswordManagerViewController.m
//  GXSmartSlock
//
//  Created by zkey on 10/18/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXPasswordManagerViewController.h"

#import "MICRO_COMMON.h"

#import "GXPasswordTableView.h"
#import "GXPasswordManagerModel.h"

#import "zkeyViewHelper.h"

#import <CoreData/CoreData.h>

@interface GXPasswordManagerViewController () <zkeyTableViewWithPullFreshDataSource, zkeyTableViewWithPullFreshDelegate, GXPasswordManagerModelDelegate>

@property (nonatomic, strong) GXPasswordTableView *passwordTableView;
@property (nonatomic, strong) GXPasswordManagerModel *passwordManagerModel;
@property (nonatomic, strong) UISegmentedControl *passwordTypeSegmentControl;

@end

@implementation GXPasswordManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavigationBar];
    
    [self.view addSubview:self.passwordTableView];
    
    [self.passwordTypeSegmentControl setSelectedSegmentIndex:0];
}

- (void)configNavigationBar
{
    self.navigationItem.titleView = self.passwordTypeSegmentControl;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPassword)];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(zkeyTableViewWithPullFresh *)tableView
{
    return [self.passwordManagerModel numberOfSectionsInTableView];
}

- (NSInteger)tableView:(zkeyTableViewWithPullFresh *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.passwordManagerModel numberOfRowsInSection:section];
}

- (NSObject *)tableView:(zkeyTableViewWithPullFresh *)tableView cellDataForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.passwordManagerModel cellDataForRowAtIndexPath:indexPath];
}

#pragma mark - table view delegate
- (void)tableView:(zkeyTableViewWithPullFresh *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableViewRequestNewData:(zkeyTableViewWithPullFresh *)tableView
{
    typeof(self) weakSelf = self;
    
    [self.passwordManagerModel synchronizeData:^(NSInteger status) {
        
    }];
}

#pragma mark - user action

- (void)selectPasswordType:(UISegmentedControl *)sender
{
    NSString *passwordType = [self.passwordTypeSegmentControl titleForSegmentAtIndex:sender.selectedSegmentIndex];
    
    [self.passwordManagerModel selectPasswordType:passwordType];
}

- (void)addPassword
{
    
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UISegmentedControl *)passwordTypeSegmentControl
{
    if (!_passwordTypeSegmentControl) {
        _passwordTypeSegmentControl = ({
            UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:[self.passwordManagerModel availablePasswordTypeArray]];
            
            [segmentControl addTarget:self action:@selector(selectPasswordType:) forControlEvents:UIControlEventValueChanged];
            
            segmentControl;
        });
    }
    
    return _passwordTypeSegmentControl;
}

- (GXPasswordTableView *)passwordTableView
{
    if (!_passwordTableView) {
        _passwordTableView = ({
            GXPasswordTableView *tableView = [[GXPasswordTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width - TOP_SPACE_IN_NAVIGATION_MODE)];
            
            tableView.delegate = self;
            tableView.dataSource = self;
            
            tableView;
        });
    }
    
    return _passwordTableView;
}

- (GXPasswordManagerModel *)passwordManagerModel
{
    if (!_passwordManagerModel) {
        _passwordManagerModel = ({
            GXPasswordManagerModel *manager = [[GXPasswordManagerModel alloc] init];
            
            manager.deviceModel = self.deviceModel;
            manager.delegate = self;
            
            manager;
        });
    }
    
    return _passwordManagerModel;
}

#pragma mark - delegate
- (void)beginUpdates
{
    [self.passwordTableView.tableView beginUpdates];
}

- (void)insertSection:(NSUInteger)sectionIndex
{
    [self.passwordTableView.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteSection:(NSUInteger)sectionIndex
{
    [self.passwordTableView.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.passwordTableView.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.passwordTableView.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.passwordTableView.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)endUpdates
{
    [self.passwordTableView.tableView endUpdates];
}

- (void)reloadTableView
{
    [self.passwordTableView.tableView reloadData];
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
