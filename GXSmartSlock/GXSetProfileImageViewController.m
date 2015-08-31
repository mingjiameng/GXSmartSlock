//
//  GXSetProfileImageViewController.m
//  GXSmartSlock
//
//  Created by zkey on 8/31/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSetProfileImageViewController.h"

#import "MICRO_COMMON.h"
#import "MICRO_USER_SETTING.h"

#import "GXDatabaseEntityUser.h"
#import "GXDatabaseHelper.h"
#import "GXUpdateProfileImageModel.h"

#import "UIImageView+FHProfileDownload.h"
#import "zkeyViewHelper.h"
#import "zkeyActivityIndicatorView.h"

@interface GXSetProfileImageViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GXUpdateProfileImageModelDelegate>
{
    UIImageView *_headImageView;
    UITableView *_functionListTableView;
    UIImage *_headImage;
    GXUpdateProfileImageModel *_updateProfileModel;
    zkeyActivityIndicatorView *_activityIndicator;
}
@end

@implementation GXSetProfileImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something...
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

- (void)configNavigationBar
{
    self.navigationItem.title = @"头像设置";
}

- (void)addHeadImageView:(CGRect)frame
{
    _headImageView = [[UIImageView alloc] initWithFrame:frame];
    [self setHeadImage:_headImageView];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = frame.size.width / 2.0;
    
    [self.view addSubview:_headImageView];
}

- (void)setHeadImage:(UIImageView *)imageView
{
    UIImage *placeHolderImage = [UIImage imageNamed:@"defaultUserHeadImage"];
    
    GXDatabaseEntityUser *defaultUser = [GXDatabaseHelper defaultUser];
    
    [imageView setProfileWithUrlString:defaultUser.headImageURL placeholderImage:placeHolderImage];
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
        cell.imageView.image = [UIImage imageNamed:USER_SET_HEAD_IMAGE_SELECT_PICTURE];
        cell.textLabel.text = @"从相册选择一张";
    } else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:USER_SET_HEAD_IMAGE_TAKE_PICTURE];
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
    _headImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self alterHeadImage];
    }];
}

- (void)alterHeadImage
{
    _activityIndicator = [[zkeyActivityIndicatorView alloc] initWithFrame:self.view.bounds title:@"正在更换头像..."];
    [self.view addSubview:_activityIndicator];
    
    NSData *headImageData = UIImageJPEGRepresentation(_headImage, 0.1);
    
    if (_updateProfileModel == nil) {
        _updateProfileModel = [[GXUpdateProfileImageModel alloc] init];
        _updateProfileModel.delegate = self;
    }
    
    [_updateProfileModel updateProfileWithImageData:headImageData];
}


- (void)updateProfileImageSuccessful:(BOOL)successful
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
    }
    
    if (successful) {
        [self setHeadImage:_headImageView];
    } else {
        [self alertWithMessage:@"更换头像失败 请重试"];
    }
}

- (void)noNetwork
{
    if (_activityIndicator != nil) {
        [_activityIndicator removeFromSuperview];
    }
    
    [self alertWithMessage:@"无法连接服务器..."];
}

- (void)alertWithMessage:(NSString *)message
{
    [zkeyViewHelper alertWithMessage:message inView:self.view withFrame:self.view.frame];
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
