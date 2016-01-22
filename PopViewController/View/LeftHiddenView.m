//
//  LeftHiddenView.m
//  PopViewController
//
//  Created by onwer on 15/12/28.
//  Copyright © 2015年 onwer. All rights reserved.
//

#define GlobalColor(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//背景的灰色
#define BackgroundGrayColor GlobalColor(51, 52, 53)
#define MainColor GlobalColor(72,211,178)

#import "LeftHiddenView.h"
#import "UIHelper.h"
#import "UIView+Category.h"

@interface LeftHiddenView()

@property (nonatomic, strong) UIButton *choiceAddressBtn;
@property (nonatomic, strong) UIButton *recoverBtn;
@property (nonatomic, strong) UIButton *mainViewBtn;
@property (nonatomic, strong) UIButton *foundViewBtn;

@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIImageView *userLogoImageView;
@property (nonatomic, strong) UILabel *userLoginState;




@end

@implementation LeftHiddenView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BackgroundGrayColor;
        [self addSubview:self.choiceAddressBtn];
        [self addSubview:self.mainViewBtn];
        [self addSubview:self.foundViewBtn];
        [self addSubview:self.lineImageView];
        
        [self addSubview:self.userLogoImageView];
        [self addSubview:self.userLoginState];
    }
    return self;
}

- (UIButton *)choiceAddressBtn {
    
    if (!_choiceAddressBtn) {
        _choiceAddressBtn = [UIHelper commomButtonWithFrame:CGRectZero title:@"请选择"
                                                 titleColor:[UIColor lightGrayColor]
                                                  titleFont:[UIFont systemFontOfSize:18.0f]
                                                    selectedImage:[UIImage imageNamed:@"selectedAddress"]
                                                      image:[UIImage imageNamed:@"index_address_icon_6P"]];
        [_choiceAddressBtn setTitleColor:MainColor forState:UIControlStateSelected];
        [_choiceAddressBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 30)];
        [_choiceAddressBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 5)];
        [_choiceAddressBtn setBackgroundColor:[UIColor blackColor]];
        _choiceAddressBtn.layer.cornerRadius = 8.0f;
        _choiceAddressBtn.clipsToBounds = YES;
        [_choiceAddressBtn addTarget:self action:@selector(choiceAddress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choiceAddressBtn;
}

- (UIButton *)mainViewBtn {
    
    if (!_mainViewBtn) {
        _mainViewBtn = [UIHelper commomButtonWithFrame:CGRectZero
                                                 title:@"首页"
                                            titleColor:[UIColor lightGrayColor]
                                             titleFont:[UIFont systemFontOfSize:16.0f]
                                               selectedImage:nil
                                                 image:nil];
    }
    return _mainViewBtn;
}

- (UIButton *)foundViewBtn {
    
    if (!_foundViewBtn) {
        _foundViewBtn = [UIHelper commomButtonWithFrame:CGRectZero
                                                  title:@"发现"
                                             titleColor:[UIColor lightGrayColor]
                                              titleFont:[UIFont systemFontOfSize:16.0f]
                                          selectedImage:nil
                                                  image:nil];
    }
    return _foundViewBtn;
}

- (UIButton *)recoverBtn {
    
    if (!_recoverBtn) {
        _recoverBtn = [UIButton new];
        [_recoverBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_recoverBtn addTarget:self action:@selector(recoverBtnDidTap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recoverBtn;
}

- (UIImageView *)lineImageView {
    
    if (!_lineImageView) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = [UIColor blackColor];
        _lineImageView.alpha = 0.2;
    }
    return _lineImageView;
}

- (UIImageView *)userLogoImageView {
    
    if (!_userLogoImageView) {
        _userLogoImageView = [UIImageView new];
    }
    return _userLogoImageView;
}

- (UILabel *)userLoginState {
    
    if (!_userLoginState) {
        _userLoginState = [UILabel new];
        [_userLoginState setFont:[UIFont systemFontOfSize:18.0f]];
        _userLoginState.text = @"";
    }
    return _userLoginState;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.choiceAddressBtn.frame = CGRectMake(35, 50, 180, 40);
    
    self.mainViewBtn.left = self.choiceAddressBtn.left;
    self.mainViewBtn.top = self.choiceAddressBtn.bottom + 40;
    self.mainViewBtn.size = self.choiceAddressBtn.size;
    
    self.foundViewBtn.left = self.mainViewBtn.left;
    self.foundViewBtn.top = self.mainViewBtn.bottom + 10;
    self.foundViewBtn.size = self.mainViewBtn.size;
 
    self.lineImageView.top = self.foundViewBtn.bottom + 40;
    self.lineImageView.left = 25;
    self.lineImageView.width = self.choiceAddressBtn.width + 20;
    self.lineImageView.height = 1.0f;
    
    self.userLogoImageView.left = self.choiceAddressBtn.left;

}

- (void)choiceAddress {
    if ([self.hideViewDelegate respondsToSelector:@selector(choiceAddressBtnDidTapWithButton:)]) {
        [self.hideViewDelegate choiceAddressBtnDidTapWithButton:self.choiceAddressBtn];
    }
}

- (void)recoverBtnDidTap {
    
    
}

@end
