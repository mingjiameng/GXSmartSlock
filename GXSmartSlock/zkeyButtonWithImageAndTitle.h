//
//  zkeyButtonWithImageAndTitle.h
//  FenHongForIOS
//
//  Created by zkey on 7/21/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zkeyButtonWithImageAndTitle : UIButton

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *bottomTitleLabel;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title titleFontSize:(CGFloat)fontSize titleColor:(UIColor *)color image:(UIImage *)image imageSize:(CGFloat)imageSize;

@end
