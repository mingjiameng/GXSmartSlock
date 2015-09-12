//
//  GXPMInfomationCollect.m
//  GXBLESmartHomeFurnishing
//
//  Created by wjq on 14-12-30.
//  Copyright (c) 2014年 guosim. All rights reserved.
//

#import "Common.h"

#import "GXPasswordManagerCollect.h"
#import "GXDeviceModel.h"
#import "NSString+ConvertToString.h"
#import "NSString+StringHexToData.h"
#import "NSData+ToNSString.h"
#import "SharkfoodMuteSwitchDetector.h"
#import <AVFoundation/AVFoundation.h>
//#import "UIView+alert.h"

typedef enum {
    PeripheralStateIsConnected = 0,
    PeripheralStateIsReadingPassword,            // read 得到密码        11b
    PeripheralStateIsReadedCount,                // read 得到密码个数     1b
    PeripheralStateIsWaitingWrite,               // write 添加密码       12b
    PeripheralStateIsWaitingDelete               // write 删除密码        1b
}PeripheralState;

@interface GXPasswordManagerCollect ()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager                 *_centralManager;      //中心设备
    CBPeripheral                     *_connectedPeripheral;   //外围设备
    CGFloat                           _batteryLevel;
    NSString                         *_needDeletePasswordID,*_needDeleteUsername;
    CBService                        *_mainService;
    NSInteger                         _pwdCount;
    PeripheralState                   _peripheralState;
    NSString                         *_addNewName,*_addNewPwd;
    NSString                         *_readPasswordID;
}

@property (nonatomic,strong) SharkfoodMuteSwitchDetector* detector;

@end

@implementation GXPasswordManagerCollect
-(id)initWithCurrentDeviceName:(NSString *)currentDeviceName
{
    if (self = [super init]) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    _currentDeviceName = currentDeviceName;
   
    return self;
}

- (CBCentralManagerState)centralManagerState
{
    return _centralManager.state;
}

- (void)disconnect
{
    [_centralManager stopScan];
    if (_connectedPeripheral !=nil) {
        [_centralManager cancelPeripheralConnection:_connectedPeripheral];
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
            return @"State unknown (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateResetting:
            return @"State resetting (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateUnsupported:
            return @"State BLE unsupported (CBCentralManagerStateResetting)";
        case CBCentralManagerStateUnauthorized:
            return @"State unauthorized (CBCentralManagerStateUnauthorized)";
        case CBCentralManagerStatePoweredOff:
            return @"State BLE powered off (CBCentralManagerStatePoweredOff)";
        case CBCentralManagerStatePoweredOn:
            return @"State powered up and ready (CBCentralManagerStatePoweredOn)";
        default:
            return @"State unknown";
    }
}

/**
 *CentralManager初始化后，检查状态，是不是被BLE所支持，如果支持则开始搜索周围设备
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    GXLog(@"CentralManager State:    %@",[self centralManagerStateToString:central.state]);
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [_centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(YES)}];
        GXLog(@"Strating search for nearby Peripherals");
    }
}


/**
 *  检测外设是否是当前设备
 */

-(BOOL)peripheralIsEqualCurrentDevice:(NSString *)peripheraname
{
    BOOL result;
    if ([_currentDeviceName length] && [peripheraname length]) {
        if ([_currentDeviceName isEqualToString:peripheraname]) {
            result =  YES;
        }
        else {
            result = NO;
        }
    }
    return result;
}

/**
 * 搜索到一个蓝牙设备，若周围蓝牙有多个，则会多次调用
 * 任何广播或扫描的相应数据保存在advertisementData中
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //GXLog(@"Discovered nearby Periapheral:    %@ (RSSI: %d)",advertisementData[@"kCBAdvDataLocalName"],[RSSI intValue]);
    if (_connectedPeripheral !=nil) return;
   
    if (!([[peripheral.name substringWithRange:(NSRange){0,5}] isEqualToString:@"Slock"])) {
        [self refreshPeripheral];
        return;
    }
    //GXLog(@"设备 = %@",_currentDeviceName);
    //GXLog(@"搜索到的设备 = %@",advertisementData[@"kCBAdvDataLocalName"]);
    if ([self peripheralIsEqualCurrentDevice:advertisementData[@"kCBAdvDataLocalName"]]) {
         _connectedPeripheral = peripheral;
        [_centralManager connectPeripheral:peripheral options:nil];
        return;
    }
}

#pragma mark - CBCentralManager代理

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    GXLog(@"CentralManager Failed connect to peripheral:    %@ error:    %@",peripheral.name,error.localizedDescription);
    [self refreshPeripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    GXLog(@"Connected to nearby peripheral:%@",peripheral.name);
    peripheral.delegate = self;
    _peripheralState = PeripheralStateIsConnected;
    //ask the peripheral to discover the service FF20
    [peripheral discoverServices:@[GX_PWD_Service_UUID]];
    GXLog(@"Stop search for nearby peripherials");
    [central stopScan];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    GXLog(@"Disconnect from bearby peripheral:    %@ error:    %@",peripheral.name,error.localizedDescription);;
    _pwdCount = 0;
    [self refreshPeripheral];
}

#pragma mark - 返回的蓝牙服务通过代理实现

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (!error) {
        
        for (CBService *service in peripheral.services) {
            if ([service.UUID isEqual:GX_PWD_Service_UUID]) {
                _mainService = service;
                [peripheral discoverCharacteristics:@[GX_PWD_Read_PWDCount_Service_UUID] forService:service];
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
    //蓝牙特征值为 FF23，读取个数
    if ([character.UUID isEqual:GX_PWD_Read_PWDCount_Service_UUID] && _peripheralState == PeripheralStateIsConnected) {
        //call_back
         [peripheral readValueForCharacteristic:character];
    }
    //蓝牙特征值为 FF22，读取密码
    else if ([character.UUID isEqual:GX_PWD_Read_PWD_Service_UUID] && _peripheralState == PeripheralStateIsReadingPassword){
        for (int i = 0;i<_pwdCount;i++) {
                [peripheral readValueForCharacteristic:character];
        }
    }
    //蓝牙特征值为 FF24,写入操作，删除
    else if([character.UUID isEqual:GX_PWD_Delete_PWD_Service_UUID] && _peripheralState == PeripheralStateIsWaitingDelete) {
    
        NSData *passwordIDData = [_needDeletePasswordID hexToBytes:2];
        [peripheral writeValue:passwordIDData forCharacteristic:character type:CBCharacteristicWriteWithResponse];
    }
    //蓝牙特征值为 FF21,写入操作，添加
    else if ([character.UUID isEqual:GX_PWD_Write_PWD_Service_UUID] && _peripheralState == PeripheralStateIsWaitingWrite){
        if (![_addNewPwd isEqual:nil] && ![_addNewName isEqual:nil]) {
            NSData *passwordIDData = [_addNewPwd hexToBytes:1];
            NSData *addData = [@"#" dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableData *nameData = (NSMutableData *)[_addNewName dataUsingEncoding:NSUTF8StringEncoding];
            if (nameData.length <= 12) {
                NSInteger length = nameData.length;
                NSInteger span = 12 - length;
                for (int i=0; i<span; i++) {
                    [nameData appendData:addData];
                }
                [nameData appendData:passwordIDData];
                GXLog(@"密码名字 = %@，前12位data数据 = %@",_addNewName,nameData);
                GXLog(@"密码    = %@，后6位data数据   = %@",_addNewPwd,passwordIDData);
                GXLog(@"18为data数据 = %@",nameData);
                [peripheral writeValue:nameData forCharacteristic:character type:CBCharacteristicWriteWithResponse];
            }
            
        }
    }
}

-(void)playSound
{
    NSString *pewPewPath = [[NSBundle mainBundle] pathForResource:@"Voicemail" ofType:@"wav"];
    NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
    SystemSoundID pewPewSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &pewPewSound);
    AudioServicesPlaySystemSound(pewPewSound);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(error == nil) {
        if ([characteristic.UUID isEqual:GX_PWD_Delete_PWD_Service_UUID]) {
            if ([_delegate respondsToSelector:@selector(deletePasswordSuccessed:userName:passwordID:)]) {
                [_delegate deletePasswordSuccessed:self userName:_needDeleteUsername passwordID:_needDeletePasswordID];
            }
            self.detector = [SharkfoodMuteSwitchDetector shared];
            [self playSound];
            _peripheralState = PeripheralStateIsConnected;
        }
        else if ([characteristic.UUID isEqual:GX_PWD_Write_PWD_Service_UUID]) {
            [peripheral discoverCharacteristics:@[GX_PWD_Read_PWDCount_Service_UUID] forService:_mainService];
            self.detector = [SharkfoodMuteSwitchDetector shared];
            [self playSound];
            _peripheralState = PeripheralStateIsConnected;
        }
    }
    GXLog(@"WriteKeyResponse:    %@ Error:    %@",characteristic.UUID,error);
}

- (void)serviceBatteryWithPeripheral:(CBPeripheral *)peripheral character:(CBCharacteristic *)character
{
    if ([character.UUID isEqual:GX_Read_BatteryLevel_Characteristic_UUID]) {
        [peripheral readValueForCharacteristic:character];
    }
}

//返回的蓝牙特征值通过代理实现
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (!error) {
        
        for (CBCharacteristic *chara in service.characteristics) {
            GXLog(@"Discovered Characteristic (%@)",chara.UUID.UUIDString);
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
    
    GXLog(@"Characteristic (%@) read:%@",characteristic.UUID.UUIDString,characteristic.value.description);
    
    NSString *charaValue = characteristic.value.description;
    //FF23 读个数
    if ([characteristic.UUID isEqual:GX_PWD_Read_PWDCount_Service_UUID] && _peripheralState == PeripheralStateIsConnected) {
        _pwdCount = [[charaValue ConvertToString] integerValue];
        if (_pwdCount == 0) {
            if ([_delegate respondsToSelector:@selector(AlertWhenNoPasswordAfterScan:)]) {
                [_delegate AlertWhenNoPasswordAfterScan:self];
            }
        } else {
             //准备发现FF22，读取密码
            _peripheralState = PeripheralStateIsReadingPassword;
            [peripheral discoverCharacteristics:@[GX_PWD_Read_PWD_Service_UUID] forService:characteristic.service];
        }
    }
    else if([characteristic.UUID isEqual:GX_PWD_Read_PWD_Service_UUID] && _peripheralState == PeripheralStateIsReadingPassword) {
            NSString *name = [[charaValue ConvertToString] substringFromIndex:2];
            NSString *passwordID = [[charaValue ConvertToString] substringToIndex:2];//密码编号
            _readPasswordID = passwordID;
            NSString *userName = [[NSString alloc] initWithData:[name hexToBytes:2] encoding:NSUTF8StringEncoding];
            NSString *newName = [userName stringByReplacingOccurrencesOfString:@"#" withString:@""];
            if ([_delegate respondsToSelector:@selector(getNewConnectedUser:userName:passwordID:)]) {
                [_delegate getNewConnectedUser:self userName:newName passwordID:passwordID];
                _pwdCount --;
            }
    }
}

#pragma mark - 
#pragma mark - 共有方法的实现

- (void)deletePassword:(NSString *)userName password:(NSString *)passwordID;
{
    _peripheralState = PeripheralStateIsWaitingDelete;
    _needDeletePasswordID = passwordID;
    _needDeleteUsername = userName;
    if (_mainService != nil) {
          [_connectedPeripheral discoverCharacteristics:@[GX_PWD_Delete_PWD_Service_UUID] forService:_mainService];
    }
}

- (void)addNewPassword:(NSString *)userName password:(NSString *)password
{
    _peripheralState = PeripheralStateIsWaitingWrite;
    _addNewName = userName;
    _addNewPwd  = password;
    if(_mainService != nil) {
        [_connectedPeripheral discoverCharacteristics:@[GX_PWD_Write_PWD_Service_UUID]  forService:_mainService];
    }
}

-(NSMutableData *)StringToData:(NSString *)password
{
    NSMutableData* data = [NSMutableData data];
    for (int index = 0; index+1 <= password.length; index+=1) {
        NSRange range = NSMakeRange(index, 1);
        NSString* hexStr = [password substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

@end
