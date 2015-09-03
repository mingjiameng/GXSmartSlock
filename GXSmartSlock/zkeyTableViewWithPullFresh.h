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
@optional
- (void)tableViewRequestNewData:(zkeyTableViewWithPullFresh *)tableView ;
- (void)tableView:(zkeyTableViewWithPullFresh *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(zkeyTableViewWithPullFresh *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(zkeyTableViewWithPullFresh *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

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

@end
