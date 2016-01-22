//
//  Transform2DOr3DVC.m
//  PopViewController
//
//  Created by onwer on 16/1/5.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "Transform2DOr3DVC.h"
#import "UIButton+Category.h"
#import "UIView+Category.h"
#import <POP/POP.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface Transform2DOr3DVC()

@property (nonatomic, assign) BOOL firstRotateFlag;
@property (nonatomic, assign) BOOL firstScaleFlag;
@property (nonatomic, assign) BOOL firstTranslateFlag;
@property (nonatomic, assign) BOOL firstTotalFlag;
@property (nonatomic, assign) CGFloat moveX;
@property (nonatomic, assign) CGFloat moveY;
@property (nonatomic, assign) CGFloat transformTX;
@property (nonatomic, assign) CGFloat transformTY;

@property (nonatomic, assign) BOOL first3DRotateFlag;
@property (nonatomic, assign) BOOL first3DScaleFlag;
@property (nonatomic, assign) BOOL first3DTranslateFlag;
@property (nonatomic, assign) BOOL first3DTotalFlag;


@property (nonatomic, assign) int touchTimes;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation Transform2DOr3DVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"2D_3D Animation";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configView];
}

- (void)configView {
    
    [self add2DAnimationBtnToView];
    [self add3DAnimationBtnToView];
}

- (void)add2DAnimationBtnToView {
    
    UILabel *_2DLabel = [UILabel new];
    _2DLabel.text = @"2DAnimation";
    _2DLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [_2DLabel sizeToFit];
    _2DLabel.textColor = [UIColor lightGrayColor];
    _2DLabel.left = 10;
    _2DLabel.top = 64 + 10;
    [self.view addSubview:_2DLabel];
    
    UIButton *rotateBtn = [UIButton getButtonWithTitle:@"RotateBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:13.0f] backgroundColor:[UIColor colorWithRed:0.724 green:0.228 blue:0.720 alpha:1.000]];
    rotateBtn.tag = 100;
    [rotateBtn addTarget:self action:@selector(doRotate:) forControlEvents:UIControlEventTouchUpInside];
    rotateBtn.left = 10;
    rotateBtn.top = _2DLabel.bottom + 20;
    [self.view addSubview:rotateBtn];
    
    UIButton *scaleBtn = [UIButton getButtonWithTitle:@"ScaleBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:13.0f] backgroundColor:[UIColor colorWithRed:0.318 green:0.254 blue:0.724 alpha:1.000]];
    scaleBtn.top = rotateBtn.top;
    scaleBtn.left = rotateBtn.right + 10;
    [scaleBtn addTarget:self action:@selector(doScale:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scaleBtn];
    
    UIButton *translate = [UIButton getButtonWithTitle:@"TranslateBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:13.0f] backgroundColor:[UIColor colorWithRed:0.201 green:0.507 blue:0.724 alpha:1.000]];
    [translate addTarget:self action:@selector(doTranslate:) forControlEvents:UIControlEventTouchUpInside];
    translate.top = rotateBtn.top;
    translate.left = scaleBtn.right + 10;
    [self.view addSubview:translate];
    
    UIButton *totalTrans = [UIButton getButtonWithTitle:@"TotalBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:13.0f] backgroundColor:[UIColor colorWithRed:0.318 green:0.254 blue:0.724 alpha:1.000]];
    [totalTrans addTarget:self action:@selector(doTotalTrans:) forControlEvents:UIControlEventTouchUpInside];
    totalTrans.top = rotateBtn.top;
    totalTrans.left = translate.right + 10;
    [self.view addSubview:totalTrans];
}

- (void)doRotate:(UIButton *)sender {
    
    [UIView animateWithDuration:1.0 delay:0 options:0 animations:^{
        if (_firstRotateFlag) {
            sender.transform = CGAffineTransformRotate(sender.transform, DEGREES_TO_RADIANS(90));
        }else {
            sender.transform = CGAffineTransformRotate(sender.transform, DEGREES_TO_RADIANS(-90));
        }
        _firstRotateFlag = !_firstRotateFlag;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)doScale:(UIButton *)sender {

    CGAffineTransform scaleTr = CGAffineTransformScale(sender.transform, 1.5, 1.5);
    //[sender.layer setAnchorPoint:CGPointMake(0, 1)];
    [UIView animateWithDuration:1 delay:0 options:0 animations:^{
        if (_firstScaleFlag) {
            sender.transform = CGAffineTransformScale(sender.transform, 1.0/1.5, 1.0/1.5);
        }else {
            sender.transform = scaleTr;
        }
        _firstScaleFlag = !_firstScaleFlag;
    } completion:^(BOOL finished) {
    }];
}

- (void)doTranslate:(UIButton *)sender {
    
    [UIView animateWithDuration:1.0 delay:0 options:0 animations:^{
        if (_firstTranslateFlag) {
            sender.transform = CGAffineTransformTranslate(sender.transform,
                                                           -_moveX,
                                                           -_moveY);
        }else {
            _moveX = self.view.centerX - sender.centerX;
            _moveY = self.view.centerY - sender.bottom;
            sender.transform = CGAffineTransformTranslate(sender.transform,
                                                          _moveX,
                                                          _moveY);
        }
        _firstTranslateFlag = !_firstTranslateFlag;
    } completion:^(BOOL finished) {
    
    }];
}

- (void)doTotalTrans:(UIButton *)sender {
    
    [UIView animateWithDuration:1.0 delay:0 options:0 animations:^{
        if (_firstTotalFlag) {
            
            sender.transform = CGAffineTransformRotate(sender.transform, DEGREES_TO_RADIANS(-90));
            sender.transform = CGAffineTransformScale(sender.transform, 1.0/1.2, 1.0/1.2);
            sender.transform = CGAffineTransformTranslate(sender.transform,
                                                          -_transformTX,
                                                          -_transformTY);
        }else {
            sender.transform = CGAffineTransformRotate(sender.transform, DEGREES_TO_RADIANS(90));
            sender.transform = CGAffineTransformScale(sender.transform, 1.2, 1.2);
            _moveX = self.view.centerY - sender.bottom;
            sender.transform = CGAffineTransformTranslate(sender.transform,
                                                          _moveX,
                                                          _moveX);
            _transformTX = sender.transform.tx;
            _transformTY = sender.transform.ty;
        }
        _firstTotalFlag = !_firstTotalFlag;
        
    } completion:^(BOOL finished) {
    }];
}

- (void)add3DAnimationBtnToView {
    
    UILabel *_3DLabel = [UILabel new];
    _3DLabel.text = @"3DAnimation";
    _3DLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [_3DLabel sizeToFit];
    _3DLabel.textColor = [UIColor lightGrayColor];
    _3DLabel.left = 10;
    _3DLabel.top = [self.view viewWithTag:100].bottom + 30;
    [self.view addSubview:_3DLabel];
    
    UIButton *_3DRotateBtn = [UIButton getButtonWithTitle:@"3DRotateBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:13.0f] backgroundColor:[UIColor colorWithRed:0.369 green:0.724 blue:0.721 alpha:1.000]];
    _3DRotateBtn.tag = 101;
    _3DRotateBtn.layer.shadowColor = [UIColor grayColor].CGColor;
    _3DRotateBtn.layer.shadowOffset = CGSizeMake(4, 4);
    _3DRotateBtn.layer.shadowOpacity = 0.7;
    [_3DRotateBtn addTarget:self action:@selector(_3DRotateBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    _3DRotateBtn.left = 10;
    _3DRotateBtn.top = _3DLabel.bottom + 20;
    [self.view addSubview:_3DRotateBtn];
    
    UIButton *_3DTranslateBtn = [UIButton getButtonWithTitle:@"3DTranslateBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:13.0f] backgroundColor:[UIColor colorWithRed:0.180 green:0.724 blue:0.373 alpha:1.000]];
    [_3DTranslateBtn addTarget:self action:@selector(_3DTranslateBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    _3DTranslateBtn.left = _3DRotateBtn.right + 10;
    _3DTranslateBtn.top = _3DRotateBtn.top;
    [self.view addSubview:_3DTranslateBtn];
    
    UIButton *_3DTotalBtn = [UIButton getButtonWithTitle:@"3DTotalBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:13.0f] backgroundColor:[UIColor colorWithRed:0.110 green:0.679 blue:0.724 alpha:1.000]];
    [_3DTotalBtn addTarget:self action:@selector(_3DTotalBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    _3DTotalBtn.left = _3DTranslateBtn.right + 10;
    _3DTotalBtn.top = _3DTranslateBtn.top;
    [self.view addSubview:_3DTotalBtn];
}

- (void)_3DRotateBtnTap:(UIButton *)sender {
    
    [UIView animateWithDuration:1.0 delay:0 options:0 animations:^{
        if (_first3DRotateFlag) {
            CATransform3D rotate3D = CATransform3DIdentity;
            rotate3D.m34 = 1.0 / 2000;
            rotate3D.m22 = rotate3D.m33 = 1.0;
            sender.layer.transform = rotate3D;
        }else {
            CATransform3D rotate3D = CATransform3DIdentity;
            rotate3D.m34 = 1.0 / 2000;
            rotate3D = CATransform3DMakeRotation(M_PI, 1, 1, 1);
            sender.layer.transform = rotate3D;
        }
        _first3DRotateFlag = !_first3DRotateFlag;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)_3DTranslateBtnTap:(UIButton *)sender {
    
    [UIView animateWithDuration:1.0 delay:0 options:0 animations:^{
        if (_first3DTranslateFlag) {
            CATransform3D translate3D = CATransform3DIdentity;
            translate3D.m22 = translate3D.m33 = 1.0;
            sender.layer.transform = translate3D;
        }else {
            CATransform3D translate3D = CATransform3DIdentity;
            translate3D = CATransform3DMakeTranslation(100, 100, 100);
            sender.layer.transform = translate3D;
        }
        _first3DTranslateFlag = !_first3DTranslateFlag;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)_3DTotalBtnTap:(UIButton *)sender {
    _touchTimes++;
    if (_touchTimes > 4) {
        return;
    }else {
       [self addDifferentViewToViewWithTouchTimes:_touchTimes];
    }
    
}

- (void)addDifferentViewToViewWithTouchTimes:(int)times {
    CGFloat rotateBtnBottom = [self.view viewWithTag:101].bottom;
    CGFloat heigth = self.view.height - rotateBtnBottom - 50 * 2;
    CGFloat width = self.view.width - 50 * 2 + 10 * 2 * times;
    double val1 = arc4random() % 5 + 1;
    double val2 = arc4random() % 6 + 1;
    double val3 = arc4random() % 8 + 1;
    double red = 1.0/val1;
    double green = 1.0/val2;
    double blue = 1.0/val3;
    UIView *firstView = [[UIView alloc]
                         getDifferentViewWithFrame:CGRectZero
                         BGC:[UIColor colorWithRed:red green:green blue:blue alpha:1.000]
                         weatherCor:YES];
    firstView.tag = 1000 + times;
    [self addGestureWithWhichView:firstView];
    [UIView animateWithDuration:0.6 delay:0 options:0 animations:^{
        firstView.frame = CGRectMake(50 - 10 * times, rotateBtnBottom + 20 + 12 * times, width, heigth);
        [self.view addSubview:firstView];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)addGestureWithWhichView:(UIView *)view {
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doHandlePanAction:)];
    [view addGestureRecognizer:pan];
}

- (void)doHandlePanAction:(UIPanGestureRecognizer *)ges {
    
    CGPoint point = [ges translationInView:self.view];
    NSLog(@"X:%f;Y:%f",point.x,point.y);
    UIView *aimView = [self.view viewWithTag:ges.view.tag];
    if (ges.view.centerY == aimView.centerY) {
        ges.view.center = CGPointMake(ges.view.centerX + point.x,
                                      ges.view.centerY);
        [ges setTranslation:CGPointMake(0, 0) inView:self.view];
        if (ges.state == UIGestureRecognizerStateEnded ) {
            if (ges.view.centerX - self.view.centerX < 150 |
                self.view.centerX - ges.view.centerX < 150) {
                CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.x"];
                spring.damping = 15;
                spring.stiffness = 100;
                spring.mass = 1;
                spring.initialVelocity = 0;
                spring.fromValue = [NSNumber numberWithFloat:ges.view.centerX];
                spring.toValue = [NSNumber numberWithFloat:self.view.centerX];
                spring.duration = spring.settlingDuration;
                [ges.view.layer addAnimation:spring forKey:spring.keyPath];
                ges.view.center = CGPointMake(self.view.centerX,
                                              ges.view.centerY);
            }
        }else if (ges.view.centerX - self.view.centerX >= 150){
            [UIView animateWithDuration:0.3 animations:^{
                ges.view.frame = CGRectMake(self.view.width, ges.view.top, ges.view.width, ges.view.height);
            } completion:^(BOOL finished) {
                [ges.view removeFromSuperview];
            }];
        }else if (self.view.centerX - ges.view.centerX >= 150){
            [UIView animateWithDuration:0.3 animations:^{
                ges.view.frame = CGRectMake(-self.view.width, ges.view.top, ges.view.width, ges.view.height);
            } completion:^(BOOL finished) {
                [ges.view removeFromSuperview];
            }];
        }
        
    }else {
        return;
    }
}

-(void)addAnimationToView:(UIView *)view {
    
    
    
}

@end
