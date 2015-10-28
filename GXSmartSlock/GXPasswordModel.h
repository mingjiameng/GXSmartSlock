//
//  GXPasswordModel.h
//  GXSmartSlock
//
//  Created by zkey on 10/18/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GXDatabaseEntityPassword.h"

typedef NS_ENUM(NSInteger, GXPasswordType) {
    GXPasswordTypeNormal = 10,
    GXPasswordTypeOnce = 20,
    GXPasswordTypeTemporary = 30
};

typedef NS_ENUM(NSInteger, GXPasswordStatus) {
    GXPasswordStatusSuccessToSet = 0,
    GXPasswordStatusWaitingForProccessing = 1,
    GXPasswordStatusFailToSet = 2,
    GXPasswordStatusIsProcessing = 3,
    GXPasswordStatusIsDeleting = 4,
    GXPasswordStatusIsActiving = 5,
    GXPasswordStatusIsFreezing = 6,
    GXPasswordStatusIsUpdating = 7,
    GXPasswordStatusWrongCommand = 8,
    GXPasswordStatusFailedToAdd = 103,
    GXPasswordStatusFailedToDelete = 104,
    GXPasswordStatusFailedToActive = 105,
    GXPasswordStatusFailedToFreeze = 106,
    GXPasswordStatusFailedToUpdating = 107,
    GXPasswordStatusFailed = 108
//    0：成功
//    1：正在等待处理
//    2：设置失败，异常
//    3：正在设置密码
//    4：正在删除密码
//    5：正在激活密码
//    6：正在冻结密码
//    7：正在更新密码
//    8：命令类型错误
//    103：添加失败
//    104：删除失败
//    105：激活失败 
//    106：冻结失败 
//    107：更新失败 
//    108：失败
};

typedef NS_ENUM(NSInteger, GXPasswordAddedApproach) {
    GXPasswordAddedApproachRemote = 10,
    GXPasswordAddedApproachBluetooth = 20
};

@interface GXPasswordModel : NSObject

@property (nonatomic) NSInteger passwordID;
@property (nonatomic, strong, nonnull) NSString *passwordNickname;
@property (nonatomic, strong, nonnull) NSString *passwordTypeString;
@property (nonatomic) BOOL actived;
@property (nonatomic, strong, nullable) NSDate *startDate;
@property (nonatomic, strong, nullable) NSDate *endDate;
@property (nonatomic, strong, nullable) NSString *password;
@property (nonatomic, strong, nonnull) NSString *addedApproach;
@property (nonatomic) NSInteger passwordStatus;
@property (nonatomic, strong, nonnull) NSString *deviceIdentifire;

+ (GXPasswordType)passwordTypeAccordingToString:(nonnull NSString *)passwordString;
+ (GXPasswordAddedApproach)passwordAddedApproachAccordingToString:(nonnull NSString *)passwordTypeString;
+ (nonnull NSString *)passwordStatusDescription:(GXPasswordStatus)status;
+ (nonnull GXPasswordModel *)passwordModelWithCoreDataEntity:(nonnull GXDatabaseEntityPassword *)passwordEntity;

@end
