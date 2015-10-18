//
//  GXPasswordManagerModel.m
//  GXSmartSlock
//
//  Created by zkey on 10/18/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXPasswordManagerModel.h"

#import "MICRO_PASSWORD.h"

#import "GXDatabaseHelper.h"

#import <CoreData/CoreData.h>


@interface GXPasswordManagerModel ()

@property (nonatomic, strong, nullable) NSFetchedResultsController *currentFetchedResultsController;
@property (nonatomic, strong, nullable) NSFetchedResultsController *remotePasswordFetchedResultsController;
@property (nonatomic, strong, nullable) NSFetchedResultsController *bluetoothOncePasswordFetchedResultsController;
@property (nonatomic, strong, nullable) NSFetchedResultsController *bluetoothNormalPasswordFetchedResultsController;

@end



@implementation GXPasswordManagerModel

- (nonnull NSArray<NSString *> *)availablePasswordTypeArray
{
    if (self.deviceModel.repeaterSupported) {
        return @[@"远程密码", @"蓝牙常用", @"蓝牙临时"];
    } else {
        return @[@"蓝牙常用", @"蓝牙临时"];
    }
    
    return @[@"蓝牙常用", @"蓝牙临时"];
}


- (NSInteger)numberOfSectionsInTableView
{
    if (self.currentFetchedResultsController == nil) {
        return 0;
    }
    
    return [[self.currentFetchedResultsController sections] count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    if (self.currentFetchedResultsController == nil) {
        return 0;
    }
    
    return [[[self.currentFetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (nonnull GXPasswordTableViewCellDataModel *)cellDataForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    GXPasswordTableViewCellDataModel *cellData = [[GXPasswordTableViewCellDataModel alloc] init];
    
    
    
    return cellData;
}

- (nullable NSFetchedResultsController *)remotePasswordFetchedResultsController
{
    if (!_remotePasswordFetchedResultsController) {
        _remotePasswordFetchedResultsController = ({
            NSFetchedResultsController *fetchedResultsController = [GXDatabaseHelper passwordFetchedResultsContrllerWithPasswordType:nil addedFrom:PASSWORD_ADDED_APPROACH_REMOTE];
            
            fetchedResultsController;
        });
    }
    
    return _remotePasswordFetchedResultsController;
}


- (nullable NSFetchedResultsController *)bluetoothNormalPasswordFetchedResultsController
{
    if (!_bluetoothNormalPasswordFetchedResultsController) {
        _bluetoothNormalPasswordFetchedResultsController = ({
            NSFetchedResultsController *fetchedResultsController = [GXDatabaseHelper passwordFetchedResultsContrllerWithPasswordType:PASSWORD_TYPE_NORMAL addedFrom:PASSWORD_ADDED_APPROACH_BLUETOOTH];
            
            fetchedResultsController;
        });
    }
    
    return _bluetoothNormalPasswordFetchedResultsController;
}

- (NSFetchedResultsController *)bluetoothOncePasswordFetchedResultsController
{
    if (!_bluetoothOncePasswordFetchedResultsController) {
        _bluetoothOncePasswordFetchedResultsController = ({
            NSFetchedResultsController *fetchedResultsController = [GXDatabaseHelper passwordFetchedResultsContrllerWithPasswordType:PASSWORD_TYPE_ONCE addedFrom:PASSWORD_ADDED_APPROACH_BLUETOOTH];
            
            fetchedResultsController;
        });
    }
    
    return _bluetoothOncePasswordFetchedResultsController;
}

@end
