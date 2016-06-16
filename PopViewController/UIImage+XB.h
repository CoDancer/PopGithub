//
//  UIImage+XB.h
//  FC
//
//  Created by pengjay on 14/11/15.
//  Copyright (c) 2014年 h. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XB)
- (UIImage *)imageScaleToFitSize:(CGSize)bounds;
- (UIImage *)imageScaleToFillSize:(CGSize)bounds;
- (UIImage *)imageByFlipVertical;
@end
