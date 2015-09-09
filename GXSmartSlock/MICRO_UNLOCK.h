//
//  MICRO_UNLOCK.h
//  GXBLESmartHomeFurnishing
//
//  Created by zkey on 6/24/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#ifndef GXBLESmartHomeFurnishing_MICRO_UNLOCK_h
#define GXBLESmartHomeFurnishing_MICRO_UNLOCK_h

#define GX_UNLOCK_SERVICE_CBUUID_IDENTIFY [CBUUID UUIDWithString:@"FF10"]
#define GX_UNLOCK_ADVERTISEMENT_VERIFY @"kCBAdvDataLocalName"
#define GX_UNLOCK_SERVICE_CBUUID_UNLOCK [CBUUID UUIDWithString:@"FFF0"]
#define GX_UNLOCK_CHARACTERISTICS_CBUUID_READ_TOKEN [CBUUID UUIDWithString:@"FFF4"]
#define GX_UNLOCK_CHARACTERISTICS_CBUUID_READ_BATTERY_LEVEL [CBUUID UUIDWithString:@"FFF5"]
#define GX_UNLOCK_CHARACTERISTICS_CBUUID_WRITE_UNLOCK [CBUUID UUIDWithString:@"FFF3"]

#define PERIPHERAL @"peripheral"
#define DEVICE_IDENTIFIRE @"deviceIdentifire"
#define SECRET_KEY @"secretKey"
#define TOKEN @"token"
#define BATTERY_READ @"batteryRead"
#define RSSI_NUMBER @"rssi"
#define WRITE_UNLOCK @"writeUnlock"

#define MAX_UNLOCK_RSSI 87
#define LOW_BATTERY_LEVEL 350
#define SECRET_PREFIX @"01"

#endif
