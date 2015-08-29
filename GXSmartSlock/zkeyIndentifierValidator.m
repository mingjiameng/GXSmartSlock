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

/*
 移动、联通、电信手机号码开头分别是什么？  
 目前全国有27种手机号段。  
 
 移动有16个号段：134、135、136、137、138、139、147、150、151、152、157、158、159、182、183、187、188。
 其中147、157、188是3G号段，其他都是2G号段。  
 
 联通有7种号段：130、131、132、155、156、185、186。其中186是3G（WCDMA）号段，其余为2G号段。  
 电信有4个号段：133、153、180、189。其中189是3G号段（CDMA2000），133号段主要用作无线网卡号。  
 150、151、152、153、155、156、157、158、159      九个 
 130、131、132、133、134、135、136、137、138、139    十个 
 180、182、183、185、186、187、188、189            七个
 13、15、18三个号段共30个号段，154、181、184暂时没有，加上147共27个。
 
 虚拟运营商：170、171
 */

+ (BOOL)isValidChinesePhoneNumber:(NSString *)phoneNumber
{
    NSString *regex = @"^((13[0-9])|(147)|(17[0,1])|(15[^4,\\D])|(18[0,2,3,5-9]))\\d{8}$";
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
