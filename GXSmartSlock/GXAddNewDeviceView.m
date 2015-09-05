//
//  GXAddNewDeviceView.m
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 6/20/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXAddNewDeviceView.h"
#import "MICRO_ADD_NEW_DEVICE.h"
#import "MICRO_COMMON.h"

#import "zkeyViewHelper.h"

@interface GXAddNewDeviceView () <UITextFieldDelegate, UIAlertViewDelegate>
{
    UIImageView *_animationView;
    UITextView *_tipsTextView;
    UITextField *_deviceNameTextField;
    UIAlertView *_deviceNameInput;
}
@end

@implementation GXAddNewDeviceView

#pragma mark - initialize
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        const CGFloat verticalSpace = 15.0;
        CGFloat tipsFrameHeight = 120;
        CGRect tipsFrame = CGRectMake(20, verticalSpace, frame.size.width - 40, tipsFrameHeight);
        [self addTips:tipsFrame];
        
        CGRect animationFrame = CGRectMake(0, 2 * verticalSpace + tipsFrameHeight, frame.size.width, frame.size.width / 1.6);
        [self addAnimation:animationFrame];
    }
    
    return self;
}

- (void)addTips:(CGRect)frame
{
    _tipsTextView = [[UITextView alloc] initWithFrame:frame];
    _tipsTextView.text = @"在初始化过程中请保持网络连接\n\n请按下门锁上的设置键并将手机靠近门锁";
    _tipsTextView.textColor = [UIColor blackColor];
    _tipsTextView.font = [UIFont systemFontOfSize:17.0];
    _tipsTextView.userInteractionEnabled = NO;
    
    [self addSubview:_tipsTextView];
}

- (void)addAnimation:(CGRect)frame
{
    _animationView = [[UIImageView alloc] initWithFrame:frame];
    _animationView.userInteractionEnabled = NO;
    
    NSArray *imageArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ANIMATION_IMG_FILE ofType:@"plist"]];
    NSMutableArray *images = [NSMutableArray array];
    for (NSString *oneImage in imageArray) {
        [images addObject:[UIImage imageNamed:oneImage]];
    }
    
    _animationView.animationImages = (NSArray *)images;
    _animationView.animationDuration = 0.3 * imageArray.count;
    _animationView.animationRepeatCount = 0;
    [_animationView startAnimating];

    [self addSubview:_animationView];
}

#pragma mark - functions

- (void)pressWrongButtonToInitialize
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"果心提示" message:@"配对需按设置键，请勿按开锁键。" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}

- (void)failToPair
{
    [zkeyViewHelper alertWithMessage:@"配对失败，请重新尝试" inView:self withFrame:self.frame];
}

- (void)setNewDeviceName
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _deviceNameInput = [[UIAlertView alloc] initWithTitle:@"请为您的新门锁命名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        _deviceNameInput.alertViewStyle = UIAlertViewStylePlainTextInput;
        _deviceNameTextField = [_deviceNameInput textFieldAtIndex:0];
        _deviceNameTextField.placeholder = @"2-8个字符";
        [_deviceNameInput show];
        [_deviceNameTextField becomeFirstResponder];
    });
}

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *deviceName = textField.text;
    NSString *tmpDeviceName = [deviceName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (tmpDeviceName.length <= 0) {
        return NO;
    }
    
    [textField resignFirstResponder];
    
    [self.delegate setNewDeviceName:deviceName];
    
    return YES;
}

#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_deviceNameTextField resignFirstResponder];
    
    if (buttonIndex == 1) {
        [self.delegate setNewDeviceName:_deviceNameTextField.text];
    } else if (buttonIndex == 0) {
        [self.delegate cancelAddNewDevice];
    }
    
    
}

@end
