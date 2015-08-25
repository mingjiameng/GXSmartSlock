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

#import "GXDeviceListTableViewCellBatteryLevelLabel.h"

@implementation GXDeviceListTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXDeviceListTableViewCellDataModel *cellData = (GXDeviceListTableViewCellDataModel *)[self.dataSource tableView:self cellDataForRowAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DEVICE_LIST_TABLE_VIEW_CELL_REUSE_IDENTIFIRE];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DEVICE_LIST_TABLE_VIEW_CELL_REUSE_IDENTIFIRE];
    }
    
    NSString *deviceCategoryImageName = DEVICE_CATEGORY_DEFAULT_IMG;
    if ([cellData.deviceCategory isEqualToString:DEVICE_CATEGORY_DEFAULT]) {
        deviceCategoryImageName = DEVICE_CATEGORY_DEFAULT_IMG;
    } else if ([cellData.deviceCategory isEqualToString:DEVICE_CATEGORY_ELECTRIC]) {
        deviceCategoryImageName = DEVICE_CATEGORY_ELECTRIC_IMG;
    } else if ([cellData.deviceCategory isEqualToString:DEVICE_CATEGORY_GUARD]) {
        deviceCategoryImageName = DEVICE_CATEGORY_GUARD_IMG;
    } else {
        NSLog(@"error: invalid device category:%@", cellData.deviceCategory);
    }
    cell.imageView.image = [UIImage imageNamed:deviceCategoryImageName];
    
    cell.textLabel.text = cellData.title;
    
    cell.detailTextLabel.text = cellData.subtitle;
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    cell.accessoryView = [[GXDeviceListTableViewCellBatteryLevelLabel alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 21.0f) andBatteryLevel:cellData.batteryLevel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
