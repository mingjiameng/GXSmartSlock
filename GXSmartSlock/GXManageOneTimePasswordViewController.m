//
//  GXManageOneTimePasswordViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/24/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXManageOneTimePasswordViewController.h"

#import "GXDatabaseHelper.h"
#import "GXOneTimePasswordTableViewCellDataModel.h"
#import "GXDatabaseEntityOneTimePassword.h"

#import "GXOneTimePasswordTableView.h"

#import <CoreData/CoreData.h>

@interface GXManageOneTimePasswordViewController () <zkeyTableViewWithPullFreshDataSource, zkeyTableViewWithPullFreshDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) GXOneTimePasswordTableView *passwordTableView;
@property (nonatomic, strong) NSFetchedResultsController *passwordFetchedResultsController;

@end

@implementation GXManageOneTimePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"临时密码";
    
    [self.view addSubview:self.passwordTableView];
}




#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(zkeyTableViewWithPullFresh *)tableView
{
    if (self.passwordFetchedResultsController) {
        return [[self.passwordFetchedResultsController sections] count];
    }
    
    return 0;
}

- (NSInteger)tableView:(zkeyTableViewWithPullFresh *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.passwordFetchedResultsController) {
        return [[[self.passwordFetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    }
    
    return 0;
}

- (NSObject *)tableView:(zkeyTableViewWithPullFresh *)tableView cellDataForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXOneTimePasswordTableViewCellDataModel *cellData = [[GXOneTimePasswordTableViewCellDataModel alloc] init];
    GXDatabaseEntityOneTimePassword *passwordEntity = [self.passwordFetchedResultsController objectAtIndexPath:indexPath];
    
    cellData.password = passwordEntity.password;
    
    return cellData;
}


#pragma mark - view

- (GXOneTimePasswordTableView *)passwordTableView
{
    if (!_passwordTableView) {
        CGRect frame = self.view.frame;
        _passwordTableView = ({
            GXOneTimePasswordTableView *tableView = [[GXOneTimePasswordTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            tableView.delegate = self;
            tableView.dataSource = self;
            
            tableView;
        });
    }
    
    return _passwordTableView;
}

- (NSFetchedResultsController *)passwordFetchedResultsController
{
    if (!_passwordFetchedResultsController) {
        _passwordFetchedResultsController = ({
            NSFetchedResultsController *fetchedResultsController = [GXDatabaseHelper oneTimePasswordFetchedResultsControllerOfDevice:self.deviceIdentifire];
            
            fetchedResultsController;
        });
    }
    
    return _passwordFetchedResultsController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
