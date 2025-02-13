//
//  zkeySandboxHelper.m
//  ShengCiBen_Alpha
//
//  Created by Zkey on 15-4-7.
//  Copyright (c) 2015年 overcode. All rights reserved.
//

#import "zkeySandboxHelper.h"

@implementation zkeySandboxHelper

+ (NSString *)pathOfSandbox
{
    return NSHomeDirectory();
}

+ (NSString *)pathOfMainBundle
{
    return [[NSBundle mainBundle] bundlePath];
}

+ (NSString *)pathOfDocuments
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

+ (NSString *)pathOfTmp
{
    return  NSTemporaryDirectory();
}

+ (void)deleteFileAtPath:(NSString *)filePath
{
    if (filePath == nil) {
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        if (![fileManager removeItemAtPath:filePath error:&error]) {
            NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        }
    }
}

+ (BOOL)fileExitAtPath:(NSString *)filePath
{
    if (filePath == nil) {
        return NO;
    }
    
    NSFileManager *fileManeger = [NSFileManager defaultManager];
    if([fileManeger fileExistsAtPath: filePath]) {
        return true;
    }
    
    return false;
}

+ (NSString *)pathOfLibrary
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

+ (NSString *)pathOfLibrary_Caches
{
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArr objectAtIndex:0];
    return path;
}
@end
