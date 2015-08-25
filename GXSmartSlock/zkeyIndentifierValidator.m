//
//  zkeyIndentifierValidator.m
//  FenHongForIOS
//
//  Created by zkey on 8/11/15.
//  Copyright (c) 2015 GuoXinTech. All rights reserved.
//

#import "zkeyIndentifierValidator.h"

@implementation zkeyIndentifierValidator

+ (BOOL) isValidCreditNumber:(NSString*)creditNumber
{
    NSInteger length = [creditNumber length];
    
    if (length < 13) {
        return NO;
    }
    
    BOOL result = [self isNumberString:creditNumber];
    if (!result) {
        return NO;
    }
    
    // ... the bank of the credit card
    NSInteger twoDigitBegincreditNumber = [[creditNumber substringWithRange:NSMakeRange(0, 2)] integerValue];

    if([creditNumber hasPrefix:@"4"]) {
        //VISA
        if (length == 13 || length == 16) {
            result = YES;
        }else {
            result = NO;
        }
    } else if(twoDigitBegincreditNumber >= 51 && twoDigitBegincreditNumber <= 55 && length == 16) {
        //MasterCard
        result = NO;
    } else if(([creditNumber hasPrefix:@"34"] || [creditNumber hasPrefix:@"37"]) && length == 15){
        result = YES;
    } else if([creditNumber hasPrefix:@"6011"] && length == 16) {
        //Discover
        result = YES;
    } else {
        result = NO;
    }
    
    if (!result) {
        return NO;
    }
    
    return [self isValidBankCardNumber:creditNumber];
}

+(BOOL)isValidBankCardNumber:(NSString *)cardNumber
{
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    
    for (NSInteger i = cardNumber.length - 1; i >= 0; i--) {
        digit = [cardNumber characterAtIndex:i] - '0';
        if (timesTwo) {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        } else {
            addend = digit;
        }
        
        sum += addend;
        timesTwo = !timesTwo;
    }
    
    int modulus = sum % 10;
    
    return modulus == 0;
}

+ (BOOL)isStringWithNumberAndAlphabet:(NSString *)str
{
    for (NSInteger index = 0; index < str.length; ++index) {
        char c = [str characterAtIndex:index];
        
        if (!([self isNumber:c] || [self isAlphabet:c] )) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)isValidChinesePhoneNumber:(NSString *)phoneNumber
{
    NSString *regex = @"^((13[0-9])|(147)|(170)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:phoneNumber];
}

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:emailAddress];
}

+ (BOOL)isNumber:(char)c
{
    if (!('0' <= c && c <= '9')) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isAlphabet:(char)c
{
    if (!( ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') )) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isNumberString:(NSString *)str
{
    for (NSInteger index = 0; index < str.length; ++index) {
        char c = [str characterAtIndex:index];
        if (! ('0' <= c && c <= '9')) {
            return YES;
        }
    }
    
    return NO;
}

@end
