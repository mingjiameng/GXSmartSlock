//
//  GXPasswordDetailViewController.m
//  GXSmartSlock
//
//  Created by zkey on 10/20/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXPasswordDetailViewController.h"

#import "MICRO_COMMON.h"


@class GXDatabaseEntityPassword;
#import "GXPasswordModel.h"
#import "GXDatabaseHelper.h"

#import <CoreData/CoreData.h>

#define TITLE_PASSWORD_NICKNAME @"密 码 昵 称"
#define TITLE_PASSWORD_ADDED_APPROACH @"密 码 来 源"
#define TITLE_PASSWORD_TYPE @"密 码 类 型"
#define TITLE_PASSWORD @"密 码 明 文"
#define TITLE_PASSWORD_VALID_DATE @"有 效 期 限"
#define TITLE_PASSWORD_STATUS @"密 码 状 态"
#define TITLE_PASSWORD_VALIDITY @"是 否 有 效"

@interface GXPasswordDetailViewController ()
{
    BOOL dataChanged;
}
@property (nonatomic, strong, nonnull) GXPasswordModel *passwordModel;
@property (nonatomic, strong, nonnull) UIToolbar *actionToolBar;
@property (nonatomic, strong, nonnull) UIBarButtonItem *deleteBarButtonItem;
@property (nonatomic, strong, nonnull) UIBarButtonItem *activeBarButtonItem;

@end

@implementation GXPasswordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    dataChanged = NO;
    
    [self buildUI];
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"密码详情";
}

- (void)buildUI
{
    CGFloat horizonalLeadingSpace = 15.0f;
    CGFloat verticalLeadingSpace = 25.0f;
    CGFloat labelHeight = 16.0f;
    CGFloat titleLabelWidth = 80.0f;
    CGFloat verticalSpace = 20.0f;
    CGFloat horizonalSpace = 40.0f;
    CGFloat messageLabelOriginX = horizonalLeadingSpace + horizonalSpace + titleLabelWidth;
    CGFloat messageLabelWidth = self.view.frame.size.width - messageLabelOriginX - horizonalLeadingSpace;
    UIColor *titleLabelColor = [UIColor darkGrayColor];
    UIColor *messageLabelColor = [UIColor lightGrayColor];
    
    
    NSArray<NSString *> *titleArray = @[TITLE_PASSWORD_NICKNAME, TITLE_PASSWORD_ADDED_APPROACH, TITLE_PASSWORD_TYPE, TITLE_PASSWORD, TITLE_PASSWORD_VALID_DATE, TITLE_PASSWORD_STATUS, TITLE_PASSWORD_VALIDITY];
    for (NSInteger index = 0; index < titleArray.count; ++index) {
        NSString *title = [titleArray objectAtIndex:index];
        NSString *message = [self detailMessageOfItem:title];
        
        CGFloat originY = verticalLeadingSpace + index * verticalSpace;
        UILabel *titleLabel = [self specailLabelWithFrame:CGRectMake(horizonalLeadingSpace, originY, titleLabelWidth, labelHeight) Title:title color:titleLabelColor];
        UILabel *messageLabel = [self specailLabelWithFrame:CGRectMake(messageLabelOriginX, originY, messageLabelWidth, labelHeight) Title:message color:messageLabelColor];
        [self.view addSubview:titleLabel];
        [self.view addSubview:messageLabel];
    }
    
    
}

- (nonnull NSString *)detailMessageOfItem:(nonnull NSString *)title
{
    if ([title isEqualToString:TITLE_PASSWORD_NICKNAME]) {
        return [self passwordNicknameString];
    } else if ([title isEqualToString:TITLE_PASSWORD_ADDED_APPROACH]) {
        return [self passwordAddedApproachString];
    } else if ([title isEqualToString:TITLE_PASSWORD_TYPE]) {
        return [self passwordTypeString];
    } else if ([title isEqualToString:TITLE_PASSWORD]) {
        return [self passwordString];
    } else if ([title isEqualToString:TITLE_PASSWORD_VALID_DATE]) {
        return [self passwordValidDateString];
    } else if ([title isEqualToString:TITLE_PASSWORD_STATUS]) {
        return [self passwordStatusString];
    } else if ([title isEqualToString:TITLE_PASSWORD_VALIDITY]) {
        return [self passwordValidityString];
    }
    
    return @"";
}

// assistant function
- (nonnull NSString *)passwordNicknameString
{
    return self.passwordModel.passwordNickname;
}

- (nonnull NSString *)passwordAddedApproachString
{
    GXPasswordAddedApproach approach = [GXPasswordModel passwordAddedApproachAccordingToString:self.passwordModel.addedApproach];
    if (approach == GXPasswordAddedApproachBluetooth) {
        return @"通过蓝牙添加";
    } else if (approach == GXPasswordAddedApproachRemote) {
        return @"通过远程中继器添加";
    }
    
    return @"通过蓝牙添加";
}

- (nonnull NSString *)passwordTypeString
{
    GXPasswordType type = [GXPasswordModel passwordTypeAccordingToString:self.passwordModel.passwordTypeString];
    if (type == GXPasswordTypeOnce) {
        return @"一次性";
    } else if (type == GXPasswordTypeTemporary) {
        return @"临时密码";
    } else if (type == GXPasswordTypeNormal) {
        return @"永久密码";
    }
    
    return @"一次性";
}

- (nonnull NSString *)passwordString
{
    GXPasswordType type = [GXPasswordModel passwordTypeAccordingToString:self.passwordModel.passwordTypeString];
    if (type == GXPasswordTypeOnce) {
        return self.passwordModel.password;
    } else {
        return @"密码明文不可见";
    }
    
    return @"密码明文不可见";
}

- (nonnull NSString *)passwordValidDateString
{
    GXPasswordType type = [GXPasswordModel passwordTypeAccordingToString:self.passwordModel.passwordTypeString];
    if (type == GXPasswordTypeTemporary) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *startDateString = [dateFormatter stringFromDate:self.passwordModel.startDate];
        NSString *endDateString = [dateFormatter stringFromDate:self.passwordModel.endDate];
        return [NSString stringWithFormat:@"%@ -\n%@", startDateString, endDateString];
    } else if (type == GXPasswordTypeOnce) {
        return [NSString stringWithFormat:@"长期有效 -\n使用或重置门锁后失效"];
    } else if (type == GXPasswordTypeNormal) {
        return [NSString stringWithFormat:@"长期有效 -\n重置门锁后失效"];
    }
    
    return [NSString stringWithFormat:@"长期有效 -\n使用或重置门锁后失效"];
}

- (nonnull NSString *)passwordStatusString
{
    return [GXPasswordModel passwordStatusDescription:self.passwordModel.passwordStatus];
}

- (nonnull NSString *)passwordValidityString
{
    if (self.passwordModel.actived) {
        return @"有效";
    } else {
        return @"无效";
    }
    
    return @"无效";
}

- (UILabel *)specailLabelWithFrame:(CGRect)frame Title:(NSString *)title color:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = color;
    label.text = title;
    
    return label;
}

- (UIToolbar *)actionToolBar
{
    if (!_actionToolBar) {
        _actionToolBar = ({
            CGFloat toolBarHeight = 44.0f;
            UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - toolBarHeight - TOP_SPACE_IN_NAVIGATION_MODE, self.view.frame.size.width, toolBarHeight)];
            [toolBar setBarTintColor:MAIN_COLOR];

            UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [toolBar setItems:@[self.activeBarButtonItem, flexibleItem, self.deleteBarButtonItem]];
            
            toolBar;
        });
    }
    
    return _actionToolBar;
}

- (UIBarButtonItem *)deleteBarButtonItem
{
    if (!_deleteBarButtonItem) {
        _deleteBarButtonItem = ({
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deletePassword)];
            
            item;
        });
    }
    
    return _deleteBarButtonItem;
}

- (UIBarButtonItem *)activeBarButtonItem
{
    if (!_activeBarButtonItem) {
        _activeBarButtonItem = ({
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:[self titleForPasswordActivedState] style:UIBarButtonItemStylePlain target:self action:@selector(activeORdeactivePassword)];
            
            NSInteger passwordStatus = self.passwordModel.passwordStatus;
            if (passwordStatus == 3 || passwordStatus == 4 || passwordStatus == 5 || passwordStatus == 6 || passwordStatus == 7) {
                item.enabled = NO;
            }
            
            item;
        });
    }
    
    return _activeBarButtonItem;
}

- (NSString *)titleForPasswordActivedState
{
    if (self.passwordModel.actived) {
        return @"冻结";
    } else {
        return @"激活";
    }
    
    return @"冻结";
}

- (GXPasswordModel *)passwordModel
{
    if (!_passwordModel || dataChanged) {
        _passwordModel = [GXPasswordModel passwordModelWithCoreDataEntity:[GXDatabaseHelper device:self.deviceIdentifire passwordEntity:self.passwordID]];
    }
    
    return _passwordModel;
}

#pragma mark - user action
- (void)deletePassword
{
    
}

- (void)activeORdeactivePassword
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
