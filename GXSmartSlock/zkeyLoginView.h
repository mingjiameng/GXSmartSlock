//
//  zkeyLoginView.h
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 7/9/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol zkeyLoginViewDelegate <NSObject>
@required
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password;
- (void)clickRegisterButton;

@optional
- (void)clickForgetPasswordButton;

@end

@interface zkeyLoginView : UIView

@property (nonatomic, weak) id<zkeyLoginViewDelegate> delegate;

- (void)noNetworkToLogin;
- (void)successfullyLogin;
- (void)wrongUserNameOrPassword;

@end
