//
//  GXPhoneContactModel.m
//  GXSmartSlock
//
//  Created by zkey on 11/10/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXPhoneContactModel.h"

#import "GXContactModel.h"

#import <AddressBook/AddressBook.h>

@implementation GXPhoneContactModel

+ (nonnull NSDictionary *)sortedContactInfoDictionary
{
    NSArray *contactArr = [GXPhoneContactModel contactArray];
    
    for (GXContactModel *contactModel in contactArr) {
        contactModel.pinyinString = [GXPhoneContactModel pinyinOfChineseString:contactModel.nickname];
    }
    
    NSMutableDictionary *contactDictionary = [[NSMutableDictionary alloc] init];
    for (GXContactModel *contactModel in contactArr) {
        NSString *key = nil;
        if (contactModel.pinyinString.length <= 0) {
            key = @"#";
        } else {
            key = [contactModel.pinyinString substringToIndex:1];
        }
        
        NSMutableArray *correspondContactArr = [contactDictionary objectForKey:key];
        if (correspondContactArr == nil) {
            correspondContactArr = [NSMutableArray array];
            [contactDictionary setObject:correspondContactArr forKey:key];
        }
        
        [correspondContactArr addObject:contactModel];
    }
    
    NSArray *keysInDictionary = [contactDictionary allKeys];
    for (NSString *key in keysInDictionary) {
        NSMutableArray *correspondContactArr = [contactDictionary objectForKey:key];
        
        [correspondContactArr sortedArrayUsingComparator:^NSComparisonResult(GXContactModel * _Nonnull obj1, GXContactModel   * _Nonnull obj2) {
            return [obj1.pinyinString compare:obj2.pinyinString];
        }];
     }
    
    return (NSDictionary *)contactDictionary;
}

/*
 * Translate the chinese name into pinyin(combined with first letter of pinyin of every hanzi)
 * eg. 梁志鹏 -> LZP | Elizbas -> Elizbas
*/

+ (nonnull NSString *)pinyinOfChineseString:(nonnull NSString *)chineseString
{
    NSString *pinyinString = @"";
    
    for (NSInteger index = 0; index < chineseString.length; ++index) {
        char c = [chineseString characterAtIndex:index];
        
        pinyinString = [pinyinString stringByAppendingString:[[NSString stringWithFormat:@"%c", pinyinFirstLetter(c)] uppercaseString]];
    }
    
    return pinyinString;
}

+ (nonnull NSArray *)contactArray
{
    ABAddressBookRef addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
    
    //获取通讯录权限
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    NSMutableArray *contactArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < CFArrayGetCount(allPeople); ++i) {
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        
        NSString *firstName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if (firstName == nil) {
            firstName = @"";
        } else {
            firstName = [firstName stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if (lastName == nil) {
            lastName = @"";
        } else {
            lastName = [lastName stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        NSString *userNickname= [lastName stringByAppendingString:firstName];
        
        ABMultiValueRef phoneArray = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (CFIndex index = 0; index < ABMultiValueGetCount(phoneArray); ++index) {
            NSString *phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneArray, index);
            if (phoneNumber != nil) {
                phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
                phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                
                GXContactModel *contactModel = [GXContactModel modelWithUserName:phoneNumber nickname:userNickname];
                [contactArr addObject:contactModel];
            }
        }
        
        ABMultiValueRef emailArray = ABRecordCopyValue(person, kABPersonEmailProperty);
        for (CFIndex index = 0; index < ABMultiValueGetCount(emailArray); ++index) {
            NSString *emailAddress = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emailArray, index);
            if (emailAddress != nil) {
                GXContactModel *contactModel = [GXContactModel modelWithUserName:emailAddress nickname:userNickname];
                [contactArr addObject:contactModel];
            }
        }
    }
    
    return (NSArray *)contactArr;
}

@end
