//
//  GXOneTimePasswordTableView.m
//  GXSmartSlock
//
//  Created by zkey on 9/24/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXOneTimePasswordTableView.h"

#import "GXOneTimePasswordTableViewCellDataModel.h"

@implementation GXOneTimePasswordTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oneTimePassword"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"oneTimePassword"];
    }
    
    GXOneTimePasswordTableViewCellDataModel *cellData = (GXOneTimePasswordTableViewCellDataModel *)[self.dataSource tableView:self cellDataForRowAtIndexPath:indexPath];
    
    cell.textLabel.text = cellData.password;
    cell.detailTextLabel.text = cellData.validityString;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([self.delegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
//        [self.delegate tableView:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
//    }
//}
//
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction *markAsUsedRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"标记为已使用" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        if ([self.delegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
//            [self.delegate tableView:self commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
//        }
//        
//    }];
//
//    return @[markAsUsedRowAction];
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
