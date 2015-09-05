//
//  GXAddNewDeviceView.h
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 6/20/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GXAddNewDeviceViewDelegate <NSObject>

- (void)setNewDeviceName:(NSString *)deviceName;
- (void)cancelAddNewDevice;

@end

@interface GXAddNewDeviceView : UIView

@property (nonatomic, assign) id<GXAddNewDeviceViewDelegate> delegate;

- (void)setNewDeviceName;
- (void)pressWrongButtonToInitialize;

@end
