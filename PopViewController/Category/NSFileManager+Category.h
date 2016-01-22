//
//  NSFileManager+Category.h
//  PopViewController
//
//  Created by onwer on 16/1/7.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Category)

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)url;

@end
