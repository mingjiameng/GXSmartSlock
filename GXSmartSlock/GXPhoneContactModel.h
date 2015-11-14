//
//  GXPhoneContactModel.h
//  GXSmartSlock
//
//  Created by zkey on 11/10/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "zkeyFirstLetterOfChinese.h"

@interface GXPhoneContactModel : NSObject

/*
 dictionary = {
    @"A" : [ContactModelA, ... , ContactModelB],
    @"D" : [ContactModelC, ... , ContactModelD]
 }
 
 The ContactModel array is sorted according to the first letter of (pinyin of chinese || english word)
 
 */

+ (nonnull NSDictionary *)sortedContactInfoDictionary;

+ (nonnull NSArray *)contactArray;

@end
