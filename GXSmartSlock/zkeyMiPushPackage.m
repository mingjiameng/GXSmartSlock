//
//  zkeyMiPushPackage.m
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 6/11/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "zkeyMiPushPackage.h"

@interface zkeyMiPushPackage ()
@property (nonatomic, assign) id<zkeyMiPushPackageDelegate> delegate;
@end

@implementation zkeyMiPushPackage 
+(zkeyMiPushPackage *)sharedMiPush
{
    static zkeyMiPushPackage *pushSingleton = nil;
    static dispatch_once_t onePreidicate;
    dispatch_once(&onePreidicate, ^{
        pushSingleton = [[zkeyMiPushPackage alloc] init];
    });
    
    return pushSingleton;
}

/**
 * 客户端注册设备
 */

- (void)registerMiPushWithLongConnection:(id<zkeyMiPushPackageDelegate>)delegate
{
    [MiPushSDK registerMiPush:self type:0 connect:YES];
    self.delegate = delegate;
}

- (void)registerMiPush:(id<zkeyMiPushPackageDelegate>)delegate
{
    [MiPushSDK registerMiPush:self];
    
    self.delegate = delegate;
}

- (void)registerMiPush:(id<zkeyMiPushPackageDelegate>)delegate type:(UIRemoteNotificationType)type
{
    [MiPushSDK registerMiPush:self type:type];
    self.delegate = delegate;
}

/**
 * 启用长连接后, 当收到消息是就会回调此方法
 *
 * @param
 *     type: 消息类型
 *     data: 返回结果字典, 跟apns的消息格式一样
 */
- (void)miPushReceiveNotification:(NSDictionary*)data
{
    [self.delegate miPushReceiveNotification:data];
}

/**
 * 当同时启动APNs与内部长连接时, 把两处收到的消息合并. 通过miPushReceiveNotification返回
 */
- (void)handleReceiveRemoteNotification:(NSDictionary*)userInfo
{
    [MiPushSDK handleReceiveRemoteNotification:userInfo];
}

/**
 * 客户端设备注销
 */
- (void)unregisterMiPush
{
    [MiPushSDK unregisterMiPush];
}
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
- (void)bindDeviceToken:(NSData *)deviceToken
{
    [MiPushSDK bindDeviceToken:deviceToken];
}

/**
 * 客户端设置别名
 *
 * @param
 *     alias: 别名 (length:128)
 */
- (void)setAlias:(NSString *)alias
{
    [MiPushSDK setAlias:alias];
}

/**
 * 客户端取消别名
 *
 * @param
 *     alias: 别名 (length:128)
 */
- (void)unsetAlias:(NSString *)alias;
{
    [MiPushSDK unsetAlias:alias];
}

/**
 * 客户端设置帐号
 * 多设备设置同一个帐号, 发送消息时多设备可以同时收到
 *
 * @param
 *     account: 帐号 (length:128)
 */
- (void)setAccount:(NSString *)account
{
    [MiPushSDK setAccount:account];
}

/**
 * 客户端取消帐号
 *
 * @param
 *     account: 帐号 (length:128)
 */
- (void)unsetAccount:(NSString *)account
{
    [MiPushSDK unsetAccount:account];
}


/**
 * 客户端设置主题
 * 支持同时设置多个topic, 中间使用","分隔
 *
 * @param
 *     subscribe: 主题类型描述
 */
- (void)subscribe:(NSString *)topics
{
    [MiPushSDK subscribe:topics];
}

/**
 * 客户端取消主题
 * 支持同时设置多个topic, 中间使用","分隔
 *
 * @param
 *     subscribe: 主题类型描述
 */
- (void)unsubscribe:(NSString *)topics
{
    [MiPushSDK unsubscribe:topics];
}

/**
 * 统计客户端 通过push开启app行为
 * 如果, 你想使用服务器帮你统计你app的点击率请自行调用此方法
 * 方法放到:application:didReceiveRemoteNotification:回调中.
 * @param
 *      messageId:Payload里面对应的miid参数
 */
- (void)openAppNotify:(NSString *)messageId
{
    [MiPushSDK openAppNotify:messageId];
}

/**
 * 获取客户端所有设置的别名
 */
- (void)getAllAliasAsync
{
    [MiPushSDK getAllAliasAsync];
}

/**
 * 获取客户端所有订阅的主题
 */
- (void)getAllTopicAsync
{
    [MiPushSDK getAllAliasAsync];
}

/**
 * 获取SDK版本号
 */
- (NSString*)getSDKVersion
{
    return [MiPushSDK getSDKVersion];
}

#pragma mark - miPush delegate
- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    //NSLog(@"IMP succ %@, %@", selector, data);
    
    if ([selector isEqualToString:@"registerMiPush:"]) {
        if ([self.delegate respondsToSelector:@selector(successfullyRegisterMiPushWithData:)]) {
            NSLog(@"succ login %@", data);
            [self.delegate successfullyRegisterMiPushWithData:data];
        }
    }else if ([selector isEqualToString:@"unregisterMiPush"]) {
        if ([self.delegate respondsToSelector:@selector(successfullyUnregisterMiPushWithData:)]) {
            [self.delegate successfullyUnregisterMiPushWithData:data];
        }
    }else if ([selector isEqualToString:@"bindDeviceToken:"]) {
        if ([self.delegate respondsToSelector:@selector(successfullyBindDeviceTokenWithData:)]) {
            [self.delegate successfullyBindDeviceTokenWithData:data];
        }
    }else if ([selector isEqualToString:@"setAlias:"]) {
        if ([self.delegate respondsToSelector:@selector(successfullySetAliasWithData:)]) {
            [self.delegate successfullySetAliasWithData:data];
        }
    }else if ([selector isEqualToString:@"unsetAlias:"]) {
        if ([self.delegate respondsToSelector:@selector(successfullyUnsetAliasWithData:)]) {
            [self.delegate successfullyUnsetAliasWithData:data];
        }
    }else if ([selector isEqualToString:@"subscribe:"]) {
        if ([self.delegate respondsToSelector:@selector(successfullySubscribeWithData:)]) {
            [self.delegate successfullySubscribeWithData:data];
        }
    }else if ([selector isEqualToString:@"unsubscribe:"]) {
        if ([self.delegate respondsToSelector:@selector(successfullyUnsubscribeWithData:)]) {
            [self.delegate successfullyUnsubscribeWithData:data];
        }
    }else if ([selector isEqualToString:@"setAccount:"]) {
        if ([self.delegate respondsToSelector:@selector(successfullySetAccountWithData:)]) {
            [self.delegate successfullySetAccountWithData:data];
        }
    }else if ([selector isEqualToString:@"unsetAccount:"]) {
        if ([self.delegate respondsToSelector:@selector(successfullyUnsetAccountWithData:)]) {
            [self.delegate successfullyUnsetAccountWithData:data];
        }
    }else if ([selector isEqualToString:@"openAppNotify:"]) {
        if ([self.delegate respondsToSelector:@selector(successfullyOpenAppNotifyWithData:)]) {
            [self.delegate successfullyOpenAppNotifyWithData:data];
        }
    }else if ([selector isEqualToString:@"getAllAliasAsync"]) {
        if ([self.delegate respondsToSelector:@selector(successfullyGetAllAliasAsyncWithData:)]) {
            [self.delegate successfullyGetAllAliasAsyncWithData:data];
        }
    }else if ([selector isEqualToString:@"getAllTopicAsync"]) {
        if ([self.delegate respondsToSelector:@selector(successfullyGetAllTopicAsyncWithData:)]) {
            [self.delegate successfullyGetAllTopicAsyncWithData:data];
        }
    } else {
        NSLog(@"miPush call back error with selector:%@", selector);
    }
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{
    //NSLog(@"IMP fail %@, %@", selector, data);
    
    if ([selector isEqualToString:@"registerMiPush:"]) {
        if ([self.delegate respondsToSelector:@selector(failToRegisterMiPushWithError:data:)]) {
            [self.delegate failToRegisterMiPushWithError:error data:data];
        }
    }else if ([selector isEqualToString:@"unregisterMiPush"]) {
        if ([self.delegate respondsToSelector:@selector(failToUnregisterMiPushWithError:data:)]) {
            [self.delegate failToUnregisterMiPushWithError:error data:data];
        }
    }else if ([selector isEqualToString:@"bindDeviceToken:"]) {
        if ([self.delegate respondsToSelector:@selector(failToBindDeviceTokenWithError:data:)]) {
            [self.delegate failToBindDeviceTokenWithError:error data:data];
        }
    }else if ([selector isEqualToString:@"setAlias:"]) {
        if ([self.delegate respondsToSelector:@selector(failToSetAliasWithError:data:)]) {
            [self.delegate failToSetAliasWithError:error data:data];
        }
    }else if ([selector isEqualToString:@"unsetAlias:"]) {
        if ([self.delegate respondsToSelector:@selector(failToUnsetAliasWithError:data:)]) {
            [self.delegate failToUnsetAliasWithError:error data:data];
        }
    }else if ([selector isEqualToString:@"subscribe:"]) {
        if ([self.delegate respondsToSelector:@selector(failToSubscribeWithError:data:)]) {
            [self.delegate failToSubscribeWithError:error data:data];
        }
    }else if ([selector isEqualToString:@"unsubscribe:"]) {
        if ([self.delegate respondsToSelector:@selector(failToUnsubscribeWithError:data:)]) {
            [self.delegate failToUnsubscribeWithError:error data:data];
        }
    }else if ([selector isEqualToString:@"setAccount:"]) {
        if ([self.delegate respondsToSelector:@selector(failToSetAccountWithError:data:)]) {
            [self.delegate failToSetAccountWithError:error data:data];
        }
    }else if ([selector isEqualToString:@"unsetAccount:"]) {
        if ([self.delegate respondsToSelector:@selector(failToUnsetAccountWithError:data:)]) {
            [self.delegate failToUnsetAccountWithError:error data:data];
        }
    }else if ([selector isEqualToString:@"openAppNotify:"]) {
        if ([self.delegate respondsToSelector:@selector(failToOpenAppNotifyWithError:data:)]) {
            [self.delegate failToOpenAppNotifyWithError:error data:data];
        }
    }else if ([selector isEqualToString:@"getAllAliasAsync"]) {
        if ([self.delegate respondsToSelector:@selector(failToGetAllAliasAsyncWithError:data:)]) {
            [self.delegate failToGetAllAliasAsyncWithError:error data:data];
        }
    }else if ([selector isEqualToString:@"getAllTopicAsync"]) {
        if ([self.delegate respondsToSelector:@selector(failToGetAllTopicAsyncWithError:data:)]) {
            [self.delegate failToGetAllTopicAsyncWithError:error data:data];
        }
    } else {
        NSLog(@"miPush call back error with selector:%@", selector);
    }
}

@end
