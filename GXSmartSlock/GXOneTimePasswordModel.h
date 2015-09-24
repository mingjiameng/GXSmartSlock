//
//  GXOneTimePasswordModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/24/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXOneTimePasswordModel : NSObject

@property (nonatomic, strong) NSString *deviceIdentifre;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, getter=isValid) BOOL validity;

@end
