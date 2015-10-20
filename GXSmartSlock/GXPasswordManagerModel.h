//
//  GXPasswordManagerModel.h
//  GXSmartSlock
//
//  Created by zkey on 10/18/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GXDeviceModel.h"
#import "GXPasswordModel.h"

#import "GXPasswordTableViewCellDataModel.h"


typedef void (^compeletionHandler) (NSInteger status);

@protocol GXPasswordManagerModelDelegate <NSObject>

// user interaction
//- (void)noNetwork;
//- (void)didEndUploadingDataSuccessful:(BOOL)success;

@required
// database change
- (void)beginUpdates;
- (void)insertSection:(NSUInteger)sectionIndex;
- (void)deleteSection:(NSUInteger)sectionIndex;
- (void)insertRowAtIndexPath:(nonnull NSIndexPath *)indexPath;
- (void)deleteRowAtIndexPath:(nonnull NSIndexPath *)indexPath;
- (void)reloadRowAtIndexPath:(nonnull NSIndexPath *)indexPath;
- (void)endUpdates;
- (void)reloadTableView;

@end



@interface GXPasswordManagerModel : NSObject

@property (nonatomic, strong, nonnull) GXDeviceModel *deviceModel;
@property (nonatomic, strong, nonnull) id<GXPasswordManagerModelDelegate> delegate;

- (nonnull NSArray<NSString *> *)availablePasswordTypeArray;


- (NSInteger)numberOfSectionsInTableView;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (nonnull GXPasswordTableViewCellDataModel *)cellDataForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (nonnull GXPasswordModel *)passwordModelForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

/*
 * user action
 */
- (void)synchronizeData:(nullable compeletionHandler)handler;
- (void)selectPasswordType:(nonnull NSString *)passwordType;

@end
