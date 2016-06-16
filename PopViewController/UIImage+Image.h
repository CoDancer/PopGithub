//
//  UIImage+image.h
//
//
//  Created by Zhu Lizhe on 13-8-28.
//  Copyright (c) 2013年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
// 返回一张已经经过拉伸处理的图片
+ (UIImage *)stretchImageWithName:(NSString *)name;

@end
