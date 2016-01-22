//
//  UIButton+Category.m
//  PopViewController
//
//  Created by onwer on 15/12/25.
//  Copyright © 2015年 onwer. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)

+ (UIButton *)getButtonWithTitle:(NSString *)titleName titleColor:(UIColor *)color textFont:(UIFont *)font backgroundColor:(UIColor *)BGColor {
    
    UIButton *customButton = [UIButton new];
    [customButton setTitle:titleName forState:UIControlStateNormal];
    [customButton setTitleColor:color forState:UIControlStateNormal];
    [customButton.titleLabel setFont:font];
    [customButton setBackgroundColor:BGColor];
    [customButton sizeToFit];
    
    return customButton;
}

@end
