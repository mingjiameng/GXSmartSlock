//
//  GXFirmwareConnect.m
//  GXBLESmartHomeFurnishing
//
//  Created by wjq on 15-1-19.
//  Copyright (c) 2015年 guosim. All rights reserved.
//

#import "GXFirmwareConnect.h"

#import "Common.h"
#import "oad.h"
#import "MICRO_COMMON.h"

#import "NSString+StringHexToData.h"
#import "GXDatabaseHelper.h"
#import "GXDefaultHttpHelper.h"
#import "zkeySandboxHelper.h"
#import "GXUploadDeviceVersionParam.h"

#import <CoreBluetooth/CoreBluetooth.h>

typedef enum{
    PeripheralStateIsReadingVersion,
    PeripheralStateIsUploadVersion,
    PeripheralStateIsStopUpload
}PeripheralState;

@interface GXFirmwareConnect()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager                 *_centralManager;      //中心设备
    CBPeripheral                     *_connectedPeripheral;   //外围设备
    PeripheralState                   _peripheralState;
    CBService                        *_mainService;
    
    NSString                  *_pathFile;
    
    NSData *fileData;

}
@property int nBlocks;
@property int nBytes;
@property int iBlocks;
@property int iBytes;

@end


@implementation GXFirmwareConnect


-(id)initWithCurrentDeviceName:(NSString *)currentDeviceName
{
    if (self = [super init]) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        self.currentDeviceName = currentDeviceName;
        _pathFile = [NSString stringWithFormat:@"%@/%@.bin", [zkeySandboxHelper pathOfDocuments], currentDeviceName];
    }
    
    return self;
}


-(void) programmingTimerTick:(NSTimer *)timer {
    
    fileData = [NSData dataWithContentsOfFile:_pathFile];
    //NSLog(@"Loaded firmware \"%@\"of size : %lu",_pathFile,(unsigned long)fileData.length);
    if (!_isConnected && !_inProgramming) {
        _inProgramming = NO;
        [_uploadTimer invalidate];
        [self disconnect];
        [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
        return;
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    unsigned char imageFileData[fileData.length];
    [fileData getBytes:imageFileData];
    
    //Prepare Block
    uint8_t requestData[2 + OAD_BLOCK_SIZE];
    
    // This block is run 4 times, this is needed to get CoreBluetooth to send consequetive packets in the same connection interval.
    for (int ii = 0; ii < 4; ii++) {
        
        requestData[0] = LO_UINT16(self.iBlocks);
        requestData[1] = HI_UINT16(self.iBlocks);
        
        memcpy(&requestData[2] , &imageFileData[self.iBytes], OAD_BLOCK_SIZE);
        
        for ( CBService *service in _connectedPeripheral.services ) {
            if ([service.UUID isEqual:GX_OAD_Service_UUID]) {
                for ( CBCharacteristic *characteristic in service.characteristics ) {
                    if ([characteristic.UUID isEqual:GX_OAD_BlockRequest_UUID]) {
                        /* EVERYTHING IS FOUND, WRITE characteristic ! */
                        [_connectedPeripheral writeValue:[NSData dataWithBytes:requestData length:2 + OAD_BLOCK_SIZE] forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
                        //GXLog(@"GX_OAD_BlockRequest_UUID 写%@成功",[NSData dataWithBytes:requestData length:2 + OAD_BLOCK_SIZE]);
                    }
                }
            }
        }
        self.iBlocks++;
        self.iBytes += OAD_BLOCK_SIZE;
        
        if(self.iBlocks == self.nBlocks) {
            _inProgramming = NO;
            _isConnected = NO;
            [self updateVersion:self.imgVersion];
            _peripheralState = PeripheralStateIsStopUpload;
            return;
        }
        else {
            if (ii == 3)[NSTimer scheduledTimerWithTimeInterval:0.09 target:self selector:@selector(programmingTimerTick:) userInfo:nil repeats:NO];
        }
    }
//    float secondsPerBlock = 0.09 / 4;
//    float secondsLeft = (float)(self.nBlocks - self.iBlocks) * secondsPerBlock;
    CGFloat processValue = (float)self.iBlocks / (float)self.nBlocks;
//    NSString *process = [NSString stringWithFormat:@"%0.1f%%",(float)((float)self.iBlocks / (float)self.nBlocks) * 100.0f];
//    NSString *total = [NSString stringWithFormat:@"%d:%02d",(int)(secondsLeft / 60),(int)secondsLeft - (int)(secondsLeft / 60) * (int)60];
//    GXLog(@"上传进度 = %@",process);
//    GXLog(@"上传总时间 = %@",total);
    [self.delegate firewareUpdateProgress:processValue];
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
            return @"Firmware: State unknown (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateResetting:
            return @"Firmware: State resetting (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateUnsupported:
            return @"Firmware: State BLE unsupported (CBCentralManagerStateResetting)";
        case CBCentralManagerStateUnauthorized:
            return @"Firmware: State unauthorized (CBCentralManagerStateUnauthorized)";
        case CBCentralManagerStatePoweredOff:
            return @"Firmware: State BLE powered off (CBCentralManagerStatePoweredOff)";
        case CBCentralManagerStatePoweredOn:
            return @"Firmware: State powered up and ready (CBCentralManagerStatePoweredOn)";
        default:
            return @"Firmware: State unknown";
    }
}

/**
 *CentralManager初始化后，检查状态，是不是被BLE所支持，如果支持则开始搜索周围设备
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    GXLog(@"Firmware: CentralManager State:    %@",[self centralManagerStateToString:central.state]);
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [_centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(YES)}];
        GXLog(@"Firmware: Strating search for nearby Peripherals");
    }else if (central.state == CBCentralManagerStatePoweredOff){
        GXLog(@"蓝牙关闭");
        [self.delegate noBluetooth];
        _isConnected =NO;
        _inProgramming = NO;
    }
}

- (void)startScan
{
    [_centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(YES)}];
}

/**
 *  检测外设是否是当前设备
 */

-(BOOL)peripheralIsEqualCurrentDevice:(NSString *)peripheraname
{
    BOOL result = NO;
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
    GXLog(@"Firmware: Discovered nearby Periapheral:    %@ (RSSI: %d)",advertisementData[@"kCBAdvDataLocalName"],[RSSI intValue]);
    if (_connectedPeripheral !=nil)
        return;
    GXLog(@"设备 = %@",_currentDeviceName);
    GXLog(@"搜索到的设备 = %@",advertisementData[@"kCBAdvDataLocalName"]);
    if ([self peripheralIsEqualCurrentDevice:advertisementData[@"kCBAdvDataLocalName"]]) {
        _connectedPeripheral = peripheral;
        [_centralManager connectPeripheral:peripheral options:nil];
        return;
    }
}

#pragma mark - CBCentralManager代理

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _isConnected = NO;
    _inProgramming = NO;
    [self.delegate firewareUpdateFailed];
    [central stopScan];
    GXLog(@"Firmware: CentralManager Failed connect to peripheral:    %@ error:    %@",peripheral.name,error.localizedDescription);
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _isConnected = YES;
    _inProgramming = YES;
    _peripheralState = PeripheralStateIsReadingVersion;
    peripheral.delegate = self;
    [peripheral discoverServices:@[GX_OAD_Service_UUID]];
    
    [self performSelector:@selector(uploadStart) withObject:nil afterDelay:2.0];
    
    GXLog(@"Firmware: Stop search for nearby peripherials");
    [central stopScan];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (_peripheralState != PeripheralStateIsUploadVersion) {
        [self.delegate firewareUpdateFailed];
    }
    
    _isConnected = NO;
    _inProgramming = NO;
    _peripheralState = PeripheralStateIsStopUpload;
    GXLog(@"Firmware: Disconnect from bearby peripheral:    %@ error:    %@",peripheral.name,error.localizedDescription);
    [central stopScan];
}

#pragma mark - 返回的蓝牙服务通过代理实现

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
     GXLog(@"Firmware: didDiscoverServices bearby peripheral:    %@ error:    %@",peripheral.name,error.localizedDescription);
    if (error == nil) {
        for (CBService *service in peripheral.services) {
            if ([service.UUID isEqual:GX_OAD_Service_UUID]) {
                _mainService = service;
                [_connectedPeripheral discoverCharacteristics:@[GX_OAD_ImageNotify_UUID] forService:_mainService];
            }
        }
        return;
    }
    [_centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(YES)}];
}

- (void)serviceMainWithPeripheral:(CBPeripheral *)peripheral chara:(CBCharacteristic *)character
{
    //查询版本号
    if ([character.UUID isEqual:GX_OAD_ImageNotify_UUID] && _peripheralState == PeripheralStateIsReadingVersion){
        [peripheral setNotifyValue:YES forCharacteristic:character];
    }
    //上传版本
    else if ([character.UUID isEqual:GX_OAD_BlockRequest_UUID] && _peripheralState == PeripheralStateIsUploadVersion) {
        _peripheralState = PeripheralStateIsStopUpload;
        GXLog(@"当前版本号 = %@",self.imgVersion);
        fileData = [NSData dataWithContentsOfFile:_pathFile];
        _inProgramming = YES;
        unsigned char imageFileData[fileData.length];
        [fileData getBytes:imageFileData];
        
        img_hdr_t imgHeader;
        memcpy(&imgHeader, &imageFileData[0 + OAD_IMG_HDR_OSET], sizeof(img_hdr_t));
        uint8_t requestData[OAD_IMG_HDR_SIZE + 2 + 2]; // 12Bytes
    
        
        requestData[0] = LO_UINT16(imgHeader.ver);
        requestData[1] = HI_UINT16(imgHeader.ver);
        
        requestData[2] = LO_UINT16(imgHeader.len);
        requestData[3] = HI_UINT16(imgHeader.len);
        
        NSLog(@"Image version = %04hx, len = %04hx",imgHeader.ver,imgHeader.len);
        
        memcpy(requestData + 4, &imgHeader.uid, sizeof(imgHeader.uid));
        
        requestData[OAD_IMG_HDR_SIZE + 0] = LO_UINT16(12);
        requestData[OAD_IMG_HDR_SIZE + 1] = HI_UINT16(12);
        
        requestData[OAD_IMG_HDR_SIZE + 2] = LO_UINT16(15);
        requestData[OAD_IMG_HDR_SIZE + 1] = HI_UINT16(15);
        
       
        for ( CBService *service in peripheral.services ) {
            if ([service.UUID isEqual:GX_OAD_Service_UUID]) {
                for ( CBCharacteristic *characteristic in service.characteristics ) {
                    if ([characteristic.UUID isEqual:GX_OAD_ImageNotify_UUID]) {
                        /* EVERYTHING IS FOUND, WRITE characteristic ! */
                        [peripheral writeValue:[NSData dataWithBytes:requestData length:OAD_IMG_HDR_SIZE + 2 + 2] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                        
                    }
                }
            }
        }
        self.nBlocks = imgHeader.len / (OAD_BLOCK_SIZE / HAL_FLASH_WORD_SIZE);
        self.nBytes = imgHeader.len * HAL_FLASH_WORD_SIZE;
        self.iBlocks = 0;
        self.iBytes = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            _uploadTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(programmingTimerTick:) userInfo:nil repeats:NO];
        });
    }
}

//开始上传任务
-(void)uploadStart
{
    _peripheralState = PeripheralStateIsUploadVersion;
    [_connectedPeripheral discoverCharacteristics:@[GX_OAD_BlockRequest_UUID] forService:_mainService];
    
    [self.delegate beginUpdateFireware];
}
/**
 * setNotifyValue 回调
 */

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:GX_OAD_ImageNotify_UUID] && characteristic.isNotifying) {
        NSData *data = [@"00" hexToBytes:2];
        [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
  
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:GX_OAD_ImageNotify_UUID]) {
        [peripheral readValueForCharacteristic:characteristic];
    }
    GXLog(@"Firmware: WriteKeyResponse:    %@ Error:    %@",characteristic.UUID,error);
}

//返回的蓝牙特征值通过代理实现
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (!error) {
        
        for (CBCharacteristic *chara in service.characteristics) {
            GXLog(@"Firmware: Discovered Characteristic (%@)",chara.UUID.UUIDString);
            if ([service.UUID isEqual:GX_OAD_Service_UUID]) {
                [self serviceMainWithPeripheral:peripheral chara:chara];
            }
        }
        return;
    }
}


-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
         [_centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(YES)}];
        return;
    }
    GXLog(@"Firmware: Characteristic (%@) read:%@",characteristic.UUID.UUIDString,characteristic.value.description);
    if ([characteristic.UUID isEqual:GX_OAD_ImageNotify_UUID]) {
        unsigned char data[characteristic.value.length];
        [characteristic.value getBytes:&data];
        uint16_t  imgVersion = ((uint16_t)data[1] << 8 & 0xff00) | ((uint16_t)data[0] & 0xff);
        self.imgVersion = [NSString stringWithFormat:@"%d",imgVersion>>1];
        NSLog(@"Firmware: self.imgVersion : %@",self.imgVersion);
        if ([self.imgVersion integerValue] < _fw_version){
            fileData = [NSData dataWithContentsOfFile:_pathFile];
            unsigned char imageFileData[fileData.length];
            [fileData getBytes:imageFileData];
            uint8_t requestData[OAD_IMG_HDR_SIZE + 2 + 2]; // 12Bytes
            for(int ii = 0; ii < 20; ii++) {
                NSLog(@"%02hhx",imageFileData[ii]);
            }
            img_hdr_t imgHeader;
            memcpy(&imgHeader, &imageFileData[0 + OAD_IMG_HDR_OSET], sizeof(img_hdr_t));

            requestData[0] = LO_UINT16(imgHeader.ver);
            requestData[1] = HI_UINT16(imgHeader.ver);
            
            requestData[2] = LO_UINT16(imgHeader.len);
            requestData[3] = HI_UINT16(imgHeader.len);
            
            NSLog(@"Image version = %04hx, len = %04hx",imgHeader.ver,imgHeader.len);
            
            memcpy(requestData + 4, &imgHeader.uid, sizeof(imgHeader.uid));
            
            requestData[OAD_IMG_HDR_SIZE + 0] = LO_UINT16(12);
            requestData[OAD_IMG_HDR_SIZE + 1] = HI_UINT16(12);
            
            requestData[OAD_IMG_HDR_SIZE + 2] = LO_UINT16(15);
            requestData[OAD_IMG_HDR_SIZE + 1] = HI_UINT16(15);
 
            [peripheral writeValue:[NSData dataWithBytes:requestData length:OAD_IMG_HDR_SIZE + 2 + 2] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            
            self.nBlocks = imgHeader.len / (OAD_BLOCK_SIZE / HAL_FLASH_WORD_SIZE);
            self.nBytes = imgHeader.len * HAL_FLASH_WORD_SIZE;
            self.iBlocks = 0;
            self.iBytes = 0;
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(programmingTimerTick:) userInfo:nil repeats:NO];
        }
        else {
            [self updateVersion:self.imgVersion];
        }
    }
}

-(void)updateVersion:(NSString *)imageVersion
{
     NSInteger version;
    BOOL isEven = ([imageVersion integerValue] %2 == 0) ?YES:NO;
    if (isEven) {
        version = _fw_version  + 1;
    }else{
        version = _fw_version;
    }
    
    GXFirmwareConnect *__weak weakSelf = self;
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    GXUploadDeviceVersionParam *param = [GXUploadDeviceVersionParam paramWithUserName:userName password:password deviceIdentifire:self.currentDeviceName deviceVersion:version];
    [GXDefaultHttpHelper postWithUploadDeviceVersionParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        if (status == 0) {
            
        } else if (status == 1) {
            [weakSelf.delegate firewareUpdateComplete];
            [weakSelf disconnect];
            [GXDatabaseHelper device:self.currentDeviceName updateFirewareVersion:version];
        }
    } failure:^(NSError *error) {
        [weakSelf.delegate noNetwork];
    }];
}


@end
