//
//  GXPMInfomationCollect.h
//  GXBLESmartHomeFurnishing
//
//  Created by wjq on 14-12-30.
//  Copyright (c) 2014年 guosim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSUUID+help.h"
#import "Singleton.h"


@class GXPasswordManagerCollect;

@protocol GXUserPasswordDelegate <NSObject>

@optional

-(void)getNewConnectedUser:(GXPasswordManagerCollect *)passwordManagerCollect userName:(NSString *)userName passwordID:(NSString *)passwordID;
-(void)deletePasswordSuccessed:(GXPasswordManagerCollect *)passwordManagerCollect userName:(NSString *)userName passwordID:(NSString *)passwordID;
-(void)AlertWhenNoPasswordAfterScan:(GXPasswordManagerCollect *)passwordManagerCollect;
-(void)getConnectState:(NSString *)connectedString;

@end

@interface GXPasswordManagerCollect : NSObject

@property (nonatomic, weak) id<GXUserPasswordDelegate> delegate;
@property (nonatomic, copy) NSString *currentDeviceName;

- (void)disconnect;

//删除操作
- (void)deletePassword:(NSString *)userName password:(NSString *)passwordID;
//添加新密码
- (void)addNewPassword:(NSString *)userName password:(NSString *)password;

- (id)initWithCurrentDeviceName:(NSString *)currentDeviceName;

@end
