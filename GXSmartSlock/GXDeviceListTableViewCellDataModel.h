//
//  GXDeviceListTableViewCellDataModel.h
//  GXSmartSlock
//
//  Created by zkey on 8/25/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXDeviceListTableViewCellDataModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic) NSInteger batteryLevel;
@property (nonatomic) NSString *deviceCategory;
@property (nonatomic, strong) NSString *deviceIdentifire;

@end
