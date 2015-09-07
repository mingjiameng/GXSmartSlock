//
//  GXUnlockRecordTableView.m
//  GXSmartSlock
//
//  Created by zkey on 9/7/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXUnlockRecordTableView.h"

#import "MICRO_COMMON.h"

#import "GXUnlockRecordTableViewCell.h"
#import "UIImageView+FHProfileDownload.h"

#import "GXUnlockRecordTableViewCellData.h"

@interface GXUnlockRecordTableView ()
{
    UIImage *_profileImage;
}
@end

@implementation GXUnlockRecordTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXUnlockRecordTableViewCellData *cellData = (GXUnlockRecordTableViewCellData *)[self.dataSource tableView:self cellDataForRowAtIndexPath:indexPath];
    
    GXUnlockRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"unlockRecord"];
    if (cell == nil) {
        cell = [[GXUnlockRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"unlockRecord"];
    }
    
    cell.textLabel.text = cellData.userNickname;
    cell.detailTextLabel.text = cellData.deviceNickname;
    
    if (_profileImage == nil) {
        _profileImage = [UIImage imageNamed:DEFAULT_PROFILE_IMG];
    }
    
    [cell.imageView setProfileWithUrlString:cellData.profileImageURL placeholderImage:_profileImage];
    
    cell.dateLabel.text = [self unlockDateString:cellData.date];
    
    return cell;
}

- (NSString *)unlockDateString:(NSDate *)date
{
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    
    if (timeInterval < 60.0f) {
        return [NSString stringWithFormat:@"%.0lf秒前", timeInterval];
    } else if (timeInterval < 3600.0f) {
        return [NSString stringWithFormat:@"%.0lf分钟前", timeInterval / 60.0f];
    } else if (timeInterval < 86400.0f) {
        return [NSString stringWithFormat:@"%.0lf小时前", timeInterval / 3600.0f];
    } else {
        return [NSString stringWithFormat:@"%.0lf天前", timeInterval / 86400.0f];
    }
    
    return nil;
}



@end
