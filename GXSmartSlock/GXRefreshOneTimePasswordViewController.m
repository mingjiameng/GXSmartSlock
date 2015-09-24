//
//  GXRefreshOneTimePasswordViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/25/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXRefreshOneTimePasswordViewController.h"

#import "GXOccasionalPasswordManager.h"
#import "GXOneTimePasswordModel.h"

@interface GXRefreshOneTimePasswordViewController () <GXOccasionalPwdDelegate>
{
    NSMutableArray *_newPasswordArray;
}
@property (nonatomic, strong) UIImageView *animationView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) GXOccasionalPasswordManager *oneTimePasswordManager;

@end

@implementation GXRefreshOneTimePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavigationBar];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.animationView];
    [self refreshPassword];
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"获取新密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissVC)];
}

- (void)refreshPassword
{
    [self.oneTimePasswordManager getOccasionalPassword];
}

- (void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - delegate
- (void)addOccasionalPassword:(GXOccasionalPasswordManager *)occasionPassword password:(NSString *)password password_used:(BOOL)passwordUsed cout:(NSInteger)passwordCount
{
    //NSLog(@"password:%@ used:%@ count:%ld", password, @(passwordUsed), (long)passwordCount);
    if (_newPasswordArray == nil) {
        _newPasswordArray = [NSMutableArray array];
    }
    
    GXOneTimePasswordModel *passwordModel = [[GXOneTimePasswordModel alloc] init];
    passwordModel.deviceIdentifre = self.deviceIdentifire;
    passwordModel.password = password;
    passwordModel.validity = YES;
    [_newPasswordArray addObject:passwordModel];
    
    if (_newPasswordArray.count >= 10) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.passwordArrayReceived) {
                self.passwordArrayReceived(_newPasswordArray);
            }
        }];
    }
}

- (void)addOccasionalPassword:(GXOccasionalPasswordManager *)occasionPassword  count:(NSInteger)passwordCount
{
    
}


#pragma mark - view
- (GXOccasionalPasswordManager *)oneTimePasswordManager
{
    if (!_oneTimePasswordManager) {
        _oneTimePasswordManager = ({
            _oneTimePasswordManager = [[GXOccasionalPasswordManager alloc] initWithCurrentDeviceName:self.deviceIdentifire];
            _oneTimePasswordManager.delegate = self;
        
            _oneTimePasswordManager;
        });
    }
    
    return _oneTimePasswordManager;
}

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
