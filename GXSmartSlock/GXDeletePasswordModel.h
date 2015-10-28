//
//  GXDeletePasswordModel.h
//  GXSmartSlock
//
//  Created by zkey on 10/20/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXDeletePasswordModel : NSObject

+ (void)deletePassword:(NSInteger)passwordID ofDevice:(NSString *)deviceIdentifire byApproach:(NSString *)approach;

@end
