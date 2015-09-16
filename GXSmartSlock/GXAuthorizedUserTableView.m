//
//  GXAuthorizedUserTableView.m
//  GXSmartSlock
//
//  Created by zkey on 9/1/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXAuthorizedUserTableView.h"

#import "MICRO_COMMON.h"

#import "GXAuthorizedUserTableViewCellDataModel.h"

#import "GXAuthorizedUserTableViewCell.h"
#import "UIImageView+FHProfileDownload.h"

@interface GXAuthorizedUserTableView ()
{
    UIImage *_profilePalceholder;
}
@end

@implementation GXAuthorizedUserTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GXAuthorizedUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"authorizedUser"];
    if (cell == nil) {
        cell = [[GXAuthorizedUserTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"authorizedUser"];
    }
    
    GXAuthorizedUserTableViewCellDataModel *cellData = (GXAuthorizedUserTableViewCellDataModel *)[self.dataSource tableView:self cellDataForRowAtIndexPath:indexPath];
    
    
    if (_profilePalceholder == nil) {
        _profilePalceholder = [UIImage imageNamed:DEFAULT_PROFILE_IMG];
    }
    [cell.imageView setProfileWithUrlString:cellData.profileImageURL placeholderImage:_profilePalceholder];
    
    cell.textLabel.text = cellData.nickname;
    cell.detailTextLabel.text = cellData.detailText;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [self.delegate tableView:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

@end
