//
//  GXContactModel.h
//  GXSmartSlock
//
//  Created by zkey on 9/6/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXContactModel : NSObject

@property (nonatomic, strong) NSString *phoneNumber; // the "phoneNumber" may be mobilePhoneNumber or email-address
@property (nonatomic, strong) NSString *nickname; // the name of contact
@property (nonatomic, strong) NSString *pinyinString; // pinyin of nickname (pinyin == nickname if the nickname is English)

+ (GXContactModel *)modelWithUserName:(NSString *)phoneNumber nickname:(NSString *)nickname;

@end
