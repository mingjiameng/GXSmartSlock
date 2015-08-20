//
//  GXGuidePageViewController.m
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 7/17/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXGuidePageViewController.h"

#import <sys/utsname.h>

#import "GXRootViewController.h"

typedef NS_ENUM(NSInteger, DeviceVersion) {
    DeviceVersion4s = 10,
    DeviceVersion5 = 20,
    DeviceVersion5c = 30,
    DeviceVersion5s = 40,
    DeviceVersion6 = 50,
    DeviceVersion6plus = 60
};

@interface GXGuidePageViewController () <UIScrollViewDelegate>
{
    UIPageControl *_guidePageControl;
    UIScrollView *_guidePageScrollView;
}
@end



@implementation GXGuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // loading the guide page scorllView
    [self addGuidePageScorllView:self.view.bounds];
    
    
}


- (void)addGuidePageScorllView:(CGRect)frame
{
    // image file name array
    NSArray *imageFileNameArray = [self getGuideImageNameArray];
    
    _guidePageScrollView = [[UIScrollView alloc] initWithFrame:frame];
    _guidePageScrollView.pagingEnabled = YES;
    _guidePageScrollView.showsHorizontalScrollIndicator = NO;
    _guidePageScrollView.showsVerticalScrollIndicator = NO;
    _guidePageScrollView.bounces = NO;
    _guidePageScrollView.contentSize = CGSizeMake(frame.size.width * imageFileNameArray.count, frame.size.height);
    _guidePageScrollView.delegate = self;
    [self.view addSubview:_guidePageScrollView];
    
    CGFloat pageWidth = _guidePageScrollView.frame.size.width;
    CGFloat pageHeight = _guidePageScrollView.frame.size.height;
    
    // add image one by one
    for (NSInteger index = 0; index < imageFileNameArray.count; ++index) {
        NSString *imageFileName = [imageFileNameArray objectAtIndex:index];
        NSString *pathForImage = [[NSBundle mainBundle] pathForResource:imageFileName ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:pathForImage];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * pageWidth, 0, pageWidth, pageHeight)];
        imageView.image = image;
        [_guidePageScrollView addSubview:imageView];
    }
    
    // add enterAppButton
    UIButton *enterAppButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width * (imageFileNameArray.count - 1), pageHeight * 0.75, pageWidth, pageHeight * 0.25)];
    enterAppButton.backgroundColor = [UIColor clearColor];
    [enterAppButton setTitle:@"" forState:UIControlStateNormal];
    [enterAppButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [enterAppButton addTarget:self action:@selector(clickEnterAppButton:) forControlEvents:UIControlEventTouchUpInside];
    [_guidePageScrollView addSubview:enterAppButton];
    
    // add guide page control
    CGFloat widthOfGuidePageControl = 80.0;
    _guidePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.view.frame.size.width - widthOfGuidePageControl) / 2.0, self.view.frame.size.height - 60.0, widthOfGuidePageControl, 20.0)];
    _guidePageControl.userInteractionEnabled = NO;
    _guidePageControl.numberOfPages = imageFileNameArray.count;
    _guidePageControl.currentPage = 0;
    [self.view addSubview:_guidePageControl];
}

- (void)clickEnterAppButton:(UIButton *)sender
{
    GXRootViewController *rootVC = [[GXRootViewController alloc] init];
    self.view.window.rootViewController = rootVC;
}

- (NSArray *)getGuideImageNameArray
{
    // find the current device
    struct utsname systemInfo;
    uname(&systemInfo);
    
    DeviceVersion version = [self getDeviceVersion:[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]];
    
    NSInteger versionIndex = 3;
    
    if (version == DeviceVersion4s) {
        versionIndex = 0;
    } else if (version == DeviceVersion5 || version == DeviceVersion5c || version == DeviceVersion5s) {
        versionIndex = 1;
    } else if (version == DeviceVersion6) {
        versionIndex = 2;
    } else if (version == DeviceVersion6plus) {
        versionIndex = 3;
    }
    
    // load device name plist file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"guidePageImgSource" ofType:@"plist"];
    NSArray *imageNameArray = [NSArray arrayWithContentsOfFile:filePath];
    
    return [imageNameArray objectAtIndex:versionIndex];
}

- (DeviceVersion)getDeviceVersion:(NSString *)platform
{
    if ([platform isEqualToString:@"iPhone4,1"]) return DeviceVersion4s;
    if ([platform isEqualToString:@"iPhone5,1"]) return DeviceVersion5;
    if ([platform isEqualToString:@"iPhone5,2"]) return DeviceVersion5;
    if ([platform isEqualToString:@"iPhone5,3"]) return DeviceVersion5c;
    if ([platform isEqualToString:@"iPhone5,4"]) return DeviceVersion5c;
    if ([platform isEqualToString:@"iPhone6,1"]) return DeviceVersion5s;
    if ([platform isEqualToString:@"iPhone6,2"]) return DeviceVersion5s;
    if ([platform isEqualToString:@"iPhone7,1"]) return DeviceVersion6plus;
    if ([platform isEqualToString:@"iPhone7,2"]) return DeviceVersion6;
    
    return DeviceVersion6plus;
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat xOffset = scrollView.contentOffset.x;
    NSInteger currentPage = (xOffset + scrollView.frame.size.width / 2.0) / scrollView.frame.size.width;
    _guidePageControl.currentPage = currentPage;
    
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
