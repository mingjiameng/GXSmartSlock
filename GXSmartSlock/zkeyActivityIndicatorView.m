//
//  zkeyActivityIndicatorView.m
//  FenHongForIOS
//
//  Created by zkey on 6/13/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "zkeyActivityIndicatorView.h"

@implementation zkeyActivityIndicatorView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // activity indicator
        // defalt size of UIActivityIndicatorViewStyleWhiteLarge is 37*37
        CGFloat activityIndicatorWidth = 37.0;
        CGFloat activityIndicatorHeight = activityIndicatorWidth;
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        // title label
        CGFloat titleLabelHeight = 21;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        UIFont *titleFont = [UIFont systemFontOfSize:15.0];
        titleLabel.font = titleFont;
        
        //...
        CGFloat leadingAndTrailSpace = 30.0;
        CGFloat topAndBottomSpace = 15;
        CGFloat verticalSpace = 10.0;
        // caculate view width
        CGSize maxLabelSize = CGSizeMake(frame.size.height - 2 * leadingAndTrailSpace, 200);
        CGSize labelSize = [title boundingRectWithSize:maxLabelSize options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObjectsAndKeys:titleLabel.font, NSFontAttributeName, nil] context:nil].size;
        
        CGFloat viewWith = MAX(activityIndicatorWidth, labelSize.width) + 2 * leadingAndTrailSpace;
        CGFloat viewHeight = activityIndicatorHeight + labelSize.height + 2 * topAndBottomSpace + verticalSpace;
        
        // cover view
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWith, viewHeight)];
        coverView.center = CGPointMake(frame.size.width / 2.0, frame.size.width / 2.0);
        [self addSubview:coverView];
        
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0.8;
        coverView.layer.masksToBounds = YES;
        coverView.layer.cornerRadius = 5.0;
        
        
        // add activity indicator
        CGRect activityIndicatorFrame = CGRectMake(0, 0, activityIndicatorWidth, activityIndicatorHeight);
        activityIndicator.frame = activityIndicatorFrame;
        activityIndicator.center = CGPointMake(coverView.frame.size.width / 2.0, topAndBottomSpace + activityIndicatorHeight / 2.0);
        [coverView addSubview:activityIndicator];
        // add title lable
        CGRect titleLabelFrame = CGRectMake(0, activityIndicator.frame.origin.y + activityIndicatorHeight + verticalSpace, viewWith, titleLabelHeight);
        titleLabel.frame = titleLabelFrame;
        [coverView addSubview:titleLabel];
        
        // ...
        [activityIndicator startAnimating];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
