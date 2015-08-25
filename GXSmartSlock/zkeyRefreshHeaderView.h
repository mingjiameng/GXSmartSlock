//
//  zkeyRefreshHeaderView.h
//  ZZUHelper
//
//  Created by 梁志鹏 on 15/5/11.
//  Copyright (c) 2015年 OvercodeGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@class zkeyRefreshHeaderView;

@protocol zkeyRefreshHeaderViewDelegate <UIScrollViewDelegate>
@required
- (void)requestNewData;
@end



@interface zkeyRefreshHeaderView : UIView

@property(nonatomic, weak) id<zkeyRefreshHeaderViewDelegate> delegate;

- (void)zkeyScrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)zkeyScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)zkeyScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)didEndLoadingData:(UIScrollView *)scorllView;
- (void)forceToRefresh:(UIScrollView *)scrollView;

@end
