//
//  GXAddNewPermanentPasswordViewController.h
//  GXSmartSlock
//
//  Created by zkey on 9/12/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GXDevicePermanentPsswordModel.h"

@interface GXAddNewPermanentPasswordViewController : UIViewController

@property (nonatomic, copy) void (^addNewPassword) (GXDevicePermanentPsswordModel *passwordModel);

@end
