//
//  NewsCollectionViewCell.m
//  PopViewController
//
//  Created by onwer on 15/12/25.
//  Copyright © 2015年 onwer. All rights reserved.
//

#import "NewsCollectionViewCell.h"
#import "UIView+Category.h"

@interface NewsCollectionViewCell()

@property (nonatomic, strong) UIImageView *cellImageView;

@end

@implementation NewsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.cornerRadius = 5.0f;
        self.clipsToBounds = YES;
        [self addSubview:self.cellImageView];
    }
    return self;
}

- (UIImageView *)cellImageView {
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _cellImageView.layer.cornerRadius = 5.0;
        _cellImageView.clipsToBounds = YES;
    }
    return _cellImageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


@end
