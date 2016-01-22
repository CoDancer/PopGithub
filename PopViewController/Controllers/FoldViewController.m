//
//  FoldViewController.m
//  PopViewController
//
//  Created by onwer on 16/1/10.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "FoldViewController.h"
#import "UIView+Category.h"
#import "UIButton+Category.h"
#import <pop/POP.h>

@interface FoldViewController()

@property (nonatomic, strong) UIView *foldView;
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, strong) UIButton *openDoor;
@property (nonatomic, strong) UIView *leftDoorView;
@property (nonatomic, strong) UIView *rightDoorView;

@end

@implementation FoldViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"FoldView";
    [self.view addSubview:self.foldView];
    [self.view addSubview:self.currentView];
    [self.currentView addSubview:self.leftDoorView];
    [self.currentView addSubview:self.rightDoorView];
    [self.currentView addSubview:self.openDoor];
}

- (UIView *)foldView {
    
    if (!_foldView) {
        _foldView = [UIView new];
        _foldView.backgroundColor = [UIColor grayColor];
        CATransform3D foldAni = CATransform3DIdentity;
        foldAni.m34 = 1.0 / -2000;
        _foldView.frame = CGRectMake(0, 64, 0, self.currentView.height);
        _foldView.layer.anchorPoint = CGPointMake(0, 0.5);
        foldAni = CATransform3DRotate(foldAni, 90, 0, 1, 0);
        _foldView.layer.transform = foldAni;
    }
    return _foldView;
}

- (UIView *)currentView {
    
    if (!_currentView) {
        _currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)];
        _currentView.backgroundColor = [UIColor colorWithRed:0.435 green:0.724 blue:0.273 alpha:1.000];
        [self addRightAndLeftGesToCurrentView];
    }
    return _currentView;
}

- (UIButton *)openDoor {
    
    if (!_openDoor) {
        _openDoor = [UIButton getButtonWithTitle:@"Open-Door" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.198 green:0.495 blue:0.724 alpha:1.000]];
        [_openDoor setTitle:@"CloseDoor" forState:UIControlStateSelected];
        [_openDoor sizeToFit];
        [_openDoor addTarget:self action:@selector(viewDidOpen:) forControlEvents:UIControlEventTouchUpInside];
        _openDoor.centerX = self.view.centerX;
        _openDoor.top = self.leftDoorView.bottom + 20;
    }
    return _openDoor;
}

- (UIView *)leftDoorView {
    
    if (!_leftDoorView) {
        _leftDoorView = [UIView new];
        _leftDoorView.frame = CGRectMake(self.view.centerX - 100, 100, 100, 180);
        _leftDoorView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _leftDoorView.layer.shadowOffset = CGSizeMake(-4, 4);
        _leftDoorView.layer.shadowOpacity = 0.8;
        [_leftDoorView.layer setAnchorPoint:CGPointMake(0, 0.5)];
        _leftDoorView.layer.position = CGPointMake(self.view.centerX - 100, 190);
        _leftDoorView.layer.transform = [self transform3D];
        _leftDoorView.backgroundColor = [UIColor whiteColor];
    }
    return _leftDoorView;
}

- (UIView *)rightDoorView {
    
    if (!_rightDoorView) {
        _rightDoorView = [UIView new];
        _rightDoorView.frame = CGRectMake(self.view.centerX + 1 , 100, 100, 180);
        _rightDoorView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _rightDoorView.layer.shadowOffset = CGSizeMake(4, 4);
        _rightDoorView.layer.shadowOpacity = 0.8;
        [_rightDoorView.layer setAnchorPoint:CGPointMake(1, 0.5)];
        _rightDoorView.layer.position = CGPointMake(self.view.centerX + 101, 190);
        _rightDoorView.layer.transform = [self transform3D];
        _rightDoorView.backgroundColor = [UIColor whiteColor];
    }
    return _rightDoorView;
}

- (void)addRightAndLeftGesToCurrentView {
    UISwipeGestureRecognizer *rightSwipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCurrentView:)];
    rightSwipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [_currentView addGestureRecognizer:rightSwipeGes];
    
    UISwipeGestureRecognizer *leftSwipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCurrentView:)];
    leftSwipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
    [_currentView addGestureRecognizer:leftSwipeGes];
}

- (void)viewDidOpen:(UIButton *)sender {
    
    self.openDoor.selected = !sender.selected;
    if (sender.selected == YES) {
        [self openDoorAni];
    }else {
        [self closeDoorAni];
    }
}

- (void)openDoorAni {
    
    POPBasicAnimation *leftRotationAni = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotationY];
    leftRotationAni.duration = 1.0;
    leftRotationAni.toValue = @(M_PI/3.0);
    [self.leftDoorView.layer pop_addAnimation:leftRotationAni forKey:@"leftOpenRotationAnimation"];
    
    POPBasicAnimation *rightRotationAni = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotationY];
    rightRotationAni.duration = 1.0;
    rightRotationAni.toValue = @(-M_PI/3.0);
    [self.rightDoorView.layer pop_addAnimation:rightRotationAni forKey:@"rightOpenRotationAnimation"];
}

- (void)closeDoorAni {
    
    POPBasicAnimation *leftRotationAni = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotationY];
    leftRotationAni.duration = 1.0;
    leftRotationAni.toValue = @(0);
    [self.leftDoorView.layer pop_addAnimation:leftRotationAni forKey:@"leftCloseRotationAnimation"];
    
    POPBasicAnimation *rightRotationAni = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotationY];
    rightRotationAni.duration = 1.0;
    rightRotationAni.toValue = @(0);
    [self.rightDoorView.layer pop_addAnimation:rightRotationAni forKey:@"rightCloseRotationAnimation"];
}

- (void)swipeCurrentView:(UISwipeGestureRecognizer *)ges {
    
    NSLog(@"OK");
    if (ges.direction == UISwipeGestureRecognizerDirectionRight) {
        [self currentViewDidSwipeRightAnimation];
    }else if (ges.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self currentViewDidSwipeLeftAnimation];
    }
}

- (void)currentViewDidSwipeRightAnimation {
    
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{

        CATransform3D foldAni = CATransform3DIdentity;
        foldAni.m34 = 1.0 / -2000;
        self.foldView.layer.anchorPoint = CGPointMake(0, 0.5);
        foldAni = CATransform3DRotate(foldAni, 0, M_PI/2, 1, 0);
        self.foldView.frame = CGRectMake(0, 64, 100, self.currentView.height);
        self.foldView.layer.transform = foldAni;
        
        self.currentView.frame = CGRectMake(99, 64,
                                            self.view.width - 99,
                                            self.currentView.height);
        
    } completion:^(BOOL finished) {
    }];
}

- (void)foldViewAnimation {
    
    CATransform3D foldAni = CATransform3DIdentity;
    foldAni.m34 = 1.0 / -2000;
    foldAni = CATransform3DRotate(foldAni, 0, 0, 0, self.currentView.height);
    self.currentView.layer.transform = foldAni;
}

- (void)currentViewDidSwipeLeftAnimation {
    
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        self.currentView.frame = CGRectMake(0, 64,
                                            self.view.width,
                                            self.currentView.height);
        CATransform3D foldAni = CATransform3DIdentity;
        foldAni.m34 = 1.0 / -2000;
        foldAni = CATransform3DRotate(foldAni, M_PI/2, 0, 1, 0);
        self.foldView.layer.transform = foldAni;
        self.foldView.frame = CGRectMake(0, 64, 0, self.currentView.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (CATransform3D)transform3D {
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 2.5 / -2000;
    return transform;
}


@end
