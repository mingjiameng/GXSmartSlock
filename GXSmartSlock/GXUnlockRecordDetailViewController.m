//
//  GXUnlockRecordDetailViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/24/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXUnlockRecordDetailViewController.h"

#import "MICRO_COMMON.h"
#import "MICRO_DEVICE_LIST.h"

#import "zkeySandboxHelper.h"

@interface GXUnlockRecordDetailViewController ()

@end

@implementation GXUnlockRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavigationBar];
    [self buildDetailView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"事件详情";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildDetailView:(CGRect)frame
{
    UIScrollView *bonusView = [[UIScrollView alloc] initWithFrame:frame];
    bonusView.bounces = YES;
    bonusView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bonusView];
    
    CGFloat horizonalLeadingSpace = 15.0f;
    
    // image view
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(horizonalLeadingSpace, 15.0f, 40.0f, 40.0f)];
    imageView.image = [self deviceImageNameAccordingDeviceCategory:self.viewData.deviceCategory andDeviceIdentifire:self.viewData.deviceIdentifire];
    [bonusView addSubview:imageView];
    
    // product name
    UILabel *productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.0f, 15.0f, frame.size.width - 80.0f, 40.0f)];
    productNameLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    productNameLabel.numberOfLines = 2;
    productNameLabel.textColor = [UIColor blackColor];
    productNameLabel.text = self.viewData.deviceNickname;
    [bonusView addSubview:productNameLabel];
    
    //[self drawSeperatorLineFromPoint:CGPointMake(0.0, 70.0f) toPoint:CGPointMake(frame.size.width, 70.0f)];
    
    UIColor *lightGrayColor = [UIColor lightGrayColor];
    UIColor *dartGrayColor = [UIColor darkGrayColor];
    
    CGFloat titleLabelWidth = 80.0f;
    UILabel *bonusTitleLabel = [self specailLabelWithFrame:CGRectMake(horizonalLeadingSpace, 85.0f, titleLabelWidth, 15.0f) Title:@"门 锁 事 件" color:lightGrayColor];
    [bonusView addSubview:bonusTitleLabel];
    
    
    UILabel *bonusLabel = [[UILabel alloc] initWithFrame:CGRectMake(horizonalLeadingSpace, 100.0f, frame.size.width - 2 * horizonalLeadingSpace, 80.0f)];
    bonusLabel.font = [UIFont systemFontOfSize:14.0f];
    bonusLabel.textColor = dartGrayColor;
    bonusLabel.textAlignment = NSTextAlignmentCenter;
    bonusLabel.text = self.viewData.event;
    [bonusView addSubview:bonusLabel];
    
    CGFloat detailLabelOriginX = horizonalLeadingSpace + titleLabelWidth + 10.0f;
    
    UILabel *dateTitleLabel = [self specailLabelWithFrame:CGRectMake(horizonalLeadingSpace, 200.0f, titleLabelWidth, 15.0f) Title:@"发 生 时 间" color:lightGrayColor];
    [bonusView addSubview:dateTitleLabel];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:self.viewData.date];
    UILabel *dateLabel = [self specailLabelWithFrame:CGRectMake(detailLabelOriginX, 200.0f, frame.size.width - detailLabelOriginX - 15.0f, 15.0f) Title:dateString color:dartGrayColor];
    [bonusView addSubview:dateLabel];
    
    UILabel *statusTitleLabel = [self specailLabelWithFrame:CGRectMake(horizonalLeadingSpace, 230.0f, titleLabelWidth, 15.0f) Title:@"相 关 用 户" color:lightGrayColor];
    [bonusView addSubview:statusTitleLabel];
    
    UILabel *statusLabel = [self specailLabelWithFrame:CGRectMake(detailLabelOriginX, 230.0f, frame.size.width - detailLabelOriginX - 15.0f, 15.0f) Title:self.viewData.relatedUserNickname color:dartGrayColor];
    [bonusView addSubview:statusLabel];
}

- (UIImage *)deviceImageNameAccordingDeviceCategory:(NSString *)deviceCategory andDeviceIdentifire:(NSString *)deviceIdentifire
{
    NSString *deviceImageFilePath = [NSString stringWithFormat:@"%@/%@.png", [zkeySandboxHelper pathOfDocuments], deviceIdentifire];
    if ([zkeySandboxHelper fileExitAtPath:deviceImageFilePath]) {
        return [UIImage imageWithContentsOfFile:deviceImageFilePath];
    }
    
    NSString *imageName = nil;
    
    if ([deviceCategory isEqualToString:DEVICE_CATEGORY_DEFAULT]) {
        imageName = DEVICE_CATEGORY_DEFAULT_IMG;
    } else if ([deviceCategory isEqualToString:DEVICE_CATEGORY_ELECTRIC]) {
        imageName = DEVICE_CATEGORY_ELECTRIC_IMG;
    } else if ([deviceCategory isEqualToString:DEVICE_CATEGORY_GUARD]) {
        imageName = DEVICE_CATEGORY_GUARD_IMG;
    } else {
        NSLog(@"error: invalid device category:%@", deviceCategory);
    }
    
    return [UIImage imageNamed:imageName];
}

- (UILabel *)specailLabelWithFrame:(CGRect)frame Title:(NSString *)title color:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = color;
    label.text = title;
    
    return label;
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
