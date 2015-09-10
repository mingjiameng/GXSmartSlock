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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DEVICE_LIST_TABLE_VIEW_CELL_REUSE_IDENTIFIRE];
    if (cell == nil) {
        cell = [[GXDeviceListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DEVICE_LIST_TABLE_VIEW_CELL_REUSE_IDENTIFIRE];
    }
    
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2.0f;
    
    cell.imageView.image = [self deviceImageNameAccordingDeviceCategory:cellData.deviceCategory andDeviceIdentifire:cellData.deviceIdentifire];
    
    cell.textLabel.text = cellData.title;
    
    cell.detailTextLabel.text = cellData.subtitle;
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    cell.accessoryView = [[GXDeviceListTableViewCellBatteryLevelLabel alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 21.0f) andBatteryLevel:cellData.batteryLevel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

@end
