//
//  BezierCornerView.m
//  PopViewController
//
//  Created by onwer on 16/4/11.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "WaverView.h"
#import "UIView+Category.h"

@implementation WaveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _lineView = [[UIImageView alloc] initWithImage:CreateUncachedImage(@"post_decibel_line.png")];
        _lineView.centerX = self.width/2.0;
        _lineView.centerY = 0.5 * self.height;
        [self addSubview:_lineView];
    }
    return self;
}

- (void)addWaveWithDecibelValue:(NSInteger)decibel
{
    NSInteger level = ceilf(decibel / 20.0);
    if (level > 0) {
        if (level > 5) {
            level = 5;
        }
        NSString *waveImageName = [NSString stringWithFormat:@"post_decibel_wave%zd.png",level];
        UIImageView *wave = [[UIImageView alloc] initWithImage:CreateUncachedImage(waveImageName)];
        wave.center = CGPointMake(_lineView.right, _lineView.centerY);
        [self addSubview:wave];
        
        [UIView transitionWithView:wave duration:2.0 options:UIViewAnimationOptionCurveLinear animations:^{
            wave.centerX = _lineView.left;
        } completion:^(BOOL finished) {
            [wave removeFromSuperview];
        }];
    }
}

UIImage *CreateUncachedImage(NSString *name)
{
    return [UIImage imageNamed:name];
}


@end
