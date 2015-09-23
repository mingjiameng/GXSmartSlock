//
//  GXFirewareUpdateModel.m
//  GXSmartSlock
//
//  Created by zkey on 9/19/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXFirewareUpdateModel.h"

#import "Common.h"
#import "oad.h"
#import "MICRO_COMMON.h"

#import "NSString+StringHexToData.h"

#import "GXDefaultHttpHelper.h"
#import "zkeySandboxHelper.h"
#import "GXUploadDeviceVersionParam.h"

#import <CoreBluetooth/CoreBluetooth.h>

#define HI_UINT16(a) (((a) >> 8) & 0xff)
#define LO_UINT16(a) ((a) & 0xff)

typedef enum{
    PeripheralStateIsReadingVersion,
    PeripheralStateIsUploadVersion,
    PeripheralStateIsStopUpload
}PeripheralState;

@interface GXFirewareUpdateModel () <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    CBCentralManager *_updateFirewareCenterManager;
    CBPeripheral                     *_connectedPeripheral;   //外围设备
    PeripheralState                   _peripheralState;
    CBService                        *_mainService;
    NSTimer *_uploadTimer;
}

@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, strong) NSString *imgVersion;

@property int nBlocks;
@property int nBytes;
@property int iBlocks;
@property int iBytes;

@end


@implementation GXFirewareUpdateModel

-(void) programmingTimerTick:(NSTimer *)timer
{
    NSLog(@"Loaded firmware of size : %lu", (unsigned long)self.fileData.length);
    if (!_isConnected && !_inProgramming) {
        _inProgramming = NO;
        [_uploadTimer invalidate];
        [self disconnect];
        [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
        return;
    }
    
    // 限制锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    unsigned char imageFileData[self.fileData.length];
    [self.fileData getBytes:imageFileData];
    
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
                        GXLog(@"GX_OAD_BlockRequest_UUID 写%@成功",[NSData dataWithBytes:requestData length:2 + OAD_BLOCK_SIZE]);
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
            return;
        }
        else {
            if (ii == 3)[NSTimer scheduledTimerWithTimeInterval:0.09 target:self selector:@selector(programmingTimerTick:) userInfo:nil repeats:NO];
        }
    }
    //float secondsPerBlock = 0.09 / 4;
    //float secondsLeft = (float)(self.nBlocks - self.iBlocks) * secondsPerBlock;
    CGFloat processValue = (float)self.iBlocks / (float)self.nBlocks;
    [self.delegate firewareUpdateProgress:processValue];
}

#pragma mark - CBCentralManager代理
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
//    _isConnected = NO;
//    _inProgramming = NO;
//    _peripheralState = PeripheralStateIsStopUpload;
//    GXLog(@"Firmware: Disconnect from bearby peripheral:    %@ error:    %@",peripheral.name,error.localizedDescription);
//    if ([_delegate respondsToSelector:@selector(canUploadFirmware:enable:)]) {
//        [_delegate canUploadFirmware:self enable:NO];
//    }
//    [central stopScan];
}

//开始上传任务

- (void)updateFireware
{
    if (![GXDefaultHttpHelper isServerAvailable]) {
        [self.delegate noNetwork];
        return;
    }
    
    if (_updateFirewareCenterManager == nil) {
        _updateFirewareCenterManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
}

- (void)startScan
{
    [_updateFirewareCenterManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(YES)}];
}

#pragma mark - central manager delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        [self.delegate noBluetooth];
        return;
    }
    
    [self startScan];
    [self.delegate beginScanForCertainDevice];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (_connectedPeripheral != nil) {
        return;
    }
    
    if ([self peripheralIsEqualCurrentDevice:peripheral.name]) {
        _connectedPeripheral = peripheral;
        [_updateFirewareCenterManager connectPeripheral:peripheral options:nil];
        return;
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _isConnected = YES;
    _inProgramming = YES;
    _peripheralState = PeripheralStateIsReadingVersion;
    peripheral.delegate = self;
    
    [peripheral discoverServices:@[GX_OAD_Service_UUID]];
    
    [central stopScan];
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error != nil) {
        [self startScan];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        if ([service.UUID isEqual:GX_OAD_Service_UUID]) {
            _mainService = service;
            [_connectedPeripheral discoverCharacteristics:@[GX_OAD_ImageNotify_UUID] forService:_mainService];
            
            [self uploadStart];
            
            [self.delegate beginUpdateFireware];
            
            break;
        }
    }
    
    return;
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error != nil) {
        [_connectedPeripheral discoverCharacteristics:@[GX_OAD_ImageNotify_UUID] forService:_mainService];
        return;
    }
    
    if ([service.UUID isEqual:GX_OAD_Service_UUID]) {
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        [self serviceMainWithPeripheral:peripheral chara:characteristic];
    }
    
    return;
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:GX_OAD_ImageNotify_UUID] && characteristic.isNotifying) {
        NSData *data = [@"00" hexToBytes:2];
        [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error != nil) {
        [self startScan];
        return;
    }
    
    if ([characteristic.UUID isEqual:GX_OAD_ImageNotify_UUID]) {
        [peripheral readValueForCharacteristic:characteristic];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error != nil) {
        [self startScan];
        return;
    }
    
    if ([characteristic.UUID isEqual:GX_OAD_ImageNotify_UUID]) {
        unsigned char data[characteristic.value.length];
        [characteristic.value getBytes:&data];
        uint16_t imgVersion = ((uint16_t)data[1] << 8 & 0xff00) | ((uint16_t)data[0] & 0xff);
        self.imgVersion = [NSString stringWithFormat:@"%d",imgVersion>>1];
        NSLog(@"Firmware: self.imgVersion : %@",self.imgVersion);
        if ([self.imgVersion integerValue] < self.downloadedVersion){
            unsigned char imageFileData[self.fileData.length];
            [self.fileData getBytes:imageFileData];
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
//        } else {
//            [self updateVersion:self.imgVersion];
//        }
    }
}

#pragma mark - assistant function

- (void)serviceMainWithPeripheral:(CBPeripheral *)peripheral chara:(CBCharacteristic *)character
{
    if ([character.UUID isEqual:GX_OAD_ImageNotify_UUID] && _peripheralState == PeripheralStateIsReadingVersion){
        //查询版本号
        [peripheral setNotifyValue:YES forCharacteristic:character];
    } else if ([character.UUID isEqual:GX_OAD_BlockRequest_UUID] && _peripheralState == PeripheralStateIsUploadVersion) {
        // 更新固件
        _peripheralState = PeripheralStateIsStopUpload;
        _inProgramming = YES;
        unsigned char imageFileData[self.fileData.length];
        [self.fileData getBytes:imageFileData];
        
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

-(void)uploadStart
{
    _peripheralState = PeripheralStateIsUploadVersion;
    [_connectedPeripheral discoverCharacteristics:@[GX_OAD_BlockRequest_UUID] forService:_mainService];
    
    [self.delegate beginUpdateFireware];
}


-(BOOL)peripheralIsEqualCurrentDevice:(NSString *)deviceIdentifire
{
    if ([self.deviceIdentifire isEqualToString:deviceIdentifire]) {
        return YES;
    }
    
    return NO;
}

- (NSData *)fileData
{
    if (_fileData != nil) {
        return _fileData;
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.bin", [zkeySandboxHelper pathOfDocuments], self.deviceIdentifire];
    
    _fileData = [NSData dataWithContentsOfFile:filePath];
    
    return _fileData;
}

- (void)disconnect
{
    [_updateFirewareCenterManager stopScan];
    if (_connectedPeripheral !=nil) {
        [_updateFirewareCenterManager cancelPeripheralConnection:_connectedPeripheral];
    }
}

// 向服务器上传最新版本的代码
-(void)updateVersion:(NSString *)imageVersion
{
    //    NSInteger version;
    //    BOOL isEven = ([imageVersion integerValue] %2 == 0) ?YES:NO;
    //    if (isEven) {
    //        version = self.downloadedVersion  + 1;
    //    }else{
    //        version = self.downloadedVersion;
    //    }
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_USER_PASSWORD];
    GXUploadDeviceVersionParam *param = [GXUploadDeviceVersionParam paramWithUserName:userName password:password deviceIdentifire:self.deviceIdentifire deviceVersion:self.downloadedVersion];
    [GXDefaultHttpHelper postWithUploadDeviceVersionParam:param success:^(NSDictionary *result) {
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        if (status == 0) {
            [self.delegate firewareUpdateFailed];
        } else if (status == 1) {
            [self.delegate firewareUpdateComplete];
        }
    } failure:^(NSError *error) {
        [self.delegate noNetwork];
    }];
}


@end
