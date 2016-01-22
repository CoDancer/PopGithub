//
//  Cards3DViewController.m
//  PopViewController
//
//  Created by onwer on 16/1/22.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "Cards3DViewController.h"
#import "CardWith3DView.h"
#import "ShakeButton.h"
#import "UIView+Category.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#define k_IOS_Scale [[UIScreen mainScreen] bounds].size.width/320

@interface Cards3DViewController()

@property (nonatomic, strong) CardWith3DView *cardsView;
@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, strong) ShakeButton *addGesBtn;

@end

@implementation Cards3DViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageArr = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:[[NSBundle mainBundle] pathForResource:@"IMAGE" ofType:nil]];
    [self.view addSubview:self.cardsView];
    [self.view addSubview:self.addGesBtn];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.addGesBtn.centerX = self.view.centerX;
    self.addGesBtn.top = self.cardsView.bottom + 20;
}


- (CardWith3DView *)cardsView {
    
    if (!_cardsView) {
        CGRect frame = CGRectMake(0, 100*k_IOS_Scale, 320*k_IOS_Scale, 280*k_IOS_Scale);
        _cardsView = [[CardWith3DView alloc] initWithFrame:frame
                                                  imageArr:self.imageArr
                                                     index:self.imageArr.count/2];
    }
    return _cardsView;
}

- (ShakeButton *)addGesBtn {
    
    if (!_addGesBtn) {
        _addGesBtn = [ShakeButton shakeButton];
        [_addGesBtn addTarget:self action:@selector(addGesBtnOnView) forControlEvents:UIControlEventTouchUpInside];
        [_addGesBtn setTitle:@"addGes" forState:UIControlStateNormal];
        [_addGesBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [_addGesBtn sizeToFit];
        [_addGesBtn setBackgroundColor:[UIColor colorWithRed:0.218 green:0.724 blue:0.607 alpha:1.000]];
    }
    return _addGesBtn;
}

- (void)addGesBtnOnView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddGes" object:nil];
}

@end
