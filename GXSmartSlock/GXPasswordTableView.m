//
//  GXPasswordTableView.m
//  GXSmartSlock
//
//  Created by zkey on 10/18/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#define PASSWORD_TABLE_VIEW_CELL_REUSE_IDENTIFIRE @"password"



#import "GXPasswordTableView.h"

#import "GXPasswordTableViewCellDataModel.h"



@implementation GXPasswordTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PASSWORD_TABLE_VIEW_CELL_REUSE_IDENTIFIRE];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PASSWORD_TABLE_VIEW_CELL_REUSE_IDENTIFIRE];
    }
    
    GXPasswordTableViewCellDataModel *cellData = (GXPasswordTableViewCellDataModel *)[self.dataSource tableView:self cellDataForRowAtIndexPath:indexPath];
    
    cell.textLabel.text = cellData.passwordNickname;
    cell.detailTextLabel.text = cellData.statusDescription;
    
    return cell;
}


@end
