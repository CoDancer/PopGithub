//
//  NSFileManager+Category.m
//  PopViewController
//
//  Created by onwer on 16/1/7.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "NSFileManager+Category.h"

@implementation NSFileManager (Category)

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)url
{
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    return error == nil;
}

@end
