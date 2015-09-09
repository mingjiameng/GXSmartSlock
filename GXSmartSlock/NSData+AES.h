//
//  NSData+AES.h
//  GXBLESmartHomeFurnishing
//
//  Created by xu li on 13/5/14.
//  Copyright (c) 2014 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)

- (NSData *)AES256EncryptWithKey:(NSString *)key;
//- (NSData *)AES256DecryptionWithKey: (NSString*)key;

@end
