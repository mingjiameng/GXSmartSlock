//
//  zkeyMiPushPackage.h
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 6/11/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MiPushSDK.h"


@protocol zkeyMiPushPackageDelegate <NSObject>

@required
- (void)miPushReceiveNotification:(NSDictionary*)data;

@optional
/**
 对MiPushSDK进行封装
 使用代理模式
 使得每调用MiPush interface的一个方法后
 都能编写响应的方法回调
 */
- (void)successfullyRegisterMiPushWithData:(NSDictionary *)data;
- (void)failToRegisterMiPushWithError:(int)error data:(NSDictionary *)data;

- (void)successfullyUnregisterMiPushWithData:(NSDictionary *)data;
- (void)failToUnregisterMiPushWithError:(int)error data:(NSDictionary *)data;

- (void)successfullyBindDeviceTokenWithData:(NSDictionary *)data;
- (void)failToBindDeviceTokenWithError:(int)error data:(NSDictionary *)data;

- (void)successfullySetAliasWithData:(NSDictionary *)data;
- (void)failToSetAliasWithError:(int)error data:(NSDictionary *)data;

- (void)successfullyUnsetAliasWithData:(NSDictionary *)data;
- (void)failToUnsetAliasWithError:(int)error data:(NSDictionary *)data;

- (void)successfullySubscribeWithData:(NSDictionary *)data;
- (void)failToSubscribeWithError:(int)error data:(NSDictionary *)data;

- (void)successfullyUnsubscribeWithData:(NSDictionary *)data;
- (void)failToUnsubscribeWithError:(int)error data:(NSDictionary *)data;

- (void)successfullySetAccountWithData:(NSDictionary *)data;
- (void)failToSetAccountWithError:(int)error data:(NSDictionary *)data;

- (void)successfullyUnsetAccountWithData:(NSDictionary *)data;
- (void)failToUnsetAccountWithError:(int)error data:(NSDictionary *)data;

- (void)successfullyOpenAppNotifyWithData:(NSDictionary *)data;
- (void)failToOpenAppNotifyWithError:(int)error data:(NSDictionary *)data;

- (void)successfullyGetAllAliasAsyncWithData:(NSDictionary *)data;
- (void)failToGetAllAliasAsyncWithError:(int)error data:(NSDictionary *)data;

- (void)successfullyGetAllTopicAsyncWithData:(NSDictionary *)data;
- (void)failToGetAllTopicAsyncWithError:(int)error data:(NSDictionary *)data;

@end




@interface zkeyMiPushPackage : NSObject <MiPushSDKDelegate>

+(zkeyMiPushPackage *)sharedMiPush;

/**
 * 客户端注册设备
 */
- (void)registerMiPushWithLongConnection:(id<zkeyMiPushPackageDelegate>)delegate;
- (void)registerMiPush:(id<zkeyMiPushPackageDelegate>)delegate;
- (void)registerMiPush:(id<zkeyMiPushPackageDelegate>)delegate type:(UIRemoteNotificationType)type;

/**
 * 当同时启动APNs与内部长连接时, 把两处收到的消息合并. 通过miPushReceiveNotification返回
 */
- (void)handleReceiveRemoteNotification:(NSDictionary*)userInfo;

/**
 * 客户端设备注销
 */
- (void)unregisterMiPush;


/**
 * 绑定 PushDeviceToken
 *
 * NOTE: 有时Apple会重新分配token, 所以为保证消息可达,
 * 必须在系统application:didRegisterForRemoteNotificationsWithDeviceToken:回调中,
 * 重复调用此方法. SDK内部会处理是否重新上传服务器.
 *
 * @param
 *     deviceToken: AppDelegate中,PUSH注册成功后,
 *                  系统回调didRegisterForRemoteNotificationsWithDeviceToken
 */
- (void)bindDeviceToken:(NSData *)deviceToken;


/**
 * 客户端设置别名
 *
 * @param
 *     alias: 别名 (length:128)
 */
- (void)setAlias:(NSString *)alias;

/**
 * 客户端取消别名
 *
 * @param
 *     alias: 别名 (length:128)
 */
- (void)unsetAlias:(NSString *)alias;


/**
 * 客户端设置帐号
 * 多设备设置同一个帐号, 发送消息时多设备可以同时收到
 *
 * @param
 *     account: 帐号 (length:128)
 */
- (void)setAccount:(NSString *)account;

/**
 * 客户端取消帐号
 *
 * @param
 *     account: 帐号 (length:128)
 */
- (void)unsetAccount:(NSString *)account;


/**
 * 客户端设置主题
 * 支持同时设置多个topic, 中间使用","分隔
 *
 * @param
 *     subscribe: 主题类型描述
 */
- (void)subscribe:(NSString *)topics;

/**
 * 客户端取消主题
 * 支持同时设置多个topic, 中间使用","分隔
 *
 * @param
 *     subscribe: 主题类型描述
 */
- (void)unsubscribe:(NSString *)topics;


/**
 * 统计客户端 通过push开启app行为
 * 如果, 你想使用服务器帮你统计你app的点击率请自行调用此方法
 * 方法放到:application:didReceiveRemoteNotification:回调中.
 * @param
 *      messageId:Payload里面对应的miid参数
 */
- (void)openAppNotify:(NSString *)messageId;



/**
 * 获取客户端所有设置的别名
 */
- (void)getAllAliasAsync;



/**
 * 获取客户端所有订阅的主题
 */
- (void)getAllTopicAsync;

/**
 * 获取SDK版本号
 */
- (NSString*)getSDKVersion;

@end
