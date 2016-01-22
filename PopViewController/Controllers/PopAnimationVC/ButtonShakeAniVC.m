//
//  ButtonShakeAniVC.m
//  PopViewController
//
//  Created by onwer on 16/1/13.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "ButtonShakeAniVC.h"
#import "ShakeButton.h"
#import "UIView+Category.h"
#import <pop/POP.h>
#import "FoldingView.h"

@interface ButtonShakeAniVC()<POPAnimationDelegate>

@property (nonatomic, strong) ShakeButton *shakeButton;
@property (nonatomic, strong) ShakeButton *foldViewBtn;
@property (nonatomic, strong) UIView *upBaseView;
@property (nonatomic, strong) UIView *dragView;

@property (nonatomic, strong) FoldingView *foldView;

@end

@implementation ButtonShakeAniVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"ButtonShake";
    [self configView];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    self.shakeButton.size = CGSizeMake(60, 30);
    self.shakeButton.top = 64 + 10;
    self.shakeButton.left = 10;
    
    self.upBaseView.frame = self.view.bounds;
    self.dragView.size = CGSizeMake(100, 100);
    self.dragView.center = self.upBaseView.center;
    self.dragView.layer.cornerRadius = self.dragView.height/2.0;
    
    self.foldViewBtn.size = self.shakeButton.size;
    self.foldViewBtn.top = self.shakeButton.top;
    self.foldViewBtn.left = self.shakeButton.right + 10;
}

- (void)configView {
    
    [self addButton];
}

- (void)addButton {
    
    [self.view addSubview:self.shakeButton];
    [self.view addSubview:self.foldViewBtn];
}

- (ShakeButton *)shakeButton {
    
    if (!_shakeButton) {
        _shakeButton = [ShakeButton shakeButton];
        [_shakeButton addTarget:self action:@selector(shakeButtonDidTap) forControlEvents:UIControlEventTouchUpInside];
        [_shakeButton setTitle:@"shake" forState:UIControlStateNormal];
        [_shakeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [_shakeButton setBackgroundColor:[UIColor colorWithRed:0.094 green:0.724 blue:0.305 alpha:1.000]];
    }
    return _shakeButton;
}

- (ShakeButton *)foldViewBtn {
    
    if (!_foldViewBtn) {
        _foldViewBtn = [ShakeButton shakeButton];
        [_foldViewBtn addTarget:self action:@selector(foldViewBtnDidTap) forControlEvents:UIControlEventTouchUpInside];
        [_foldViewBtn setTitle:@"fold" forState:UIControlStateNormal];
        [_foldViewBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [_foldViewBtn setBackgroundColor:[UIColor colorWithRed:0.218 green:0.724 blue:0.607 alpha:1.000]];
    }
    return _foldViewBtn;
}

- (UIView *)dragView {
    
    if (!_dragView) {
        _dragView = [UIView new];
        _dragView.backgroundColor = [UIColor colorWithRed:0.246 green:0.156 blue:0.724 alpha:1.000];
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(handlePan:)];
        [_dragView addGestureRecognizer:recognizer];
    }
    return _dragView;
}

- (UIView *)upBaseView {
    
    if (!_upBaseView) {
        _upBaseView = [UIView new];
        _upBaseView.backgroundColor = [UIColor lightGrayColor];
        _upBaseView.alpha = 0.0;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(upBaseViewDidTap)];
        [_upBaseView addGestureRecognizer:tapGes];
    }
    return _upBaseView;
}

- (FoldingView *)foldView {
    
    if (!_foldView) {
        CGSize imageSize = [UIImage imageNamed:@"katong2"].size;
        CGFloat imageScale = imageSize.height/imageSize.width;
        CGFloat imageWidth = self.view.width - 60;
        CGRect foldViewFrame = CGRectMake(0, 0, imageWidth, imageWidth * imageScale);
        _foldView = [[FoldingView alloc] initWithFrame:foldViewFrame image:[UIImage imageNamed:@"katong2"]];
        _foldView.centerX = self.upBaseView.centerX;
        _foldView.bottom = self.upBaseView.bottom - 60;
    }
    return _foldView;
}

- (void)upBaseViewDidTap {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.dragView.alpha = 0;
        self.upBaseView.alpha = 0;
        self.foldView.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.dragView) {
            [self.dragView removeFromSuperview];
        }else if (self.upBaseView) {
            [self.upBaseView removeFromSuperview];
        }else if (self.foldView) {
            [self.foldView removeFromSuperview];
        }
    }];
}

- (void)handlePan:(UIPanGestureRecognizer *)ges {
    
    CGPoint translation = [ges translationInView:self.upBaseView];
    ges.view.center = CGPointMake(ges.view.centerX + translation.x,
                                  ges.view.centerY + translation.y);
    [ges setTranslation:CGPointMake(0, 0) inView:self.upBaseView];
    if (ges.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [ges velocityInView:self.upBaseView];
        POPDecayAnimation *decayAni = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        decayAni.delegate = self;
        decayAni.velocity = [NSValue valueWithCGPoint:velocity];
        [ges.view.layer pop_addAnimation:decayAni forKey:@"layerPositionAnimation"];
    }
}

- (void)pop_animationDidApply:(POPDecayAnimation *)anim {
    
    BOOL isDragViewOutsideOfSuperView = !CGRectContainsRect(self.upBaseView.frame, self.dragView.frame);
    if (isDragViewOutsideOfSuperView) {
        CGPoint currentVelocity = [anim.velocity CGPointValue];
        POPSpringAnimation *springAni = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        springAni.velocity = [NSValue valueWithCGPoint:currentVelocity];
        springAni.toValue = [NSValue valueWithCGPoint:self.upBaseView.center];
        [self.dragView.layer pop_addAnimation:springAni forKey:@"layerPositionAnimation"];
    }
}

- (void)shakeButtonDidTap {
    
    [self buttonShake];
    [self addDecayView];
}

- (void)foldViewBtnDidTap {
    
    [self.view addSubview:self.upBaseView];
    [self.view addSubview:self.foldView];
    [UIView animateWithDuration:0.5 animations:^{
        self.upBaseView.alpha = 0.6;
        self.foldView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)buttonShake {
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 20;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        self.shakeButton.userInteractionEnabled = YES;
    }];
    [self.shakeButton.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)addDecayView {
    
    [self.view addSubview:self.upBaseView];
    [self.view addSubview:self.dragView];
    [UIView animateWithDuration:0.5 animations:^{
        self.upBaseView.alpha = 0.6;
        self.dragView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}


@end
