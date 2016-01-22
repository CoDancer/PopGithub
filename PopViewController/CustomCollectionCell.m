//
//  CustomCollectionCell.m
//  PopViewController
//
//  Created by onwer on 15/12/22.
//  Copyright © 2015年 onwer. All rights reserved.
//

#import "CustomCollectionCell.h"
#import "UIView+Category.h"

@interface CustomCollectionCell()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CustomCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        self.backgroundColor = [UIColor colorWithRed:0.439 green:0.433 blue:0.747 alpha:1.000];
    }
    return self;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    }
    return _imageView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.layer.cornerRadius = self.imageView.height/2.0;
    self.imageView.clipsToBounds = YES;
}
- (void)setModel:(NSDictionary *)model {
    _model = model;
    self.imageView.image = [UIImage imageNamed:model[@"imageName"]];
}

@end
