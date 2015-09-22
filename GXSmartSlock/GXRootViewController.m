//
//  GXRootViewController.m
//  GXSmartSlock
//
//  Created by zkey on 8/20/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXRootViewController.h"

#import "MICRO_COMMON.h"
#import "MICRO_ROOT.h"

#import "GXDatabaseHelper.h"
#import "GXDatabaseEntityUser.h"
#import "GXUnlockTool.h"

#import "zkeyButtonWithImageAndTitle.h"
#import "UIImageView+FHProfileDownload.h"

#import "GXDeviceListViewController.h"
#import "GXUserSettingViewController.h"
#import "GXAddNewDeviceViewController.h"
#import "GXSendKeyViewController.h"
#import "GXUnlockRecordViewController.h"

#import <CoreData/CoreData.h>

#define BOTTOM_TOOL_BAR_HEIGHT 100.0F

@interface GXRootViewController () <NSFetchedResultsControllerDelegate, UIActionSheetDelegate, GXUnlockToolDelegate>
{
    UIButton *_selectUnlockModeButton;
    NSFetchedResultsController *_validKeyFetchedResultsController;
    UIButton *_centralButton;
    UIActionSheet *_unlockModeActionSheet;
    UIImageView *_headImageView;
    UIWebView *_animationView;
    
    
    GXUnlockTool *_unlockTool;
}
@end

@implementation GXRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addToolBar:CGRectMake(0, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE - BOTTOM_TOOL_BAR_HEIGHT, self.view.frame.size.width, BOTTOM_TOOL_BAR_HEIGHT)];
    
    [self configNavigationBar];
    [self configCentralButton];
    [self addUnlockTool];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setHeadImage) name:NOTIFICATION_UPDATE_PROFILE_IMAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_unlockTool selector:@selector(uploadLocalUnlockRecord) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)configNavigationBar
{
    // left bar button - user personal setting list
    CGFloat imageSize = 34.0f;
    UIButton *personalSettingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imageSize, imageSize)];
    _headImageView = [[UIImageView alloc] initWithFrame:personalSettingButton.bounds];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = imageSize / 2.0f;
    [self setHeadImage];
    [personalSettingButton addSubview:_headImageView];
    
    [personalSettingButton addTarget:self action:@selector(personalSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:personalSettingButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // title bar button item - select unlock mode
    [self configNavigationBarTitleView];
    
    // right bar button - add device
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDevice)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // back button style
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)setHeadImage
{
    UIImage *placeHolderImage = [UIImage imageNamed:@"appLogoForLogin"];
    
    GXDatabaseEntityUser *defaultUser = [GXDatabaseHelper defaultUser];
    
    [_headImageView setProfileWithUrlString:defaultUser.headImageURL placeholderImage:placeHolderImage];
}

- (void)reloadView
{
    [self configNavigationBarTitleView];
    [self configCentralButton];
}

- (void)configCentralButton
{
    if (_centralButton == nil) {
        CGFloat buttonSize = fmin(self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE - BOTTOM_TOOL_BAR_HEIGHT - 40.0f, self.view.frame.size.width - 40.0f);
        CGFloat verticalSpace = (self.view.frame.size.height - buttonSize - TOP_SPACE_IN_NAVIGATION_MODE - BOTTOM_TOOL_BAR_HEIGHT) / 2.0;
        CGFloat centralY = verticalSpace + buttonSize / 2.0;
        _centralButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonSize, buttonSize)];
        _centralButton.center = CGPointMake(self.view.frame.size.width / 2.0, centralY);
        
        [self.view addSubview:_centralButton];
    }
    
    [_centralButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    
    NSString *backgroundImageName = CENTRAL_BUTTON_TYPE_NONE;
    if ([self isThereValidDevice]) {
        DefaultUnlockMode unlockMode = [self unlockMode];
        if (unlockMode == DefaultUnlockModeManul) {
            backgroundImageName = CENTRAL_BUTTON_TYPE_MANUL;
            [_centralButton addTarget:self action:@selector(manulUnlock:) forControlEvents:UIControlEventTouchUpInside];
        } else if (unlockMode == DefaultUnlockModeAuto) {
            backgroundImageName = CENTRAL_BUTTON_TYPE_AUTO;
            [_centralButton addTarget:self action:@selector(autoUnlockGuide:) forControlEvents:UIControlEventTouchUpInside];
            _animationView = nil;
        } else if (unlockMode == DefaultUnlockModeShake) {
            backgroundImageName = CENTRAL_BUTTON_TYPE_SHAKE;
            [_centralButton addTarget:self action:@selector(shakeUnlockGuide:) forControlEvents:UIControlEventTouchUpInside];
            _animationView = nil;
        } else {
            NSLog(@"invalid unlock mode");
        }
    } else {
        backgroundImageName = CENTRAL_BUTTON_TYPE_NONE;
        _animationView = nil;
    }
    
    [_centralButton setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
}

- (void)addUnlockTool
{
    _unlockTool = [[GXUnlockTool alloc] init];
    _unlockTool.delegate = self;
}

- (void)configNavigationBarTitleView
{
    if ([self isThereValidDevice]) {
        if (_selectUnlockModeButton == nil) {
            _selectUnlockModeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 30.0f)];
            _selectUnlockModeButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
            [_selectUnlockModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_selectUnlockModeButton addTarget:self action:@selector(selectUnlockMode:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [_selectUnlockModeButton setTitle:[self currentUnlockModeDescription] forState:UIControlStateNormal];
        
        self.navigationItem.title = nil;
        self.navigationItem.titleView = _selectUnlockModeButton;
    } else {
        self.navigationItem.titleView = nil;
        self.navigationItem.title = @"请添加门锁";
    }
}

- (NSString *)currentUnlockModeDescription
{
    DefaultUnlockMode unlockMode = [self unlockMode];
    if (unlockMode == DefaultUnlockModeManul) {
        return @"手动开锁 ▾";
    } else if (unlockMode == DefaultUnlockModeAuto) {
        return @"感应开锁 ▾";
    } else if (unlockMode == DefaultUnlockModeShake) {
        return @"摇一摇开锁 ▾";
    }
    
    return @"";
}

- (DefaultUnlockMode)unlockMode
{
    NSNumber *unlockModeNumber = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_UNLOCK_MODE];
    if (unlockModeNumber == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:DefaultUnlockModeManul] forKey:DEFAULT_UNLOCK_MODE];
        unlockModeNumber = [NSNumber numberWithInteger:DefaultUnlockModeManul];
    }
    
    DefaultUnlockMode unlockMode = [unlockModeNumber integerValue];
    return unlockMode;
}

- (BOOL)isThereValidDevice
{
    if (_validKeyFetchedResultsController == nil) {
        _validKeyFetchedResultsController = [GXDatabaseHelper validDeviceFetchedResultsController];
        _validKeyFetchedResultsController.delegate = self;
    }
    
    if (_validKeyFetchedResultsController == nil) {
        return NO;
    }
    
    if ([[_validKeyFetchedResultsController sections] count] <= 0) {
        return NO;
    }
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_validKeyFetchedResultsController sections] objectAtIndex:0];
    if ([sectionInfo numberOfObjects] <= 0) {
        return NO;
    }
    
    return YES;
}

- (void)addToolBar:(CGRect)frame
{
    UIView *toolBarView = [[UIView alloc] initWithFrame:frame];
    toolBarView.backgroundColor = [UIColor clearColor];
    toolBarView.layer.borderColor = [[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0] CGColor];
    toolBarView.layer.borderWidth = 1.0;
    [self.view addSubview:toolBarView];
    
    const CGFloat cellWidth = frame.size.width / 3.0;
    const CGFloat cellHeigth = frame.size.height;
    CGRect frame01 = CGRectMake(0 * cellWidth, 0, cellWidth, cellHeigth);
    CGRect frame02 = CGRectMake(1 * cellWidth, 0, cellWidth, cellHeigth);
    CGRect frame03 = CGRectMake(2 * cellWidth, 0, cellWidth, cellHeigth);
    
    CGFloat titleFontSize = 12.0;
    CGFloat imageSize = 35.0f;
    UIColor *titleColor = [UIColor darkGrayColor];
    // cover every cell with button
    // scan two-dimension code
    zkeyButtonWithImageAndTitle *cell01 = [[zkeyButtonWithImageAndTitle alloc] initWithFrame:frame01 title:TOOL_BAR_FIRST_CELL_TITLE titleFontSize:titleFontSize titleColor:titleColor image:[UIImage imageNamed:TOOL_BAR_FIRST_CELL_IMG] imageSize:imageSize];
    [cell01 addTarget:self action:@selector(showDeviceList:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:cell01];
    
    // invite
    zkeyButtonWithImageAndTitle *cell02 = [[zkeyButtonWithImageAndTitle alloc] initWithFrame:frame02 title:TOOL_BAR_SECOND_CELL_TITLE titleFontSize:titleFontSize titleColor:titleColor image:[UIImage imageNamed:TOOL_BAR_SECOND_CELL_IMG] imageSize:imageSize];
    [cell02 addTarget:self action:@selector(sendKey:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:cell02];
    
    // collect
    zkeyButtonWithImageAndTitle *cell03 = [[zkeyButtonWithImageAndTitle alloc] initWithFrame:frame03 title:TOOL_BAR_THIRD_CELL_TITLE titleFontSize:titleFontSize titleColor:titleColor image:[UIImage imageNamed:TOOL_BAR_THIRD_CELL_IMG] imageSize:imageSize];
    [cell03 addTarget:self action:@selector(unlockRecord:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:cell03];
}


#pragma mark - user action
- (void)selectUnlockMode:(UIButton *)sender
{
    if (_unlockModeActionSheet == nil) {
        _unlockModeActionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择开锁模式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"手动开锁", @"感应开锁", @"摇一摇开锁", nil];
    }
    
    [_unlockModeActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    DefaultUnlockMode unlockMode = DefaultUnlockModeManul;
    if (buttonIndex == 0) {
        unlockMode = DefaultUnlockModeManul;
    } else if (buttonIndex == 1) {
        unlockMode = DefaultUnlockModeAuto;
    } else if (buttonIndex == 2) {
        unlockMode = DefaultUnlockModeShake;
    }
    
    DefaultUnlockMode previousUnlockMode = [[[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_UNLOCK_MODE] integerValue];
    if (previousUnlockMode == unlockMode) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:unlockMode] forKey:DEFAULT_UNLOCK_MODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self reloadView];
    [_unlockTool updateUnlockMode];
}

- (void)manulUnlock:(UIButton *)sender
{
    if (_animationView == nil) {
        // animation view
        _animationView = [[UIWebView alloc] initWithFrame:_centralButton.frame];
        _animationView.scalesPageToFit = YES;
        _animationView.backgroundColor = [UIColor clearColor];
        _animationView.userInteractionEnabled = NO;
        
        NSString *animationFilePath = [[NSBundle mainBundle] pathForResource:@"manulUnlockAnimation" ofType:@"gif"];
        NSData *animationData = [NSData dataWithContentsOfFile:animationFilePath];
        [_animationView loadData:animationData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        
        _animationView.hidden = YES;
        
        [self.view addSubview:_animationView];
    }
    
    _animationView.hidden = NO;
    NSLog(@"点击手动开锁");
    [_unlockTool manulUnlock];
}


#pragma mark - 
- (void)successfullyUnlockDevice:(NSString *)deviceIdentifire
{
    if (_animationView != nil) {
        _animationView.hidden = YES;
    }
}

- (void)forceStopUnlock
{
    if (_animationView != nil) {
        _animationView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)showDeviceList:(UIButton *)sender
{
    GXDeviceListViewController *deviceListVC = [[GXDeviceListViewController alloc] init];
    [self.navigationController pushViewController:deviceListVC animated:YES];
}

- (void)sendKey:(UIButton *)sender
{
    GXSendKeyViewController *sendKeyVC = [[GXSendKeyViewController alloc] init];
    [self.navigationController pushViewController:sendKeyVC animated:YES];
}

- (void)unlockRecord:(UIButton *)sender
{
    GXUnlockRecordViewController *unlockRecordVC = [[GXUnlockRecordViewController alloc] init];
    unlockRecordVC.viewType = UnlockRecordViewTypeFromRootView;
    
    [self.navigationController pushViewController:unlockRecordVC animated:YES];
}

- (void)personalSetting:(UIButton *)sender
{
    GXUserSettingViewController *userSettingVC = [[GXUserSettingViewController alloc] init];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:userSettingVC];
    
    [self presentViewController:navigationVC animated:YES completion:^{
        
    }];
}

- (void)addDevice
{
    GXAddNewDeviceViewController *addDevice = [[GXAddNewDeviceViewController alloc] init];
    UINavigationController *addDeviceNavigation = [[UINavigationController alloc] initWithRootViewController:addDevice];
    [self.navigationController presentViewController:addDeviceNavigation animated:YES completion:^{
        
    }];
}

// how to use "自动开锁"
- (void)autoUnlockGuide:(UIButton *)sender
{
    NSLog(@"自动开锁");
}

// how to use "摇一摇开锁"
- (void)shakeUnlockGuide:(UIButton *)sender
{
    NSLog(@"摇一摇开锁");
}


#pragma mark - database change
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    [self reloadView];
    [_unlockTool updateDeviceKeyDictionary];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    [self reloadView];
    [_unlockTool updateDeviceKeyDictionary];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:_unlockTool];
    
    _unlockTool = nil;
}

@end
