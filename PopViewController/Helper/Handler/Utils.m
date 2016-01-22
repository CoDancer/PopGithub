//
//  Utils.m
//  PopViewController
//
//  Created by onwer on 16/1/7.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "Utils.h"
#import "NSFileManager+Category.h"

@implementation Utils

+ (NSString*)userPath {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [docPath stringByAppendingPathComponent:@"100"];
}

+ (NSString*)otherImagePath {
    
    NSString *path = [[self userPath] stringByAppendingPathComponent:@"otherImages"];
    if (path.length == 0) {
        path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"otherImages"];
    }
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
    } else if (!isDir) {
        return nil;
    }
    
    return path;
    
}

@end
