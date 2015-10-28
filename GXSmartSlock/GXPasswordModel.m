//
//  GXPasswordModel.m
//  GXSmartSlock
//
//  Created by zkey on 10/18/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXPasswordModel.h"

#import "MICRO_PASSWORD.h"

@implementation GXPasswordModel

+ (GXPasswordType)passwordTypeAccordingToString:(NSString *)passwordString
{
    if ([passwordString isEqualToString:PASSWORD_TYPE_NORMAL]) {
        return GXPasswordTypeNormal;
    } else if ([passwordString isEqualToString:PASSWORD_TYPE_ONCE]) {
        return GXPasswordTypeOnce;
    } else if ([passwordString isEqualToString:PASSWORD_TYPE_TEMPORARY]) {
        return GXPasswordTypeTemporary;
    }
    
    return GXPasswordTypeOnce;
}

+ (GXPasswordAddedApproach)passwordAddedApproachAccordingToString:(nonnull NSString *)passwordAddedApproachString
{
    if ([passwordAddedApproachString isEqualToString:PASSWORD_ADDED_APPROACH_REMOTE]) {
        return GXPasswordAddedApproachRemote;
    } else if ([passwordAddedApproachString isEqualToString:PASSWORD_ADDED_APPROACH_BLUETOOTH]) {
        return GXPasswordAddedApproachBluetooth;
    }
    
    return GXPasswordAddedApproachBluetooth;
}

+ (nonnull NSString *)passwordStatusDescription:(GXPasswordStatus)status
{
    switch (status) {
        case GXPasswordStatusSuccessToSet:
            return @"密码设置成功";
            
        case GXPasswordStatusWaitingForProccessing:
            return @"等待服务器处理";
            
        case GXPasswordStatusFailToSet:
            return @"密码设置失败";

        case GXPasswordStatusIsProcessing:
            return @"服务器正在处理中";

        case GXPasswordStatusIsDeleting:
            return @"服务器正在删除该密码";

        case GXPasswordStatusIsActiving:
            return @"服务器正在激活该密码";

        case GXPasswordStatusIsFreezing:
            return @"服务器正在冻结该密码";

        case GXPasswordStatusIsUpdating:
            return @"服务器正在更新该密码";

        case GXPasswordStatusWrongCommand:
            return @"错误的指令";

        case GXPasswordStatusFailedToAdd:
            return @"密码设置失败";

        case GXPasswordStatusFailedToDelete:
            return @"密码删除失败";

        case GXPasswordStatusFailedToActive:
            return @"密码激活失败";
            
        case GXPasswordStatusFailedToFreeze:
            return @"密码冻结失败";

        case GXPasswordStatusFailedToUpdating:
            return @"密码更新失败";

        case GXPasswordStatusFailed:
            return @"失败 未知错误";
    }
    
    return @"设置失败";

}

+ (nonnull GXPasswordModel *)passwordModelWithCoreDataEntity:(nonnull GXDatabaseEntityPassword *)passwordEntity
{
    if (passwordEntity == nil) {
        return nil;
    }
    
    GXPasswordModel *passwordModel = [[GXPasswordModel alloc] init];
    
    passwordModel.passwordID = [passwordEntity.passwordID integerValue];
    passwordModel.passwordNickname = passwordEntity.passwordNickname;
    passwordModel.passwordTypeString = passwordEntity.passwordType;
    passwordModel.actived = [passwordEntity.actived boolValue];
    passwordModel.startDate = passwordEntity.startDate;
    passwordModel.endDate = passwordEntity.endDate;
    passwordModel.password = passwordEntity.password;
    passwordModel.addedApproach = passwordEntity.passwordAddedApproach;
    passwordModel.passwordStatus = [passwordEntity.passwordStatus integerValue];
    passwordModel.deviceIdentifire = passwordEntity.deviceIdentifire;
    
    return passwordModel;
}

@end
