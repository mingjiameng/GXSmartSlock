//
//  GXSendKeyViewController.h
//  GXSmartSlock
//
//  Created by zkey on 8/26/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

typedef NS_ENUM(NSInteger, GXSendKeyViewType) {
    GXSendKeyViewTypeMutipleDevice = 10,
    GXSendKeyViewTypeCertainDevice = 20
};

@interface GXSendKeyViewController : UIViewController

@property (nonatomic) GXSendKeyViewType viewType;

@property (nonatomic, copy, nullable) NSString *deviceIdentifire;

@end
