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
#import "GXDefaultHttpHelper.h"
#import "GXDatabaseEntityPassword.h"
#import "GXSynchronizePasswordParam.h"

#import <CoreData/CoreData.h>


@interface GXPasswordManagerModel () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, nullable) NSFetchedResultsController *currentFetchedResultsController;
@property (nonatomic, strong, nullable) NSFetchedResultsController *remotePasswordFetchedResultsController;
@property (nonatomic, strong, nullable) NSFetchedResultsController *bluetoothOncePasswordFetchedResultsController;
@property (nonatomic, strong, nullable) NSFetchedResultsController *bluetoothNormalPasswordFetchedResultsController;

@property (nonatomic, strong, nonnull) NSDictionary *availablePasswordTypeDic; // <NSString : NSFetchedResultsController> NSString is the title for Segment in navigation bar

@end



@implementation GXPasswordManagerModel

- (void)selectPasswordType:(NSString *)passwordType
{
    self.currentFetchedResultsController = [self.availablePasswordTypeDic objectForKey:passwordType];
    
    [self.delegate reloadTableView];
}

- (nonnull NSArray<NSString *> *)availablePasswordTypeArray
{
    if (self.deviceModel.hasRepeater) {
        self.availablePasswordTypeDic = @{@"远程密码" : self.remotePasswordFetchedResultsController,
                                          @"蓝牙常用" : self.bluetoothNormalPasswordFetchedResultsController,
                                          @"蓝牙临时" : self.bluetoothOncePasswordFetchedResultsController};
    } else {
        self.availablePasswordTypeDic = @{@"蓝牙常用" : self.bluetoothNormalPasswordFetchedResultsController,
                                          @"蓝牙临时" : self.bluetoothOncePasswordFetchedResultsController};
    }
    
    return [self.availablePasswordTypeDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
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
    
    GXDatabaseEntityPassword *passwordEntity = [self.currentFetchedResultsController objectAtIndexPath:indexPath];
    cellData.passwordNickname = passwordEntity.passwordNickname;
    
    if ([passwordEntity.actived boolValue]) {
        cellData.statusDescription = @"有效";
    } else {
        cellData.statusDescription = @"无效";
    }
    
    return cellData;
}

- (nonnull GXPasswordModel *)passwordModelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXPasswordModel *passwordModel = [[GXPasswordModel alloc] init];
    
    return passwordModel;
}

- (void)synchronizeData:(compeletionHandler)handler
{
    NSString *accessToken = nil;
    
    if (handler) {
        handler(0);
    }
    
    GXSynchronizePasswordParam *param = [[GXSynchronizePasswordParam alloc] init];
    param.accessToken = accessToken;
    param.deviceIdentifire = self.deviceModel.deviceIdentifire;
    
    [GXDefaultHttpHelper postWithSynchronizePasswordParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:@"err"] integerValue];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - database

- (nullable NSFetchedResultsController *)remotePasswordFetchedResultsController
{
    if (!_remotePasswordFetchedResultsController) {
        _remotePasswordFetchedResultsController = ({
            NSFetchedResultsController *fetchedResultsController = [GXDatabaseHelper device:self.deviceModel.deviceIdentifire passwordFetchedResultsContrllerWithPasswordType:nil addedFrom:PASSWORD_ADDED_APPROACH_REMOTE];
            
            fetchedResultsController.delegate = self;
            
            fetchedResultsController;
        });
    }
    
    return _remotePasswordFetchedResultsController;
}

- (nullable NSFetchedResultsController *)bluetoothNormalPasswordFetchedResultsController
{
    if (!_bluetoothNormalPasswordFetchedResultsController) {
        _bluetoothNormalPasswordFetchedResultsController = ({
            NSFetchedResultsController *fetchedResultsController = [GXDatabaseHelper device:self.deviceModel.deviceIdentifire passwordFetchedResultsContrllerWithPasswordType:PASSWORD_TYPE_NORMAL addedFrom:PASSWORD_ADDED_APPROACH_BLUETOOTH];
            
            fetchedResultsController.delegate = self;
            
            fetchedResultsController;
        });
    }
    
    return _bluetoothNormalPasswordFetchedResultsController;
}

- (NSFetchedResultsController *)bluetoothOncePasswordFetchedResultsController
{
    if (!_bluetoothOncePasswordFetchedResultsController) {
        _bluetoothOncePasswordFetchedResultsController = ({
            NSFetchedResultsController *fetchedResultsController = [GXDatabaseHelper device:self.deviceModel.deviceIdentifire passwordFetchedResultsContrllerWithPasswordType:PASSWORD_TYPE_ONCE addedFrom:PASSWORD_ADDED_APPROACH_BLUETOOTH];
            
            fetchedResultsController.delegate = self;
            
            fetchedResultsController;
        });
    }
    
    return _bluetoothOncePasswordFetchedResultsController;
}

#pragma mark - database change
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.delegate beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if (type == NSFetchedResultsChangeInsert) {
        [self.delegate insertSection:sectionIndex];
    } else if (type == NSFetchedResultsChangeDelete) {
        [self.delegate deleteSection:sectionIndex];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.delegate insertRowAtIndexPath:newIndexPath];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.delegate deleteRowAtIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.delegate reloadRowAtIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.delegate deleteRowAtIndexPath:indexPath];
            [self.delegate insertRowAtIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.delegate endUpdates];
}

@end
