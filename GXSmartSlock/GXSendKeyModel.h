//
//  GXSendKeyModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/6/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXSendKeyModel : NSObject

+ (NSArray *)sendKey:(NSString *)deviceIdentifire to:(NSArray *)contactModelArray withAuthority:(NSString *)authorityType;

@end
