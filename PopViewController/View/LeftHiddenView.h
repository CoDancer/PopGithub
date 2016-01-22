//
//  LeftHiddenView.h
//  PopViewController
//
//  Created by onwer on 15/12/28.
//  Copyright © 2015年 onwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftHiddenViewDelegate <NSObject>

- (void)choiceAddressBtnDidTapWithButton:(UIButton *)button;
- (void)mainViewBtnDidTapWithButton:(UIButton *)button;
- (void)foundViewBtnDidTapWithButton:(UIButton *)button;

@end

@interface LeftHiddenView : UIView

@property (nonatomic, weak) id<LeftHiddenViewDelegate> hideViewDelegate;

@end
