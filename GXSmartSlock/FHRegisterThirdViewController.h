//
//  FHRegisterThirdViewController.h
//  FenHongForIOS
//
//  Created by zkey on 8/5/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MICRO_LOGIN.h"

@interface FHRegisterThirdViewController : UIViewController

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *validityCode;
@property (nonatomic) RegisterViewType viewType;

@end
