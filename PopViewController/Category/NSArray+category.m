//
//  NSArray+category.m
//  PopViewController
//
//  Created by onwer on 15/12/23.
//  Copyright © 2015年 onwer. All rights reserved.
//

#import "NSArray+category.h"

@implementation NSArray (category)

-(id)objectOrNilAtIndex:(NSUInteger)i {
    if (i < [self count]) {
        return [self objectAtIndex:i];
    }
    return nil;
}

@end
