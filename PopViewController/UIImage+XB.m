//
//  UIImage+XB.m
//  FC
//
//  Created by pengjay on 14/11/15.
//  Copyright (c) 2014年 h. All rights reserved.
//

#import "UIImage+XB.h"

#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>
#import <CoreText/CoreText.h>
#import <objc/runtime.h>

@implementation UIImage (XB)

+ (CGSize)size:(CGSize)origiSize scaleFitSize:(CGSize)fitSize
{
    CGFloat factor = fitSize.height/origiSize.height;
    if (origiSize.width > origiSize.height) {
        if (origiSize.width <= fitSize.width) {
            return origiSize;
        }
        factor = fitSize.width/origiSize.width;
    }
    
    //    CGFloat factor1 = fitSize.width/origiSize.width;
    //    CGFloat factor2 = fitSize.height/origiSize.height;
    //    CGFloat factor = MIN(factor1, factor2);
    CGFloat resultWidth = origiSize.width * factor;
    CGFloat resultHeight = origiSize.height * factor;
    return CGSizeMake(resultWidth, resultHeight);
}

+ (CGSize)size:(CGSize)origiSize scaleFillSize:(CGSize)fitSize
{
    CGFloat factor = fitSize.height/origiSize.height;
    if (origiSize.width < origiSize.height) {
        if (origiSize.width <= fitSize.width) {
            return origiSize;
        }
        factor = fitSize.width/origiSize.width;
    }
    //    CGFloat factor1 = fitSize.width/origiSize.width;
    //    CGFloat factor2 = fitSize.height/origiSize.height;
    //    CGFloat factor = MAX(factor1, factor2);
    CGFloat resultWidth = origiSize.width * factor;
    CGFloat resultHeight = origiSize.height * factor;
    return CGSizeMake(resultWidth, resultHeight);
}

- (UIImage *)imageScaleToFitSize:(CGSize)bounds
{
    //	CGFloat factor1 = bounds.width/self.size.width;
    //    CGFloat factor2 = bounds.height/self.size.height;
    //    CGFloat factor = MIN(factor1, factor2);
    //	CGFloat resultWidth = self.size.width * factor;
    //	CGFloat resultHeight = self.size.height * factor;
    
    CGSize size = [[self class] size:self.size scaleFitSize:bounds];
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)imageScaleToFillSize:(CGSize)bounds
{
    //	CGFloat factor1 = bounds.width/self.size.width;
    //    CGFloat factor2 = bounds.height/self.size.height;
    //    CGFloat factor = MAX(factor1, factor2);
    //	CGFloat resultWidth = self.size.width * factor;
    //	CGFloat resultHeight = self.size.height * factor;
    
    CGSize size = [[self class] size:self.size scaleFillSize:bounds];
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)imageByFlipVertical {
    return [self _xb_flipHorizontal:NO vertical:YES];
}

- (UIImage *)_xb_flipHorizontal:(BOOL)horizontal vertical:(BOOL)vertical {
    if (!self.CGImage) return nil;
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    size_t bytesPerRow = width * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    UInt8 *data = (UInt8 *)CGBitmapContextGetData(context);
    if (!data) {
        CGContextRelease(context);
        return nil;
    }
    vImage_Buffer src = { data, height, width, bytesPerRow };
    vImage_Buffer dest = { data, height, width, bytesPerRow };
    if (vertical) {
        vImageVerticalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    if (horizontal) {
        vImageHorizontalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    return img;
}

- (UIImage *)imageByFlipHorizontal {
    return [self _xb_flipHorizontal:YES vertical:NO];
}

@end
