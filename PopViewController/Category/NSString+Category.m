//
//  NSString+Category.m
//  PopViewController
//
//  Created by onwer on 16/1/7.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "NSString+Category.h"
#import "Utils.h"
#import "NSData+Category.h"

@implementation NSString (Category)

- (NSString*)otherImageDownloadPath {
    return [[[Utils otherImagePath] stringByAppendingPathComponent:self.SHA1HashString] stringByAppendingPathExtension:@"jpg"];
}

- (NSString *)SHA1HashString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] SHA1HashString];
}

+ (NSString *)urlString:(NSString *)strUrl {
    
//    NSURL *url = [NSURL URLWithString:strUrl];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
//    return retStr;
    
    NSString *urlString = strUrl;
    NSString *agentString = @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_6; en-us) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/3.2.1 Safari/525.27.1";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:                                                      [NSURL URLWithString:urlString]]; [request setValue:agentString forHTTPHeaderField:@"User-Agent"];
    NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil ];
    NSString *returnData = [[NSString alloc] initWithBytes: [data bytes] length:[data length]                                           encoding: NSUTF8StringEncoding];
    NSLog(@"%@", returnData);

    return returnData;
}

-(NSMutableArray *)substringByRegular:(NSString *)regular {
    
    NSString * reg=regular;
    
    NSRange r= [self rangeOfString:reg options:NSRegularExpressionSearch];
    
    NSMutableArray *arr=[NSMutableArray array];
    
    if (r.length != NSNotFound &&r.length != 0) {
        
        int i=0;
        
        while (r.length != NSNotFound &&r.length != 0) {
            
            NSLog(@"index = %i regIndex = %d loc = %d",(++i),r.length,r.location);
            
            NSString* substr = [self substringWithRange:r];
            
            NSLog(@"substr = %@",substr);
            
            [arr addObject:substr];
            
            NSRange startr=NSMakeRange(r.location+r.length, [self length]-r.location-r.length);
            
            r=[self rangeOfString:reg options:NSRegularExpressionSearch range:startr];
        }
    }
    return arr;
}

@end
