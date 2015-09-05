//
//  zkeyRefreshHeaderView.m
//  ZZUHelper
//
//  Created by 梁志鹏 on 15/5/11.
//  Copyright (c) 2015年 OvercodeGroup. All rights reserved.
//

#import "zkeyRefreshHeaderView.h"
#import "CircleView.h"

@interface zkeyRefreshHeaderView()
{
    CircleView *_circleView;
    UILabel *_lastUpdateTimeLabel;
    NSDate *_lastUpdateTime;
    bool _IsDragging;
    bool _IsDownloading;
}
@end

@implementation zkeyRefreshHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(self.center.x - 15, 8, 30, 30)];
        [self addSubview:_circleView];
        
        _lastUpdateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, 12)];
        [self addSubview:_lastUpdateTimeLabel];
        _lastUpdateTimeLabel.font = [UIFont systemFontOfSize:12.0];
        _lastUpdateTimeLabel.textAlignment = NSTextAlignmentCenter;
        _lastUpdateTimeLabel.textColor = [UIColor clearColor];
        
        _lastUpdateTime = [NSDate date];
        
        _lastUpdateTimeLabel.text = @"刚刚更新";
        
        _IsDragging = false;
        _IsDownloading = false;
    }
    
    return self;
}

- (void)zkeyScrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _IsDragging = true;
}

- (void)zkeyScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_IsDragging == false) {
        return;
    }
    
    if (_IsDownloading) {
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    //NSLog(@"%f", offsetY);
    if (offsetY > 0) {
        return;
    }
    
    static CGFloat beginUpdateY = 60;
    if (offsetY < 0) {
        // circle view progress
        offsetY = fabs(offsetY);
        offsetY = MIN(offsetY, beginUpdateY);
        float progress = offsetY / 64.0;
        [self setCircleViewWithProgress:progress];
        
        if (offsetY > 40) {
            _lastUpdateTimeLabel.textColor = [UIColor lightGrayColor];
            _lastUpdateTimeLabel.text = [self lastUpdateTimeText];
        }
    }
    
}

- (void)zkeyScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    _IsDragging = false;
    
    if (_IsDownloading) {
        return;
    }
    
    if (scrollView.contentOffset.y > -64) {
        return;
    }
    
    _IsDownloading = true;
    
    // make edgeInset
    scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    // make animation
    [self makeRotateAnimation];
    
    // refresh data from server
    [self.delegate requestNewData];
    
}

- (void)makeRotateAnimation
{
    // rotate animation
    CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    rotate.removedOnCompletion = FALSE;
    rotate.fillMode = kCAFillModeForwards;
    //Do a series of 5 quarter turns for a total of a 1.25 turns
    //(2PI is a full turn, so pi/2 is a quarter turn)
    [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
    rotate.repeatCount = 150;
    rotate.duration = 0.25;
    //rotate.beginTime = start;
    rotate.cumulative = TRUE;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [_circleView.layer addAnimation:rotate forKey:@"rotateAnimation"];
}

- (void)didEndLoadingData:(UIScrollView *)scrollView
{
    
    [self resetUI:scrollView];
}

- (void)forceToRefresh:(UIScrollView *)scrollView
{
    _lastUpdateTimeLabel.textColor = [UIColor lightGrayColor];
    
    _IsDownloading = true;
    
    scrollView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0);
    
    // make animation
    [self setCircleViewWithProgress:60/64.0];
    [self makeRotateAnimation];
    [self.delegate requestNewData];
}

- (void)resetUI:(UIScrollView *)scrollView
{
    [_circleView.layer removeAllAnimations];
    
    scrollView.contentInset = UIEdgeInsetsZero;
    
    _lastUpdateTime = [NSDate date];
    _lastUpdateTimeLabel.textColor = [UIColor clearColor];
    
    _IsDownloading = false;
    
    [self setCircleViewWithProgress:0];
}

- (void)setCircleViewWithProgress:(float)progress
{
    _circleView.progress = progress;
    [_circleView setNeedsDisplay];
}

- (NSString *)lastUpdateTimeText
{
    NSDate *currentTime = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:NSSecondCalendarUnit fromDate:_lastUpdateTime toDate:currentTime options:0];
    
    NSInteger seconds = [dateComponents second];
    
    if (seconds < 60) {
        return @"刚刚更新";
    } else if (seconds < 3600) {
        return [NSString stringWithFormat:@"%ld分钟前更新", (long)seconds/60];
    } else if (seconds < 86400) {
        return [NSString stringWithFormat:@"%ld小时前更新", (long)seconds/3600];
    } else {
        return [NSString stringWithFormat:@"%ld天前更新", (long)seconds/86400];
    }
    
    return @"无法更新";
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
