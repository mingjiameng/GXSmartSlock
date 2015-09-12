//
//  Common.h
//  GXBLESmartHomeFurnishing
//
//  Created by blue on 14-4-30.
//  Copyright (c) 2014年 guosim. All rights reserved.
//


#ifdef DEBUG
#define GXLog(...) NSLog(__VA_ARGS__)
#define GXLogMethod() NSLog(@"%s", __func__)
#else
#define GXLog(...)
#define GXLogMethod()
#endif

#define GX_Main_Service_UUID                                           [CBUUID UUIDWithString:@"FFF0"]
#define GX_Main_Service_Characteristic_Setup_UUID                      [CBUUID UUIDWithString:@"FFF1"]
#define GX_Read_DidSetup_StoreKeySucceed                               @"<02>"
#define GX_Notify_IsNewPeripheral_WillSetup                            @"<01>"
#define GX_Main_Service_Characteristic_ReadKey_UUID                    [CBUUID UUIDWithString:@"FFF2"]

#define GX_Main_Service_Characteristic_WriteRandomKey_UUID             [CBUUID UUIDWithString:@"FFF6"]
#define GX_WriteRandomKey_KeyPrefix                                      @"01"
#define GX_WriteRandomKey_DidSetup_And_Store                             @"03"

#define GX_Main_Service_Characteristic_Read_Token_UUID                 [CBUUID UUIDWithString:@"FFF4"]
#define GX_Main_Service_Characteristic_Write_Secret_UUID               [CBUUID UUIDWithString:@"FFF3"]
#define GX_WriteSecret_KeyPrefix                                         @"01"

#define GX_Unlock_UUID                                                 [CBUUID UUIDWithString:@"FF10"]

#define GX_Read_BatteryLevel_Characteristic_UUID                       [CBUUID UUIDWithString:@"FFF5"]
#define GX_Read_BatteryLevel_Length                                         2

#define GX_Service_Other_UUID                                          [CBUUID UUIDWithString:@"1804"]

#define GX_PWD_Service_UUID                                            [CBUUID UUIDWithString:@"FF20"]
#define GX_PWD_Write_PWD_Service_UUID                                  [CBUUID UUIDWithString:@"FF21"]
#define GX_PWD_Read_PWD_Service_UUID                                   [CBUUID UUIDWithString:@"FF22"]
#define GX_PWD_Read_PWDCount_Service_UUID                              [CBUUID UUIDWithString:@"FF23"]
#define GX_PWD_Delete_PWD_Service_UUID                                 [CBUUID UUIDWithString:@"FF24"]
#define GX_PWD_MaxCount                                                     5
#define GX_OccsionPWD_Write_Service_UUID                               [CBUUID UUIDWithString:@"FF25"]
#define GX_OccsionPWD_Read_Service_UUID                                [CBUUID UUIDWithString:@"FF26"]
#define GX_OccsionPWDCount_Read_Service_UUID                           [CBUUID UUIDWithString:@"FF27"]


#define GX_OAD_Service_UUID                                            [CBUUID UUIDWithString:@"0xF000FFC0-0451-4000-B000-000000000000"]
#define GX_OAD_ImageNotify_UUID                                         [CBUUID UUIDWithString:@"0xF000FFC1-0451-4000-B000-000000000000"]
#define GX_OAD_BlockRequest_UUID                                         [CBUUID UUIDWithString:@"0xF000FFC2-0451-4000-B000-000000000000"]
#import "GXRootViewController.h"

#define iOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)

#define kGXColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]

#define kScreenSize ([UIScreen mainScreen].bounds.size)
#define kIconWH 100
#define kIConLineW 3
#define kIconMargin 1

#define kMenuW KScreenWidth/3

#define KBaseUrl @"https://115.28.226.149/"
//#define KBaseUrl @"https://54.179.147.72/"
// 注册地址
#define kRegisterUrl          [NSString stringWithFormat:@"%@user_register",KBaseUrl]
// 登陆地址
#define kLoginUrl             [NSString stringWithFormat:@"%@user_exist",KBaseUrl]
// 初始化设备地址
#define kSetupDeviceUrl       [NSString stringWithFormat:@"%@setup_device",KBaseUrl]
// 发钥匙地址
#define kSendKeyUrl           [NSString stringWithFormat:@"%@send_key",KBaseUrl]
// 同步单个设备钥匙
#define kSyncKeyUrl           [NSString stringWithFormat:@"%@sync_key",KBaseUrl]
// 同步设备操作记录
#define kSyncRecordUrl        [NSString stringWithFormat:@"%@sync_record",KBaseUrl]
// 同步设备列表
#define kSyncDeviceUrl        [NSString stringWithFormat:@"%@sync_device",KBaseUrl]
// 同步设备列表
#define kReceiveKeyUrl        [NSString stringWithFormat:@"%@receive_key",KBaseUrl]
// 删除钥匙（某个设备用户列表里的钥匙）
#define kDeleteKeyUrl         [NSString stringWithFormat:@"%@delete_key",KBaseUrl]

// 删除设备列表里的钥匙（未接收，接收但不是admin）
#define kDeleteSelfKeyUrl     [NSString stringWithFormat:@"%@delete_self_key",KBaseUrl]
// 删除设备（admin才可以删除，会删除设备相关所有钥匙）
#define kDeleteDeviceUrl      [NSString stringWithFormat:@"%@delete_device",KBaseUrl]

// 更新密码
#define kUpdatePwdUrl         [NSString stringWithFormat:@"%@update_password",KBaseUrl]
// 更新昵称
#define kUpdateNNameUrl       [NSString stringWithFormat:@"%@update_nickname",KBaseUrl]
// 更新设备名称
#define kUpdateDeviceNameUrl  [NSString stringWithFormat:@"%@update_devicename",KBaseUrl]
// 更新灵敏度
#define kUpdateDeviceRSSIUrl  [NSString stringWithFormat:@"%@update_rssi_limit",KBaseUrl]
// 更新设备版本
#define kUpdataDeviceVersionUrl  [NSString stringWithFormat:@"%@update_device_version",KBaseUrl]
//发送邮件
#define kSendMailUrl          [NSString stringWithFormat:@"%@username_exist",KBaseUrl]
//上传记录
#define kPushRecordUrl        [NSString stringWithFormat:@"%@push_record",KBaseUrl]
//上传old记录
#define kPushOldRecordUrl     [NSString stringWithFormat:@"%@push_old_record",KBaseUrl]
//上传错误信息记录
#define kSendLogUrl           [NSString stringWithFormat:@"%@send_log",KBaseUrl]
//获取服务器端固件版本
#define kVersionNumberUrl     [NSString stringWithFormat:@"%@￼￼fw_version",KBaseUrl]
//获取服务器端固件地址
#define kVersionSourceUrl     [NSString stringWithFormat:@"%@source_file",KBaseUrl]
//安装帮助参数地址
#define kInstallQueryUrl     [NSString stringWithFormat:@"%@install_query_submit",KBaseUrl]
//上传安装照片地址
#define kInstallImageUrl     [NSString stringWithFormat:@"%@upload_install_image",KBaseUrl]
//提交账户信息
#define kSubmitAccountUrl     [NSString stringWithFormat:@"%@submit_account",KBaseUrl]
//验证账户信息
#define kVerifyAccountUrl     [NSString stringWithFormat:@"%@verify_account",KBaseUrl]
//忘记账户信息
#define kForgetAccountUrl     [NSString stringWithFormat:@"%@submit_account_reset_pw",KBaseUrl]
//重置密码
#define kRepeatPasswordUrl     [NSString stringWithFormat:@"%@reset_password",KBaseUrl]
//更新电量
#define kUpdatebatteryUrl     [NSString stringWithFormat:@"%@update_device_battery",KBaseUrl]
#define kPushDeviceTokenUrl    [NSString stringWithFormat:@"%@update_device_battery",KBaseUrl]
#define kUserDefault [NSUserDefaults standardUserDefaults]

#define kDBFilePath [@"ReadMe" appendDocumentDir]

#define kPending @"pending"
#define kReply   @"replied"
#define kAdmin   @"admin"
#define kActive  @"active"

//设置屏幕高
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
//设置屏幕宽
#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
//状态栏高度
#define KStateBarHeight 20
//工具栏高度
#define KToolBarHeigth 44
//主窗口高度
#define KMainHeight KScreenHeight
//主窗口宽度
#define KMainWidth KScreenWidth

#define KLeftWidth  16

#define KCurrentScreen [UIScreen mainScreen].currentMode.size.height

#define kMenuBtnClick  @"kMenuBtnClick"

//#define iPhone6Plus KScreenHeight = 736
//#define iPhone6     KScreenHeight = 667
//#define iPhone5     KScreenHeight = 568
//#define iPhone4     KScreenHeight < 568