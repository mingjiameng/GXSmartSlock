//
//  GXManagePermanentPasswordViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/9/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXManagePermanentPasswordViewController.h"

#import "GXPasswordManagerCollect.h"
#import "GXDevicePermanentPsswordModel.h"

#import "zkeyViewHelper.h"
#import "zkeyActivityIndicatorView.h"

#import "GXAddNewPermanentPasswordViewController.h"


@interface GXManagePermanentPasswordViewController () <GXUserPasswordDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    UILabel *_tipsLabel;
    UILabel *_alertLabel;
    UIImageView *_animationView;
    UITableView *_tableView;
    zkeyActivityIndicatorView *_activityIndicator;
    
    NSMutableArray *_passwordModelArray;
    NSIndexPath *_indexPathOfRowNeedToDelete;
    GXPasswordManagerCollect  *_passwordManagerCollect;
}
@end


@implementation GXManagePermanentPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something...
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTips:CGRectMake(0, 30, self.view.frame.size.width, 21)];
    [self addAnimation:CGRectMake(0, 80 , self.view.frame.size.width, self.view.frame.size.width / 1.6)];
    [self scanDevice];
}

- (void)addTips:(CGRect)frame
{
    _tipsLabel = [[UILabel alloc] initWithFrame:frame];
    _tipsLabel.text = @"请按下门锁上的设置键，并将手机靠近门锁";
    _tipsLabel.font = [UIFont systemFontOfSize:15.0];
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_tipsLabel];
}

- (void)addAnimation:(CGRect)frame
{
    _animationView = [[UIImageView alloc] initWithFrame:frame];
    _animationView.userInteractionEnabled = NO;
    
    NSArray *imageArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AddNewDeviceAnimationImage" ofType:@"plist"]];
    NSMutableArray *images = [NSMutableArray array];
    for (NSString *oneImage in imageArray) {
        [images addObject:[UIImage imageNamed:oneImage]];
    }
    
    _animationView.animationImages = (NSArray *)images;
    _animationView.animationDuration = 0.3 * imageArray.count;
    _animationView.animationRepeatCount = 0;
    [_animationView startAnimating];
    
    [self.view addSubview:_animationView];
}

- (void)scanDevice
{
    _passwordManagerCollect = [[GXPasswordManagerCollect alloc] initWithCurrentDeviceName:self.deviceIdentifire];
    _passwordManagerCollect.delegate = self;
    
    _passwordModelArray = [NSMutableArray array];
}

#pragma mark - GXUserPasswordDelegate
-(void)getNewConnectedUser:(GXPasswordManagerCollect *)passwordManagerCollect userName:(NSString *)userName passwordID:(NSString *)passwordID
{
    if (_tipsLabel != nil) {
        [_tipsLabel removeFromSuperview];
        [_animationView removeFromSuperview];
        
        _tipsLabel = nil;
        _animationView = nil;
    }
    
    if (_alertLabel != nil) {
        [_alertLabel removeFromSuperview];
        _alertLabel = nil;
    }
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [zkeyViewHelper hideExtraSeparatorLine:_tableView];
        [self.view addSubview:_tableView];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPassword)];
    }
    
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
    
    if ([self passwordExistInArray:passwordID]) {
        return;
    }
    
    GXDevicePermanentPsswordModel *passwordModel = [[GXDevicePermanentPsswordModel alloc] init];
    passwordModel.nickname = userName;
    passwordModel.password = passwordID;
    
    [_passwordModelArray insertObject:passwordModel atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (BOOL)passwordExistInArray:(NSString *)passwordID
{
    for (GXDevicePermanentPsswordModel *passwordModel in _passwordModelArray) {
        if ([passwordID isEqualToString:passwordModel.password]) {
            return YES;
        }
    }
    
    return NO;
}

-(void)AlertWhenNoPasswordAfterScan:(GXPasswordManagerCollect *)passwordManagerCollect
{
    if (_tipsLabel != nil) {
        [_tipsLabel removeFromSuperview];
        [_animationView removeFromSuperview];
        
        _tipsLabel = nil;
        _animationView = nil;
    }
    
    if (_alertLabel == nil) {
        _alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 30.0f, self.view.frame.size.width - 40.0f, 50.0f)];
        _alertLabel.text = @"没用常用密码，请点击右上角添加密码";
        _alertLabel.textColor = [UIColor lightGrayColor];
        _alertLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.view addSubview:_alertLabel];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPassword)];
    }
}

- (void)deletePasswordSuccessed:(GXPasswordManagerCollect *)passwordManagerCollect userName:(NSString *)userName passwordID:(NSString *)passwordID
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
    
    [_passwordModelArray removeObjectAtIndex:_indexPathOfRowNeedToDelete.row];
    [_tableView deleteRowsAtIndexPaths:@[_indexPathOfRowNeedToDelete] withRowAnimation:UITableViewRowAnimationMiddle];
    
    self.view.userInteractionEnabled = YES;
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _passwordModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"permanentPassword"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"permanentPassword"];
    }
    
    GXDevicePermanentPsswordModel *passwordModel = [_passwordModelArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = passwordModel.nickname;
    //cell.detailTextLabel.text = passwordModel.password;
    
    return cell;
}

#pragma mark - table view delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _indexPathOfRowNeedToDelete = indexPath;
        
        UIActionSheet *deleteActionSheet = [[UIActionSheet alloc] initWithTitle:@"删除该密码后，无法使用该密码开锁" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
        [deleteActionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        self.view.userInteractionEnabled = NO;
        
        _activityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.view.frame title:@"正在删除..."];
        [self.view addSubview:_activityIndicator];
        
        GXDevicePermanentPsswordModel *passwordModel = [_passwordModelArray objectAtIndex:_indexPathOfRowNeedToDelete.row];
        [_passwordManagerCollect deletePassword:passwordModel.nickname password:passwordModel.password];
    }
}
#pragma mark - add password
- (void)addPassword
{
    GXAddNewPermanentPasswordViewController *addNewPasswordVC = [[GXAddNewPermanentPasswordViewController alloc] init];
    addNewPasswordVC.addNewPassword = ^(GXDevicePermanentPsswordModel *passwordModel) {
        _activityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.view.frame title:@"正在添加钥匙..."];
        [self.view addSubview:_activityIndicator];
        
        [_passwordManagerCollect addNewPassword:passwordModel.nickname password:passwordModel.password];
    };
    
    UINavigationController *navigator = [[UINavigationController alloc] initWithRootViewController:addNewPasswordVC];
    [self presentViewController:navigator animated:YES completion:^{
        
    }];
}
@end
