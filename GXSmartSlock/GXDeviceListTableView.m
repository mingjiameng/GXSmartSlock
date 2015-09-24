//
//  GXDeviceListTableView.m
//  GXSmartSlock
//
//  Created by zkey on 8/25/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXDeviceListTableView.h"

#import "MICRO_DEVICE_LIST.h"

#import "GXDeviceListTableViewCellDataModel.h"
#import "zkeySandboxHelper.h"

#import "GXDeviceListTableViewCellBatteryLevelLabel.h"
#import "GXDeviceListTableViewCell.h"

@implementation GXDeviceListTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXDeviceListTableViewCellDataModel *cellData = (GXDeviceListTableViewCellDataModel *)[self.dataSource tableView:self cellDataForRowAtIndexPath:indexPath];
    
    GXDeviceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DEVICE_LIST_TABLE_VIEW_CELL_REUSE_IDENTIFIRE];
    if (cell == nil) {
        cell = [[GXDeviceListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DEVICE_LIST_TABLE_VIEW_CELL_REUSE_IDENTIFIRE];
    }
    
    cell.imageView.image = [self deviceImageNameAccordingDeviceCategory:cellData.deviceCategory andDeviceIdentifire:cellData.deviceIdentifire];
    
    cell.textLabel.text = cellData.title;
    
    cell.detailTextLabel.text = cellData.subtitle;
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    cell.deviceCategoryLabel.text = [self descriptionForDeviceCategory:cellData.deviceCategory];
    
    cell.batteryLabel.text = [self descriptionForBatteryLevel:cellData.batteryLevel];
    cell.batteryLabel.indicatorView.backgroundColor = [self indicationColorForBatteryLevel:cellData.batteryLevel];
    
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
        NSLog(@"error: invalid device category:%@", deviceCategory);
    }
    
    return [UIImage imageNamed:imageName];
}

- (UIColor *)indicationColorForBatteryLevel:(NSInteger)batteryLevel
{
    UIColor *indicatorViewBackgroundColor = nil;
    
    if (batteryLevel < 350.0f) {
        indicatorViewBackgroundColor = [UIColor redColor];
    } else if (batteryLevel < 485.0f) {
        indicatorViewBackgroundColor = [UIColor yellowColor];
    } else {
        indicatorViewBackgroundColor = [UIColor greenColor];
    }
    
    return indicatorViewBackgroundColor;
}

- (NSString *)descriptionForBatteryLevel:(NSInteger)batteryLevel
{
    NSString *title = nil;
    
    if (batteryLevel < 350.0f) {
        title = @"低电量";
    } else if (batteryLevel < 485.0f) {
        title = @"中等电量";
    } else {
        title = @"电量充足";
    }
    
    return title;
}

- (NSString *)descriptionForDeviceCategory:(NSString *)deviceCategory
{
    NSString *title = @"普通锁";
    
    if ([deviceCategory isEqualToString:DEVICE_CATEGORY_DEFAULT]) {
        return @"智能锁";
    } else if ([deviceCategory isEqualToString:DEVICE_CATEGORY_ELECTRIC]) {
        return @"电机锁";
    } else if ([deviceCategory isEqualToString:DEVICE_CATEGORY_GUARD]) {
        return @"门禁锁";
    } else if ([deviceCategory isEqualToString:DEVICE_CATEGORY_IN_DOOR]) {
        return @"室内所";
    }
    
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

@end
