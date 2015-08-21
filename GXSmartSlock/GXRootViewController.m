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

#import "zkeyButtonWithImageAndTitle.h"

@interface GXRootViewController ()

@end

@implementation GXRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat toolBarHeight = 100.0;
    [self addToolBar:CGRectMake(0, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE - toolBarHeight, self.view.frame.size.width, toolBarHeight)];
    
    [self configNavigationBar];
}

- (void)configNavigationBar
{
    // left bar button - user personal setting list
    UIButton *personalSettingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34.0f, 34.0f)];
    [personalSettingButton setBackgroundImage:[UIImage imageNamed:@"appLogoForLogin"] forState:UIControlStateNormal];
    [personalSettingButton addTarget:self action:@selector(personalSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:personalSettingButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // title bar button item - select unlock mode
    [self configNavigationBarTitleView];
    
    // right bar button - add device
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDevice:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // back button style
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)configNavigationBarTitleView
{
    if ([self isThereUseableDevice]) {
        UIButton *selectUnlockModeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 22.0f)];
        selectUnlockModeButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [selectUnlockModeButton setTitle:[self currentUnlockModeDescription] forState:UIControlStateNormal];
        [selectUnlockModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.navigationItem.titleView = selectUnlockModeButton;
    } else {
        self.navigationItem.titleView = nil;
        self.navigationItem.title = @"请添加门锁";
    }
}



- (NSString *)currentUnlockModeDescription
{
    NSNumber *unlockModeNumber = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_UNLOCK_MODE];
    if (unlockModeNumber == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:DefaultUnlockModeManul] forKey:DEFAULT_UNLOCK_MODE];
        unlockModeNumber = [NSNumber numberWithInteger:DefaultUnlockModeManul];
    }
    
    DefaultUnlockMode unlockMode = [unlockModeNumber integerValue];
    if (unlockMode == DefaultUnlockModeManul) {
        return @"手动开锁";
    } else if (unlockMode == DefaultUnlockModeAuto) {
        return @"自动开锁";
    } else if (unlockMode == DefaultUnlockModeShake) {
        return @"摇一摇开锁";
    }
    
    return @"";
}

- (BOOL)isThereUseableDevice
{
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
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)showDeviceList:(UIButton *)sender
{
    
}

- (void)sendKey:(UIButton *)sender
{

}

- (void)unlockRecord:(UIButton *)sender
{
    
}

- (void)personalSetting:(UIButton *)sender
{
    
}

- (void)addDevice:(UIButton *)sender
{
    
}

// how to use "自动开锁"

// how to use "摇一摇开锁"




@end
