//
//  GXRefreshOneTimePasswordViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/25/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXRefreshOneTimePasswordViewController.h"

@interface GXRefreshOneTimePasswordViewController ()

@property (nonatomic, strong) UIImageView *animationView;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation GXRefreshOneTimePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"获取新密码";
    
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.animationView];
}

- (void)refreshPassword
{
    
}

#pragma mark - view

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        CGRect frame = self.view.frame;
        _tipsLabel = ({
            _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, 21)];
            _tipsLabel.text = @"请按下门锁上的设置键，并将手机靠近门锁";
            _tipsLabel.font = [UIFont systemFontOfSize:15.0];
            _tipsLabel.textAlignment = NSTextAlignmentCenter;
            
            _tipsLabel;
        });
    }
    
    return _tipsLabel;
}

- (UIImageView *)animationView
{
    if (!_animationView) {
        CGRect frame = self.view.frame;
        _animationView = ({
            _animationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80 , frame.size.width, frame.size.width / 1.6)];
            _animationView.userInteractionEnabled = NO;
            
            NSArray *imageArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AddNewDeviceAnimationImage" ofType:@"plist"]];
            NSMutableArray *images = [NSMutableArray array];
            for (NSString *oneImage in imageArray) {
                [images addObject:[UIImage imageNamed:oneImage]];
            }
            
            _animationView.animationImages = (NSArray *)images;
            _animationView.animationDuration = 0.3 * imageArray.count;
            _animationView.animationRepeatCount = 0;
            [_animationView startAnimating];
            
            _animationView;
        });
    }
    
    return _animationView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
