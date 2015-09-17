//
//  AppDelegate.m
//  GXSmartSlock
//
//  Created by zkey on 8/19/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "AppDelegate.h"

#import "MICRO_COMMON.h"

#import "zkeyMiPushPackage.h"
#import "WXApi.h"
#import "GXDatabaseHelper.h"

#import "zkeyViewHelper.h"

#import "GXGuidePageViewController.h"
#import "GXRootViewController.h"
#import "GXLoginViewController.h"
#import "FHGesturePasswordViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface AppDelegate () <zkeyMiPushPackageDelegate, WXApiDelegate>

@end



@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self becomeFirstResponder];
    
    // set navigationBar and tabBar style
    [self setBarColor];
    
    // whether need to lunch guide page
    BOOL needToLaunchGuidePage = [self whetherNeedToLauchGuidePage];
    needToLaunchGuidePage = NO;

    if (needToLaunchGuidePage) {
        GXGuidePageViewController *guidePageVC = [[GXGuidePageViewController alloc] init];
        _window.rootViewController = guidePageVC;
    } else {
        UINavigationController *navigation = nil;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:DEFAULT_LOGIN_STATUS]) {
            GXRootViewController *rootVC = [[GXRootViewController alloc] init];
            navigation = [[UINavigationController alloc] initWithRootViewController:rootVC];
            
        } else {
            GXLoginViewController *loginVC = [[GXLoginViewController alloc] init];
            navigation = [[UINavigationController alloc] initWithRootViewController:loginVC];
        }
        
        _window.rootViewController = navigation;
    }
    
    [_window makeKeyAndVisible];
    
    // request system rights
    [self requestSystemNotificationServcie];
    
    // register WeiXin service
    [WXApi registerApp:WEIXIN_GUOSIM_ID];
    // register MiPushService
    [[zkeyMiPushPackage sharedMiPush] registerMiPushWithLongConnection:self];
    
    [self openGestureSecretViewIfNeccessary];
    
    return YES;
}

- (BOOL)whetherNeedToLauchGuidePage
{
    NSString *currentAppVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *historyAppVersionString = [[NSUserDefaults standardUserDefaults] objectForKey:APP_VERSION];
    
    if (historyAppVersionString != nil) {
        if ([historyAppVersionString isEqualToString:currentAppVersionString]) {
            return NO;
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:currentAppVersionString forKey:APP_VERSION];
            return YES;
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersionString forKey:APP_VERSION];
        return YES;
        
    }
    
    return YES;
}


- (void)setBarColor
{
    // set navigationBar title text color
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    // set navigationBarItem tint color
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    // set navigationBar background color
    [[UINavigationBar appearance] setBarTintColor:MAIN_COLOR];
    
    // set navigationBar translucent
    if(IOS8_OR_LATER && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    
    // tabbar
    [[UITabBar appearance] setTintColor:MAIN_COLOR];
    
    // set status bar style
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)requestSystemNotificationServcie
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }
}

#pragma mark - miPush
// bind deviceToken
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *tokeStr = [NSString stringWithFormat:@"%@",deviceToken];
    if (tokeStr.length <= 0) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:tokeStr forKey:DEFAULT_DEVICE_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // about MiPush
    [[zkeyMiPushPackage sharedMiPush] bindDeviceToken:deviceToken];
    [self bindDeviceAccordingToAccount];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"failed to regist remote notification:%@, %@", error, [error userInfo]);
}

// 将userName设为account
- (void)bindDeviceAccordingToAccount
{
    NSString *previousUserName = [[NSUserDefaults standardUserDefaults] objectForKey:PREVIOUS_USER_NAME];
    if (previousUserName != nil) {
        [[zkeyMiPushPackage sharedMiPush] unsetAccount:previousUserName];
    }
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    if (userName != nil) {
        [[zkeyMiPushPackage sharedMiPush] setAccount:userName];
    }
}

- (void)successfullyBindDeviceTokenWithData:(NSDictionary *)data
{
    NSLog(@"bind token success");
}

- (void)successfullySetAccountWithData:(NSDictionary *)data
{
    NSLog(@"set account success:%@", data);
}

- (void)successfullyUnsetAccountWithData:(NSDictionary *)data
{
    NSLog(@"unset account data:%@", data);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREVIOUS_USER_NAME];
}

// miPush 长连接收到消息
- (void)miPushReceiveNotification:(NSDictionary *)data
{
    //NSLog(@"remote data:%@", data);
    NSDictionary *aps = [data objectForKey:@"aps"];
    NSString *alertMessage = [aps objectForKey:@"alert"];
    UIApplication *application = [UIApplication sharedApplication];
    if (application.applicationState == UIApplicationStateActive) {
        // build location notification
        [zkeyViewHelper presentLocalNotificationWithMessage:alertMessage];
    }
    
    NSString *remoteDeviceToken = [data objectForKey:@"device_token"];
    
    if (remoteDeviceToken != nil) {
        NSString *localDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_DEVICE_TOKEN];
        if ([localDeviceToken isEqual:remoteDeviceToken]) {
            //[self forceToLogout];
        }
    }
    
    // 有钥匙被删除
    NSString *contentType = [data objectForKey:@"contentType"];
    if (contentType != nil && [contentType isEqualToString:@"keyDeleted"]) {
        NSString *deviceIdentifire = [data objectForKey:@"device_id"];
        if (deviceIdentifire != nil) {
            [GXDatabaseHelper deleteDeviceWithIdentifire:deviceIdentifire];
        }
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[zkeyMiPushPackage sharedMiPush] handleReceiveRemoteNotification:userInfo];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // play alert voice when receive local notification
    if (application.applicationState == UIApplicationStateActive) {
        [self playMusic];
    }
}

// ... play alert voice
-(void)playMusic{
    NSString *pewPewPath = [[NSBundle mainBundle]
                            pathForResource:@"Voicemail" ofType:@"wav"];
    NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
    SystemSoundID pewPewSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &pewPewSound);
    AudioServicesPlaySystemSound(pewPewSound);
    
}


#pragma mark - WeiXin callback
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

// 微信分享后的回调
// 根据返回的错误码采取动作
- (void)onResp:(BaseResp *)resp
{
    if (![resp isKindOfClass:[SendMessageToWXResp class]]) {
        return;
    }
    
    if (resp.errCode != WXSuccess) {
        //[[NSNotificationCenter defaultCenter] postNotificationName:WEIXIN_FAIL_TO_SHARE_NOTIFICATION object:nil];
    }
}

#pragma mark - application status change

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    [self openGestureSecretViewIfNeccessary];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)openGestureSecretViewIfNeccessary
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_GESTURE_PASSWORD]) {
        FHGesturePasswordViewController *gesturePasswordVerifyVC = [[FHGesturePasswordViewController alloc] init];
        gesturePasswordVerifyVC.viewType = GesturePasswordViewTypeVerification;
        [self.window.rootViewController presentViewController:gesturePasswordVerifyVC animated:YES completion:nil];
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.guosim.GXSmartSlock" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GXSmartSlock" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GXSmartSlock.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
