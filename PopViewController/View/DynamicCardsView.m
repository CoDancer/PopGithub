//
//  DynamicCardsView.m
//  PopViewController
//
//  Created by onwer on 16/1/18.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "DynamicCardsView.h"
#import "CustomCard.h"
#import "UIView+Category.h"
#import "POP.h"

@interface DynamicCardsView()

@property (nonatomic, strong) NSArray *subImageArray;
@property (nonatomic, strong) NSArray *allImageArray;
@property (nonatomic, strong) NSArray *cardsImg;
@property (nonatomic, assign) CGFloat initialLocation;
@property (nonatomic, assign) BOOL isSpreadCards;
@property (nonatomic, assign) BOOL isTapCardView;

@property (nonatomic, assign) NSInteger subImageCount;

@end

@implementation DynamicCardsView

- (instancetype)initWithFrame:(CGRect)frame
                subImageArray:(NSArray *)subArr
                  allImageArr:(NSArray *)allArr {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.subImageArray = subArr;
        self.allImageArray = allArr;
        
        self.subImageCount = subArr.count;
        [self getCustomCards];
        [self makeCards3D];
    }
    return self;
}

- (NSArray *)cardsImg {
    
    if (!_cardsImg) {
        _cardsImg = [NSArray array];
    }
    return _cardsImg;
}

- (NSArray *)subImageArray {
    
    if (!_subImageArray) {
        _subImageArray = [NSArray array];
    }
    return _subImageArray;
}

- (NSArray *)allImageArray {
    
    if (!_allImageArray) {
        _allImageArray = [NSArray array];
    }
    return _allImageArray;
}

- (void)getCustomCards {
    
    NSMutableArray *cardsImg = [NSMutableArray array];
    [self.subImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CustomCard *card = [[CustomCard alloc] initWithFrame:CGRectMake(0, 0, 250, 200) image:[UIImage imageNamed:obj]];
        card.tag = 100 + idx;
        [self addSubview:card];
        card.center = self.center;
        [cardsImg addObject:card];
    }];
    self.cardsImg = [cardsImg copy];
}

- (void)makeCards3D {
    
    [self.cardsImg enumerateObjectsUsingBlock:^(CustomCard *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat cardScale = 0.1*idx + 0.8;
        obj.transform = CGAffineTransformScale(obj.transform, cardScale, cardScale);
        
        CGFloat cardTranslate = 0;
        if (idx == 0) {
            cardTranslate = 70;
        }else {
            cardTranslate = (self.cardsImg.count - idx) * 22;
        }
        if (idx == self.cardsImg.count - 1) {
            [self addGesOnTopCardView:obj];
        }
        obj.transform = CGAffineTransformTranslate(obj.transform, 0, cardTranslate);
    }];
}

- (void)addGesOnTopCardView:(CustomCard *)cardView {
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(cardViewDidPan:)];
    [cardView addGestureRecognizer:panGes];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(cardViewDidTap:)];
    [cardView addGestureRecognizer:tapGes];
}

- (void)cardViewDidPan:(UIPanGestureRecognizer *)panGes {
    
    CGPoint location = [panGes locationInView:panGes.view];
    CGPoint velocity = [panGes velocityInView:panGes.view];
    CGPoint translate = [panGes translationInView:panGes.view];
    if (panGes.state == UIGestureRecognizerStateBegan) {
        self.initialLocation = location.x;
    }
    
    if (translate.x < 0 && panGes.view.centerX == self.centerX) {
        [self springAnimationToVale:CGPointMake(0, self.centerY)
                           withView:panGes.view velocity:velocity];
        [self bottomCardsViewSpreadAnimationwithVelocity:velocity];
        self.isSpreadCards = YES;
        
    }else if (translate.x >= 0) {
        if (panGes.view.centerX == 0) {
            [self.cardsImg enumerateObjectsUsingBlock:^(CustomCard *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self eachCardViewDidRotate:obj rotate:0];
            }];
            if (self.isTapCardView) {
                [self makeCards3D];
                self.isTapCardView = NO;
            }
            [self springAnimationToVale:CGPointMake(self.centerX, self.centerY)
                               withView:panGes.view velocity:velocity];
            [self bottomCardsViewShrinkAnimationwithVelocity:velocity];
            self.isSpreadCards = NO;
        }else if (panGes.view.centerX == self.centerX) {
            [self dismissTopCardView:CGPointMake(self.width + panGes.view.width/2.0,
                                                 self.centerY)
                            withView:panGes.view];
            [self bottomCardsViewRecoverScaleWithVelocity:velocity complete:^(BOOL finished){
            }];
        }
    }
}

- (void)springAnimationToVale:(CGPoint)point withView:(UIView *)view velocity:(CGPoint)velocity{
    
    POPSpringAnimation *swipeAni = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    swipeAni.velocity = [NSValue valueWithCGPoint:velocity];
    swipeAni.toValue = [NSValue valueWithCGPoint:point];
    [view.layer pop_addAnimation:swipeAni forKey:@"swipeAnimtion"];
}

- (void)dismissTopCardView:(CGPoint)point withView:(UIView *)view {
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8
          initialSpringVelocity:10 options:0 animations:^{
              view.center = point;
          } completion:^(BOOL finished) {
              [view removeFromSuperview];
              [self adjustImageArr];
              [self addCardViewOnBottomest];
          }];
}

- (void)bottomCardsViewSpreadAnimationwithVelocity:(CGPoint)velocity{
    
    [self.cardsImg enumerateObjectsUsingBlock:^(CustomCard *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 1) {
            [self springAnimationToVale:CGPointMake(self.centerX - 20,self.centerY)
                               withView:obj velocity:velocity];
        }else if (idx == 0) {
            [self springAnimationToVale:CGPointMake(self.width - 40,self.centerY)
                               withView:obj velocity:velocity];
        }
    }];
}

- (void)bottomCardsViewRecoverScaleWithVelocity:(CGPoint)velocity complete:(void (^)(BOOL finished))completion {
    
    [self.cardsImg enumerateObjectsUsingBlock:^(CustomCard *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 1) {
            [self recoverScaleWithScale:1.0/0.9 translate:-20 cardView:obj];
        }else if (idx == 0) {
            [self recoverScaleWithScale:1.0/0.9 translate:-20 cardView:obj];
        }
    }];
}

- (void)recoverScaleWithScale:(CGFloat)scale translate:(CGFloat)translate cardView:(UIView *)view {
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8
          initialSpringVelocity:10 options:0 animations:^{
              view.transform = CGAffineTransformTranslate(view.transform, 0, translate);
              view.transform = CGAffineTransformScale(view.transform, scale, scale);
          } completion:nil];
    
}

- (void)bottomCardsViewShrinkAnimationwithVelocity:(CGPoint)velocity{
    
    [self.cardsImg enumerateObjectsUsingBlock:^(CustomCard *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 1) {
            [self springAnimationToVale:CGPointMake(self.centerX,
                                                    self.centerY)
                               withView:obj velocity:velocity];
        }else if (idx == 0) {
            [self springAnimationToVale:CGPointMake(self.centerX,
                                                    self.centerY)
                               withView:obj velocity:velocity];
        }
    }];
}

- (void)cardViewDidTap:(UITapGestureRecognizer *)tapGes {
    
    if (!self.isSpreadCards) {
        return;
    }
    self.isTapCardView = YES;
    [self.cardsImg enumerateObjectsUsingBlock:^(CustomCard *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self eachCardViewDidRotate:obj rotate:-M_PI_4];
    }];
    
}

- (void)eachCardViewDidRotate:(CustomCard *)cardView rotate:(CGFloat)angleValue{
    
    POPSpringAnimation *rotateAni = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotationY];
    [cardView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    rotateAni.springBounciness = 18.0f;
    rotateAni.dynamicsMass = 2.0f;
    rotateAni.dynamicsTension = 200;
    rotateAni.toValue = @(angleValue);
    [cardView.layer pop_addAnimation:rotateAni forKey:@"rotationAnimation"];
}

- (void)adjustImageArr {
    
    id addObj = [self.allImageArray objectAtIndex:self.subImageCount];
    self.subImageCount = self.subImageCount + 1;
    if (self.subImageCount == self.allImageArray.count) {
        self.subImageCount = 0;
    }
    NSMutableArray *adjustArr = [self.subImageArray mutableCopy];
    [adjustArr lastObject];
    [adjustArr insertObject:addObj atIndex:0];
    self.subImageArray = [adjustArr mutableCopy];
}

- (void)addCardViewOnBottomest {
    
    NSMutableArray *adjustCards = [self.cardsImg mutableCopy];
    [adjustCards removeLastObject];
    [self.subImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            CustomCard *bottomCard = [adjustCards firstObject];
            CustomCard *card = [[CustomCard alloc] initWithFrame:CGRectMake(0, 0, 250, 200) image:[UIImage imageNamed:obj]];
            [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8
                  initialSpringVelocity:10 options:0 animations:^{
                      card.center = self.center;
                      [self recoverScaleWithScale:0.8 translate:55 cardView:card];
                  } completion:^(BOOL finished) {
                      [self insertSubview:card belowSubview:bottomCard];
                  }];
            [adjustCards insertObject:card atIndex:0];
        }else if (idx == self.subImageArray.count - 1) {
            CustomCard *topCard = [adjustCards lastObject];
            [self addGesOnTopCardView:topCard];
        }
        self.cardsImg = [adjustCards copy];
    }];
}

@end
