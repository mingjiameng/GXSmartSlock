//
//  GXChangeDeviceImageViewController.m
//  GXSmartSlock
//
//  Created by zkey on 8/27/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXChangeDeviceImageViewController.h"

#import "MICRO_COMMON.h"
#import "MICRO_DEVICE_LIST.h"

#import "zkeyViewHelper.h"
#import "zkeySandboxHelper.h"
#import "GXDatabaseEntityDevice.h"

#import "zkeyActivityIndicatorView.h"

@interface GXChangeDeviceImageViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImageView *_deviceImageView;
    UITableView *_functionListTableView;
    NSString *_deviceImageFilePath;
    UIImage *_deviceImage;
}
@end

@implementation GXChangeDeviceImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something...
    self.title = @"门锁图片";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGFloat topSpace = 30.0;
    CGFloat headImageButtonWidth = 100.0;
    CGRect headImageButtonFrame = CGRectMake((self.view.frame.size.width - headImageButtonWidth) / 2.0, topSpace, headImageButtonWidth, headImageButtonWidth);
    [self addHeadImageView:headImageButtonFrame];
    
    CGFloat betweenSpace = 50.0;
    CGFloat originY = topSpace + headImageButtonWidth + betweenSpace;
    CGRect functionListFrame = CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY - TOP_SPACE_IN_NAVIGATION_MODE);
    [self addFunctionList:functionListFrame];
}

- (void)addHeadImageView:(CGRect)frame
{
    _deviceImageView = [[UIImageView alloc] initWithFrame:frame];
    [self setDeviceImage:_deviceImageView];
    _deviceImageView.layer.masksToBounds = YES;
    _deviceImageView.layer.cornerRadius = frame.size.width / 2.0;
    
    [self.view addSubview:_deviceImageView];
}

- (void)setDeviceImage:(UIImageView *)imageView
{
    if ([zkeySandboxHelper fileExitAtPath:[self deviceImageFilePath]]) {
        imageView.image = [UIImage imageWithContentsOfFile:[self deviceImageFilePath]];
    } else {
        imageView.image = [UIImage imageNamed:[self deviceImageNameAccordingDeviceCategory]];
    }
}

- (NSString *)deviceImageNameAccordingDeviceCategory
{
    NSString *deviceCategory = self.deviceEntity.deviceCategory;
    if ([deviceCategory isEqualToString:DEVICE_CATEGORY_DEFAULT]) {
        return DEVICE_CATEGORY_DEFAULT_IMG;
    } else if ([deviceCategory isEqualToString:DEVICE_CATEGORY_ELECTRIC]) {
        return DEVICE_CATEGORY_ELECTRIC_IMG;
    } else if ([deviceCategory isEqualToString:DEVICE_CATEGORY_GUARD]) {
        return DEVICE_CATEGORY_GUARD_IMG;
    } else {
        NSLog(@"error: invalid device category");
    }
    
    return DEVICE_CATEGORY_DEFAULT_IMG;
}

- (void)addFunctionList:(CGRect)frame
{
    _functionListTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _functionListTableView.backgroundColor = [UIColor clearColor];
    [zkeyViewHelper hideExtraSeparatorLine:_functionListTableView];
    [_functionListTableView setScrollEnabled:NO];
    
    _functionListTableView.dataSource = self;
    _functionListTableView.delegate = self;
    [self.view addSubview:_functionListTableView];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:SET_DEVICE_IMAGE_SELECT_PICTURE];
        cell.textLabel.text = @"从相册选择一张";
    } else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:SET_DEVICE_IMAGE_TAKE_PICTURE];
        cell.textLabel.text = @"拍一张照片";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self presentImagePickerController];
    } else if (indexPath.row == 1) {
        [self presentCameraPickerController];
    }
}


#pragma mark - function
- (void)presentImagePickerController
{
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        photoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    photoPicker.allowsEditing = YES;
    photoPicker.delegate = self;
    
    [self presentViewController:photoPicker animated:YES completion:^{
        
    }];
}

- (void)presentCameraPickerController
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.allowsEditing = YES;
        cameraPicker.delegate = self;
        
        [self presentViewController:cameraPicker animated:YES completion:nil];
    } else {
        // 摄像头不可用
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _deviceImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self alterDeviceImage];
    }];
}

- (void)alterDeviceImage
{
    zkeyActivityIndicatorView *activityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.view.frame title:@"正在更换门锁图片..."];
    [self.view addSubview:activityIndicator];
    
    [zkeySandboxHelper deleteFileAtPath:[self deviceImageFilePath]];
    
    NSData *imageData = UIImagePNGRepresentation(_deviceImage);
    
    [imageData writeToFile:[self deviceImageFilePath] atomically:YES];
    
    [self setDeviceImage:_deviceImageView];
    
    if (self.deviceImageChanged) {
        self.deviceImageChanged(YES);
    }
    
    [activityIndicator removeFromSuperview];
    activityIndicator = nil;
}

- (NSString *)deviceImageFilePath
{
    if (_deviceImageFilePath == nil) {
        _deviceImageFilePath = [NSString stringWithFormat:@"%@/%@.png", [zkeySandboxHelper pathOfDocuments], self.deviceEntity.deviceIdentifire];
    }
    
    return _deviceImageFilePath;
}


@end
