//
//  NSString+Category.h
//  PopViewController
//
//  Created by onwer on 16/1/7.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

- (NSString*)otherImageDownloadPath;

+ (NSString *)urlString:(NSString *)strUrl;

-(NSMutableArray *)substringByRegular:(NSString *)regular;

@end
