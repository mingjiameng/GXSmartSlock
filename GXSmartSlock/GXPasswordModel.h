//
//  GXPasswordModel.h
//  GXSmartSlock
//
//  Created by zkey on 10/18/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, GXPasswordType) {
    GXPasswordTypeNormal = 10,
    GXPasswordTypeOnce = 20,
    GXPasswordTypeTemporary = 30
};

typedef NS_ENUM(NSInteger, GXPasswordStatus) {
    GXPasswordStatusSuccess = 0,
    GXPasswordStatusWaitingForProccessing = 1
    
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

+ (GXPasswordType)passwordTypeAccordingToString:(nonnull NSString *)passwordString;

@end
