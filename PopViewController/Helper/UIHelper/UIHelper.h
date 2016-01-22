//
//  UIHelper.h
//  PopViewController
//
//  Created by onwer on 15/12/29.
//  Copyright © 2015年 onwer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIHelper : NSObject

+ (UIButton *)commomButtonWithFrame:(CGRect)frame title:(NSString*)title titleColor:(UIColor*)color titleFont:(UIFont*)font selectedImage:(UIImage*)selectedImage image:(UIImage*)image;

@end
