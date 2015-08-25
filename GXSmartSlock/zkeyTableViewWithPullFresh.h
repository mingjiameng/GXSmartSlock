//
//  zkeyTableViewWithPullFresh.h
//  FenHongForIOS
//
//  Created by zkey on 7/6/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class zkeyTableViewWithPullFresh;

/*
 deal with user interaction
 */
@protocol zkeyTableViewWithPullFreshDelegate <NSObject>
@required
- (void)tableViewRequestNewData:(zkeyTableViewWithPullFresh *)tableView ;
- (void)tableView:(zkeyTableViewWithPullFresh *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (CGFloat)tableView:(zkeyTableViewWithPullFresh *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


/*
 provide data for table view
 */
@protocol zkeyTableViewWithPullFreshDataSource <NSObject>
@required
- (NSInteger)numberOfSectionsInTableView:(zkeyTableViewWithPullFresh *)tableView;
- (NSInteger)tableView:(zkeyTableViewWithPullFresh *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSObject *)tableView:(zkeyTableViewWithPullFresh *)tableView cellDataForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional


@end


@interface zkeyTableViewWithPullFresh : UIView

@property (nonatomic, weak) id<zkeyTableViewWithPullFreshDelegate> delegate;
@property (nonatomic, weak) id<zkeyTableViewWithPullFreshDataSource> dataSource;
@property (nonatomic, strong) UITableView *tableView;

- (void)forceToRefresh;
- (void)didEndLoadingData;
- (void)reloadTableViewData;
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableViewBeginUpdates;
- (void)tableViewEndUpdates;

@end
