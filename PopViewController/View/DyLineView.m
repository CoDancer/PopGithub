//
//  DyLineView.m
//  PopViewController
//
//  Created by onwer on 16/4/12.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "DyLineView.h"
#import "UIView+Category.h"

@interface DyLineView()

@end

@implementation DyLineView

//- (instancetype)initWithFrame:(CGRect)frame LineView:(CGFloat)height {
//    
//    self.height = height;
//    return [self initWithFrame:frame];
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)addWaveWithDecibelValue:(NSInteger)decibel directionLeft:(BOOL)left
{
    NSInteger level = ceilf(decibel / 20.0);
    if (level > 0) {
        if (level > 5) {
            level = 5;
        }
        if (decibel > self.height) {
            decibel = decibel * 0.9;
            if (decibel > self.height) {
                decibel = self.height;
            }
        }else if (decibel < 15) {
            decibel = 3;
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2.0, decibel)];
        lineView.layer.cornerRadius = 1.5;
        lineView.clipsToBounds = YES;
        if (left) {
            lineView.left = self.width;
        }
        lineView.backgroundColor = [UIColor redColor];
        lineView.centerY = self.height/2.0;
        [self addSubview:lineView];
        [UIView transitionWithView:lineView duration:1.8 options:UIViewAnimationOptionCurveLinear animations:^{
            if (left) {
                lineView.centerX = 0;
            }else {
                lineView.centerX = self.width;
            }
            
        } completion:^(BOOL finished) {
            [lineView removeFromSuperview];
        }];
    }
}

@end
