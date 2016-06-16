//
//  CustomOperation.m
//  PopViewController
//
//  Created by onwer on 16/3/16.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "CustomOperation.h"
#import <UIKit/UIKit.h>

@interface CustomOperation()

@property (nonatomic, strong) UIDynamicAnimator *animatior;
@property (nonatomic, strong) UIView *view;

@end

@implementation CustomOperation

- (instancetype)initWithView:(UIView *)view animator:(UIDynamicAnimator *)ani{
    
    self = [super init];
    if (self) {
        _view = view;
        _animatior = ani;
    }
    return self;
}

- (void)start {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[[UIApplication sharedApplication].delegate window] addSubview:self.view];
        [self addAnimation];
    }];
}

- (void)addAnimation {
    
    self.animatior = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.view]];
    gravityBehaviour.magnitude = 100;
    gravityBehaviour.gravityDirection=CGVectorMake(0, 1);
    UICollisionBehavior *collision = [UICollisionBehavior new];
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.view]];
    [itemBehavior setElasticity:0.6];
    [collision addItem:self.view];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animatior addBehavior:gravityBehaviour];
    [self.animatior addBehavior:collision];
    [self.animatior addBehavior:itemBehavior];
}

@end
