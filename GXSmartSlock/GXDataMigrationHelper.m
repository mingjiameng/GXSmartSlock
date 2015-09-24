//
//  GXDataMigrationHelper.m
//  GXSmartSlock
//
//  Created by zkey on 9/24/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXDataMigrationHelper.h"

#import "zkeySandboxHelper.h"
#import "GXOneTimePasswordModel.h"

#import <sqlite3.h>

@implementation GXDataMigrationHelper

+ (void)migrateData
{
    [self removeUnusefulKeyValueInUserInfoDictionary];
    [self migrateOneTimePassword];
}

+ (void)removeUnusefulKeyValueInUserInfoDictionary
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KUnlockMode"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kAutoUnlockMode"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kEmail"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GXRemoteToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kLogout"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUserUUID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kPassWord"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kSecret"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kSound"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kNickName"];
}

+ (void)migrateOneTimePassword
{
    NSString *sqlFilePath = [NSString stringWithFormat:@"%@/ReadMe", [zkeySandboxHelper pathOfDocuments]];
    if (![zkeySandboxHelper fileExitAtPath:sqlFilePath]) {
        return;
    }
    
    sqlite3 *database = NULL;
    if (SQLITE_OK != sqlite3_open([sqlFilePath UTF8String], &database)) {
        return;
    }
    
    NSString *sqlSentence = @"SELECT * FROM T_Password";
    sqlite3_stmt *stmt = NULL;
    NSMutableArray *passwordModelArray = [NSMutableArray array];
    
    if (SQLITE_OK == sqlite3_prepare_v2(database, [sqlSentence UTF8String], -1, &stmt, NULL)) {
        
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            const unsigned char *deviceIdentifire     = sqlite3_column_text(stmt, 1);
            const unsigned char *password      = sqlite3_column_text(stmt, 2);
            const unsigned char *validity = sqlite3_column_text(stmt, 3);
            
            GXOneTimePasswordModel *passwordModel = [[GXOneTimePasswordModel alloc] init];
            passwordModel.deviceIdentifre = [NSString stringWithUTF8String:(const char *)deviceIdentifire];
            passwordModel.password = [NSString stringWithUTF8String:(const char *)password];
            passwordModel.validity = [[NSString stringWithUTF8String:(const char *)validity] boolValue];
            
            [passwordModelArray addObject:passwordModel];
        }
    }
    
    // send to database
}

@end
