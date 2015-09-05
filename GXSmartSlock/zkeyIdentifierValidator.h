//
//  zkeyIdentifierValidator.h
//  FenHongForIOS
//
//  Created by zkey on 8/11/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zkeyIdentifierValidator : NSObject

+ (BOOL)isValidCreditNumber:(NSString*)numberString;
+ (BOOL)isValidBankCardNumber:(NSString *)cardNumber;
+ (BOOL)isStringWithNumberAndAlphabet:(NSString *)str;
+ (BOOL)isValidChinesePhoneNumber:(NSString *)phoneNumber;
+ (BOOL)isValidEmailAddress:(NSString *)emailAddress;

@end

