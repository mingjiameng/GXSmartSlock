//
//  GXSelectValidDeviceViewController.m
//  GXSmartSlock
//
//  Created by zkey on 8/30/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSelectValidDeviceViewController.h"

#import "MICRO_COMMON.h"
#import "MICRO_DEVICE_LIST.h"

#import "GXDatabaseEntityDevice.h"
#import "zkeySandboxHelper.h"

#import "GXSelectDeviceTableViewCell.h"

@interface GXSelectValidDeviceViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GXSelectValidDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something...
    
    [self addValidDeviceListTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
    
}

- (void)addValidDeviceListTableView:(CGRect)frame
{
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}


#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.validDeviceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXSelectDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectDevice"];
    if (cell == nil) {
        cell = [[GXSelectDeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectDevice"];
    }

    GXDatabaseEntityDevice *device = [self.validDeviceArray objectAtIndex:indexPath.row];
    
    cell.imageView.image = [self deviceImageNameAccordingDeviceCategory:device.deviceCategory andDeviceIdentifire:device.deviceIdentifire];
    
    cell.textLabel.text = device.deviceNickname;
    
    return cell;
}

- (UIImage *)deviceImageNameAccordingDeviceCategory:(NSString *)deviceCategory andDeviceIdentifire:(NSString *)deviceIdentifire
{
    NSString *deviceImageFilePath = [NSString stringWithFormat:@"%@/%@.png", [zkeySandboxHelper pathOfDocuments], deviceIdentifire];
    if ([zkeySandboxHelper fileExitAtPath:deviceImageFilePath]) {
        return [UIImage imageWithContentsOfFile:deviceImageFilePath];
    }
    
    NSString *imageName = nil;
    
    if ([deviceCategory isEqualToString:DEVICE_CATEGORY_DEFAULT]) {
        imageName = DEVICE_CATEGORY_DEFAULT_IMG;
    } else if ([deviceCategory isEqualToString:DEVICE_CATEGORY_ELECTRIC]) {
        imageName = DEVICE_CATEGORY_ELECTRIC_IMG;
    } else if ([deviceCategory isEqualToString:DEVICE_CATEGORY_GUARD]) {
        imageName = DEVICE_CATEGORY_GUARD_IMG;
    } else {
        NSLog(@"error: invalid device category");
    }
    
    return [UIImage imageNamed:imageName];
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GXDatabaseEntityDevice *device = [self.validDeviceArray objectAtIndex:indexPath.row];
    
    if (self.deviceSelected) {
        self.deviceSelected(device);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end