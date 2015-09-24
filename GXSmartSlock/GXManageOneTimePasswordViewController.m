//
//  GXManageOneTimePasswordViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/24/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXManageOneTimePasswordViewController.h"

#import "MICRO_COMMON.h"

#import "GXDatabaseHelper.h"
#import "GXOneTimePasswordTableViewCellDataModel.h"
#import "GXDatabaseEntityOneTimePassword.h"
#import "zkeyShareContentToWeiXin.h"

#import "GXOneTimePasswordTableView.h"

#import "GXRefreshOneTimePasswordViewController.h"
#import "GXSynchronizeOneTimePasswordWithDeviceViewController.h"

#import <CoreData/CoreData.h>

#define ACTION_SHEET_PRODUCE_NEW_PASSWORD 10
#define ACTION_SHEET_ACTION 20

@interface GXManageOneTimePasswordViewController () <zkeyTableViewWithPullFreshDataSource, zkeyTableViewWithPullFreshDelegate, UIActionSheetDelegate, NSFetchedResultsControllerDelegate>
{
    NSIndexPath *_indexPathOfSelectedRow;
}
@property (nonatomic, strong) GXOneTimePasswordTableView *passwordTableView;
@property (nonatomic, strong) NSFetchedResultsController *passwordFetchedResultsController;
@property (nonatomic, strong) UIToolbar *passwordToolBar;
@property (nonatomic, strong) UIBarButtonItem *synchronizePasswordBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *refreshPasswordBarButtonItem;

@end

@implementation GXManageOneTimePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"临时密码";
    
    [self.view addSubview:self.passwordTableView];
    [self.view addSubview:self.passwordToolBar];
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
    if ([passwordEntity.validity boolValue]) {
        cellData.validityString = @"待使用";
    } else {
        cellData.validityString = @"已使用";
    }
    
    return cellData;
}

#pragma mark - table view delegate
- (void)tableView:(zkeyTableViewWithPullFresh *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GXDatabaseEntityOneTimePassword *passwordEntity = [self.passwordFetchedResultsController objectAtIndexPath:indexPath];
    
    _indexPathOfSelectedRow = indexPath;
    
    NSString *destructiveTitle = @"标记为已使用";
    if (![passwordEntity.validity boolValue]) {
        destructiveTitle = @"标记为未使用";
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:passwordEntity.password delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:destructiveTitle otherButtonTitles:@"复制到剪切版", @"分享给微信好友", nil];
    actionSheet.tag = ACTION_SHEET_ACTION;
    [actionSheet showInView:self.view];
}

- (void)tableView:(zkeyTableViewWithPullFresh *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // mark as used
        NSLog(@"mark as used");
        GXDatabaseEntityOneTimePassword *passwordEntity = [self.passwordFetchedResultsController objectAtIndexPath:indexPath];
        
        [GXDatabaseHelper device:passwordEntity.deviceIdentifire turnOneTimePassword:passwordEntity.password toState:NO];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ACTION_SHEET_ACTION) {
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            return;
        }
        
        GXDatabaseEntityOneTimePassword *passwordEntity = [self.passwordFetchedResultsController objectAtIndexPath:_indexPathOfSelectedRow];
        
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            BOOL reversedValidity = YES;
            if ([passwordEntity.validity boolValue]) {
                reversedValidity = NO;
            }
            
            [GXDatabaseHelper device:passwordEntity.deviceIdentifire turnOneTimePassword:passwordEntity.password toState:reversedValidity];
            return;
        }
        
        if (buttonIndex == 1) {
            // copy to click board
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = passwordEntity.password;
        } else if (buttonIndex == 2) {
            //  share to weixin
            [zkeyShareContentToWeiXin shareTextToWX:passwordEntity.password scene:WXSceneSession];
        }
        
        return;
    }
    
    if (actionSheet.tag == ACTION_SHEET_PRODUCE_NEW_PASSWORD) {
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            
        }
    }
    
    
}

#pragma mark - user action
- (void)synchronizePassword
{
    NSLog(@"同步密码");
    
    GXSynchronizeOneTimePasswordWithDeviceViewController *synchornizePasswordVC = [[GXSynchronizeOneTimePasswordWithDeviceViewController alloc] init];
    synchornizePasswordVC.deviceIdentifire = self.deviceIdentifire;
    
}


// produce a new set of password
- (void)refreshPassword
{
    //NSLog(@"生成新密码");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"生成临时密码后, 之前的临时密码会失效, 确定要生成临时密码吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"生成新密码" otherButtonTitles:nil];
    actionSheet.tag = ACTION_SHEET_PRODUCE_NEW_PASSWORD;
    [actionSheet showInView:self.view];
}

#pragma mark - view

- (GXOneTimePasswordTableView *)passwordTableView
{
    if (!_passwordTableView) {
        CGRect frame = self.view.frame;
        _passwordTableView = ({
            GXOneTimePasswordTableView *tableView = [[GXOneTimePasswordTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE - 44.0f)];
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
            fetchedResultsController.delegate = self;
            
            fetchedResultsController;
        });
    }
    
    return _passwordFetchedResultsController;
}

- (UIToolbar *)passwordToolBar
{
    if (!_passwordToolBar) {
        CGRect frame = self.view.frame;
        _passwordToolBar = ({
            UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE - 44.0f, frame.size.width, 44.0f)];
            
            UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [toolBar setItems:@[self.synchronizePasswordBarButtonItem, flexibleItem, self.refreshPasswordBarButtonItem]];
            
            toolBar;
        });
    }
    
    return _passwordToolBar;
}

- (UIBarButtonItem *)synchronizePasswordBarButtonItem
{
    if (!_synchronizePasswordBarButtonItem) {
        _synchronizePasswordBarButtonItem = ({
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"同步临时密码" style:UIBarButtonItemStylePlain target:self action:@selector(synchronizePassword)];
            item.tintColor = MAIN_COLOR;
            
            item;
        });
    }
    
    return _synchronizePasswordBarButtonItem;
}

- (UIBarButtonItem *)refreshPasswordBarButtonItem
{
    if (!_refreshPasswordBarButtonItem) {
        _refreshPasswordBarButtonItem = ({
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"生成临时密码" style:UIBarButtonItemStylePlain target:self action:@selector(synchronizePassword)];
            item.tintColor = MAIN_COLOR;
            
            item;
        });
    }
    
    return _refreshPasswordBarButtonItem;
}

#pragma mark - database change
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.passwordTableView.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    if (type == NSFetchedResultsChangeInsert) {
        [self.passwordTableView.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                          withRowAnimation:UITableViewRowAnimationMiddle];
    } else if (type == NSFetchedResultsChangeDelete) {
        [self.passwordTableView.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                          withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    UITableView *tableView = self.passwordTableView.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            //让tableView在newIndexPath位置插入一个cell
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationMiddle];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationMiddle];
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
    [self.passwordTableView.tableView endUpdates];
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
