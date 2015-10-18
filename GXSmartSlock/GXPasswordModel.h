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

@interface GXPasswordModel : NSObject

@property (nonatomic, strong, nonnull) NSString *passwordNickname;
@property (nonatomic, strong, nonnull) NSString *passwordTypeString;
@property (nonatomic) BOOL actived;
@property (nonatomic, strong, nullable) NSDate *startDate;
@property (nonatomic, strong, nullable) NSDate *endDate;
@property (nonatomic, strong, nullable) NSString *password;
@property (nonatomic, strong, nonnull) NSString *addedApproach;

+ (GXPasswordType)passwordTypeAccordingToString:(nonnull NSString *)passwordString;

@end
