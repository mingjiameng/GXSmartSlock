//
//  GXUserModel.h
//  GXSmartSlock
//
//  Created by zkey on 8/22/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXUserModel : NSObject

@property (nonatomic) NSInteger userID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *nickname;

@end
