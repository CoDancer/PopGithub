//
//  UIImage+image.m
//  
//
//  Created by Zhu Lizhe on 13-8-28.
//  Copyright (c) 2013年 Nick. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

+ (UIImage *)stretchImageWithName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

@end
