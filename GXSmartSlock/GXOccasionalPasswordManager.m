//
//  GXOccasionalPasswordManager.m
//  GXBLESmartHomeFurnishing
//
//  Created by wjq on 15-1-15.
//  Copyright (c) 2015年 guosim. All rights reserved.
//

#import "GXOccasionalPasswordManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "SharkfoodMuteSwitchDetector.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+ConvertToString.h"
#import "NSString+StringHexToData.h"
#import "NSData+ToNSString.h"
#import "Common.h"

typedef enum{
    PeripheralStateIsConnected = 0,
    PeripheralStateIsReadingPassword,            // read 得到密码        11b
    PeripheralStateIsReadedCount,                // read 得到密码个数     1b
    PeripheralStateIsWaitingWrite                // write 添加密码       12b
}PeripheralState;

@interface GXOccasionalPasswordManager()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager                 *_centralManager;      //中心设备
    CBPeripheral                     *_connectedPeripheral;   //外围设备

    PeripheralState                   _peripheralState;
    CBService                        *_mainService;
    NSInteger                         _pwdCount;
     NSInteger count;
    BOOL                              _isGetPassword,_getOccsionalPassword;
}

@property (nonatomic,strong) SharkfoodMuteSwitchDetector* detector;

@end

@implementation GXOccasionalPasswordManager

-(id)initWithCurrentDeviceName:(NSString *)currentDeviceName
{
    if (self = [super init]) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    _currentDeviceName = currentDeviceName;
    _getOccsionalPassword = YES;
    return self;
}

- (CBCentralManagerState)centralManagerState
{
    return _centralManager.state;
}

- (void)disconnect
{
    [_centralManager stopScan];
    if (_connectedPeripheral != nil) {
        [_centralManager cancelPeripheralConnection:_connectedPeripheral];
        _connectedPeripheral = nil;
    }
}

- (void)refreshPeripheral
{
    [_centralManager stopScan];
    
    if (_connectedPeripheral != nil) {
        
        [_centralManager cancelPeripheralConnection:_connectedPeripheral];
        _connectedPeripheral = nil;
    }
    [_centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(YES)}];
}

- (NSString *)centralManagerStateToString:(int)state
{
    switch(state) {
        case CBCentralManagerStateUnknown:
            return @"Occasional Password Manager:State unknown (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateResetting:
            return @"Occasional Password Manager:State resetting (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateUnsupported:
            return @"Occasional Password Manager:State BLE unsupported (CBCentralManagerStateResetting)";
        case CBCentralManagerStateUnauthorized:
            return @"Occasional Password Manager:State unauthorized (CBCentralManagerStateUnauthorized)";
        case CBCentralManagerStatePoweredOff:
            return @"Occasional Password Manager:State BLE powered off (CBCentralManagerStatePoweredOff)";
        case CBCentralManagerStatePoweredOn:
            return @"Occasional Password Manager:State powered up and ready (CBCentralManagerStatePoweredOn)";
        default:
            return @"Occasional Password Manager:State unknown";
    }
}

/**
 *CentralManager初始化后，检查状态，是不是被BLE所支持，如果支持则开始搜索周围设备
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    GXLog(@"Occasional Password Manager:CentralManager State:    %@",[self centralManagerStateToString:central.state]);
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [_centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(YES)}];
        GXLog(@"Occasional Password Manager:Strating search for nearby Peripherals");
    }
}

/**
 *  检测外设是否是当前设备
 */

-(BOOL)peripheralIsEqualCurrentDevice:(NSString *)peripheraname
{
    if ([_currentDeviceName isEqualToString:peripheraname]) {
        return  YES;
    }
       return NO;
}
/**
 * 搜索到一个蓝牙设备，若周围蓝牙有多个，则会多次调用
 * 任何广播或扫描的相应数据保存在advertisementData中
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //GXLog(@"Occasional Password Manager: Discovered nearby Periapheral:    %@ (RSSI: %d)",advertisementData[@"kCBAdvDataLocalName"],[RSSI intValue]);
    if (_connectedPeripheral !=nil) return;
    //GXLog(@"Occasional Password Manager:设备 = %@",_currentDeviceName);
    //GXLog(@"Occasional Password Manager:搜索到的设备 = %@",advertisementData[@"kCBAdvDataLocalName"]);
    if ([self peripheralIsEqualCurrentDevice:peripheral.name]) {
        _connectedPeripheral = peripheral;
        [_centralManager connectPeripheral:peripheral options:nil];
        return;
    }
}
#pragma mark - CBCentralManager代理

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    GXLog(@"Occasional Password Manager:CentralManager Failed connect to peripheral:    %@ error:    %@",peripheral.name,error.localizedDescription);
    [self refreshPeripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    GXLog(@"Occasional Password Manager:Connected to nearby peripheral:%@",peripheral.name);
    peripheral.delegate = self;
    //发现 FF20 服务
    [peripheral discoverServices:@[GX_PWD_Service_UUID]];
    GXLog(@"Occasional Password Manager:Stop search for nearby peripherials");
    [central stopScan];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    GXLog(@"Occasional Password Manager:Disconnect from bearby peripheral:    %@ error:    %@",peripheral.name,error.localizedDescription);;
    [self refreshPeripheral];
}


-(void)playSound
{
    NSString *pewPewPath = [[NSBundle mainBundle] pathForResource:@"Voicemail" ofType:@"wav"];
    NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
    SystemSoundID pewPewSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &pewPewSound);
    AudioServicesPlaySystemSound(pewPewSound);
}
#pragma mark - 返回的蓝牙服务通过代理实现

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (!error) {
        for (CBService *service in peripheral.services) {
            if ([service.UUID isEqual:GX_PWD_Service_UUID]) {
                _mainService = service;
                if (_getOccsionalPassword) {
                    //FF25直接进行修改写操作
                    [_connectedPeripheral discoverCharacteristics:@[GX_OccsionPWD_Write_Service_UUID] forService:service];
                }else {
                    //同步临时密码 FF27,read,读取临时密码
                    [_connectedPeripheral discoverCharacteristics:@[GX_OccsionPWDCount_Read_Service_UUID] forService:service];
                }
            }
        }
        return;
    }
    [self refreshPeripheral];
}
/**
 * 服务为 FF20 下 蓝牙特征值
 */
- (void)serviceMainWithPeripheral:(CBPeripheral *)peripheral chara:(CBCharacteristic *)character
{
    //蓝牙特征值为 FF25，随意写进一个数，生成临时密码
    if ([character.UUID isEqual:GX_OccsionPWD_Write_Service_UUID] && _peripheralState == PeripheralStateIsConnected) {
        NSData *writeData = [@"01" hexToBytes:2];
         [peripheral writeValue:writeData forCharacteristic:character type:CBCharacteristicWriteWithResponse];
    }
    //蓝牙特征值为 FF26，read 读取所有的临时密码
    else if ([character.UUID isEqual:GX_OccsionPWD_Read_Service_UUID] && _peripheralState == PeripheralStateIsReadingPassword){
       
        if (_isGetPassword) {
            for (int i = 0;i<10;i++) {
                _pwdCount = 10;
                [peripheral readValueForCharacteristic:character];
            }
        }else{
            for (int i = 0;i<_pwdCount;i++) {
                [peripheral readValueForCharacteristic:character];
            }
        }
    }
    //蓝牙特征值为 FF27，read 读取所有的临时密码个数
    else if ([character.UUID isEqual:GX_OccsionPWDCount_Read_Service_UUID] && _peripheralState == PeripheralStateIsReadedCount){
         [peripheral readValueForCharacteristic:character];
    }
}

//写操作的回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
   
    if(error == nil) {
        if ([characteristic.UUID isEqual:GX_OccsionPWD_Write_Service_UUID]) {
            _peripheralState = PeripheralStateIsReadingPassword;
            _isGetPassword = YES;
            //已经知道每次生成都是10个临时密码，可以不用去读个数，，直接进行读密码操作
            [_connectedPeripheral discoverCharacteristics:@[GX_OccsionPWD_Read_Service_UUID] forService:_mainService];
        }
    }
    GXLog(@"Occasional Password Manager:WriteKeyResponse:    %@ Error:    %@",characteristic.UUID,error);
}

//返回的蓝牙特征值通过代理实现
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (!error) {
        for (CBCharacteristic *chara in service.characteristics) {
            GXLog(@"Occasional Password Manager:Discovered Characteristic (%@)",chara.UUID.UUIDString);
            if ([service.UUID isEqual:GX_PWD_Service_UUID]) {
                [self serviceMainWithPeripheral:peripheral chara:chara];
            }
        }
        return;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        [self refreshPeripheral];
        return;
    }
    
    GXLog(@"Occasional Password Manager:Characteristic (%@) read:%@",characteristic.UUID.UUIDString,characteristic.value.description);
    NSString *charaValue = characteristic.value.description;
    //FF27 读临时密码个数
    if ([characteristic.UUID isEqual:GX_OccsionPWDCount_Read_Service_UUID] && _peripheralState == PeripheralStateIsReadedCount) {
//        _pwdCount = [[charaValue ConvertToString] integerValue];
        _pwdCount = strtoul([[charaValue ConvertToString] UTF8String],0,16);
        if(_pwdCount == 0){
            if ([_delegate respondsToSelector:@selector(addOccasionalPassword:count:)]) {
                [_delegate addOccasionalPassword:self count:0];
            }
        }
        _peripheralState = PeripheralStateIsReadingPassword;
        //写成功后  FF27 读取生成临时密码的个数
        [_connectedPeripheral discoverCharacteristics:@[GX_OccsionPWD_Read_Service_UUID] forService:_mainService];
    }
    //FF26读取密码，读取成功，显示到页面中
    else if ([characteristic.UUID isEqual:GX_OccsionPWD_Read_Service_UUID] && _peripheralState == PeripheralStateIsReadingPassword) {
            NSString *password = [self stringToString:[charaValue ConvertToString]];
            if ([_delegate respondsToSelector:@selector(addOccasionalPassword:password:password_used:cout:)]) {
                [_delegate addOccasionalPassword:self password:password password_used:NO cout:_pwdCount];
            }
    }
}

#pragma mark - 
#pragma mark - 共有方法
- (void)syncOccasionalPassword
{
    _peripheralState = PeripheralStateIsReadedCount;
    _getOccsionalPassword = NO;
}

-(void)getOccasionalPassword
{
    _peripheralState = PeripheralStateIsConnected;
    _getOccsionalPassword = YES;
}

-(NSString *)stringToString:(NSString *)string
{
    NSMutableString *allString = [[NSMutableString alloc] initWithCapacity:10];
    int idx;
    for (idx = 0; idx+2 <= string.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [string substringWithRange:range];
        NSString *num = [NSString stringWithFormat:@"%ld",(long)[hexStr integerValue]];
        [allString appendString:num];
    }
    return allString;
}

@end
