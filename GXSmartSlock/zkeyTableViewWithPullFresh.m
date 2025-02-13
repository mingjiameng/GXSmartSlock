//
//  zkeyTableViewWithPullFresh.m
//  FenHongForIOS
//
//  Created by zkey on 7/6/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "zkeyTableViewWithPullFresh.h"

#import "zkeyRefreshHeaderView.h"
#import "zkeyViewHelper.h"

@interface zkeyTableViewWithPullFresh () <UITableViewDelegate, UITableViewDataSource, zkeyRefreshHeaderViewDelegate>

@property (nonatomic, strong) zkeyRefreshHeaderView *refreshHeaderView;

@end


@implementation zkeyTableViewWithPullFresh
#pragma mark - initialize
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // tableview
        CGRect tableViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        // 添加视图的顺序不能反
        [self buildTableView:tableViewFrame];
        [self addRefreshModule:tableViewFrame];
    }
    
    return self;
}

- (void)buildTableView:(CGRect)frame
{
    _tableView = [[UITableView alloc] initWithFrame:frame];
    _tableView.backgroundColor = [UIColor clearColor];
    [zkeyViewHelper hideExtraSeparatorLine:_tableView];
    _tableView.separatorInset = UIEdgeInsetsZero;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

- (void)addRefreshModule:(CGRect)frame
{
    _refreshHeaderView = [[zkeyRefreshHeaderView alloc] initWithFrame:frame];
    _refreshHeaderView.delegate = self;
    [self insertSubview:_refreshHeaderView belowSubview:_tableView];
}

#pragma mark - about refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        [_refreshHeaderView zkeyScrollViewWillBeginDragging:_tableView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        [_refreshHeaderView zkeyScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _tableView) {
        [_refreshHeaderView zkeyScrollViewDidEndDragging:scrollView];
    }
}

- (void)forceToRefresh
{
    [_refreshHeaderView forceToRefresh:_tableView];
}

- (void)didEndLoadingData
{
    [_refreshHeaderView didEndLoadingData:_tableView];
}

#pragma mark - zkeyRefreshHeaderViewDelegate
- (void)requestNewData
{
    if ([self.delegate respondsToSelector:@selector(tableViewRequestNewData:)]) {
        [self.delegate tableViewRequestNewData:self];
        [self performSelector:@selector(didEndLoadingData) withObject:nil afterDelay:10.0f];
    } else {
        [self didEndLoadingData];
    } 
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource numberOfSectionsInTableView:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource tableView:self numberOfRowsInSection:section];
}

// 使用zkeyTableViewWithPullFresh 必须重写改方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
    }
    
    return 44.0f;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
    
}


@end
