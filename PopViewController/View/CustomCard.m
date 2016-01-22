//
//  CustomCard.m
//  PopViewController
//
//  Created by onwer on 16/1/14.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "CustomCard.h"
#import "UIView+Category.h"

@interface CustomCard()

@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation CustomCard

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _image = image;
        [self setup];
        [self addSubview:self.cardImageView];
        
        [self addPanGes];
    }
    return self;
}

- (void)setup {
    
    self.cardImageView = [UIImageView new];
    self.cardImageView.left = 5;
    self.cardImageView.top = 5;
    self.cardImageView.width = self.width - 5*2;
    self.cardImageView.height = self.height - 5*2;
    self.cardImageView.image = self.image;
    self.cardImageView.contentMode = UIViewContentModeScaleToFill;
}

- (void)addPanGes {
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cardImageViewDidPan:)];
    [self.cardImageView addGestureRecognizer:panGes];
}

- (void)cardImageViewDidPan:(UIPanGestureRecognizer *)panGes {
    
    
}


@end
