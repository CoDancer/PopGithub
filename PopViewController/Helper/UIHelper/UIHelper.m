//
//  UIHelper.m
//  PopViewController
//
//  Created by onwer on 15/12/29.
//  Copyright © 2015年 onwer. All rights reserved.
//

#import "UIHelper.h"

@implementation UIHelper

+ (UIButton *)commomButtonWithFrame:(CGRect)frame title:(NSString*)title titleColor:(UIColor*)color titleFont:(UIFont*)font selectedImage:(UIImage*)selectedImage image:(UIImage*)image {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.font = font;
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button setImage:image forState:UIControlStateNormal];
    button.exclusiveTouch = YES;
    return button;
}

@end
