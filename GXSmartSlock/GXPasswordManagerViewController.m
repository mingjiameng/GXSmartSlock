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

#import <CoreData/CoreData.h>

@interface GXPasswordManagerViewController () <zkeyTableViewWithPullFreshDataSource, zkeyTableViewWithPullFreshDelegate>

@property (nonatomic, strong) GXPasswordTableView *passwordTableView;
@property (nonatomic, strong) GXPasswordManagerModel *passwordManagerModel;

@end

@implementation GXPasswordManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavigationBar];
    
    [self.view addSubview:self.passwordTableView];
    
}

- (void)configNavigationBar
{
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:[self.passwordManagerModel availablePasswordTypeArray]];
    [segmentControl addTarget:self action:@selector(selectPasswordType:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentControl;
    
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
    
}

- (void)addPassword
{
    
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            
            manager;
        });
    }
    
    return _passwordManagerModel;
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
