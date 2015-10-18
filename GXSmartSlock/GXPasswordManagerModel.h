//
//  GXPasswordManagerModel.h
//  GXSmartSlock
//
//  Created by zkey on 10/18/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GXDeviceModel.h"

#import "GXPasswordTableViewCellDataModel.h"


typedef void (^compeletionHandler) (NSInteger status);


@interface GXPasswordManagerModel : NSObject

@property (nonatomic, strong, nonnull) GXDeviceModel *deviceModel;

- (nonnull NSArray<NSString *> *)availablePasswordTypeArray;


- (NSInteger)numberOfSectionsInTableView;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (nonnull GXPasswordTableViewCellDataModel *)cellDataForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)synchronizeData:(nullable compeletionHandler)handler;

@end
