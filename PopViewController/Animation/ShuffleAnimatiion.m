//
//  ShuffleAnimatiion.m
//  PopViewController
//
//  Created by onwer on 16/1/4.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "ShuffleAnimatiion.h"

@implementation ShuffleAnimatiion

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromSnapShot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
    fromSnapShot.frame = fromViewController.view.frame;
    [containerView insertSubview:fromSnapShot aboveSubview:fromViewController.view];
    [fromViewController.view removeFromSuperview];
    
    toViewController.view.frame = fromSnapShot.frame;
    [containerView insertSubview:toViewController.view belowSubview:fromSnapShot];
    
    CGFloat width = floorf(fromSnapShot.frame.size.width/2.0) + 5.0;
    
    [UIView animateKeyframesWithDuration:1.5 delay:0.0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.2 animations:^{
            CATransform3D fromAni = CATransform3DIdentity;
            fromAni.m34 = 1.0 / -2000;
            fromAni = CATransform3DTranslate(fromAni, 0, 0, -590);
            fromSnapShot.layer.transform = fromAni;
            
            CATransform3D toAni = CATransform3DIdentity;
            toAni.m34 = 1.0 / -2000;
            toAni = CATransform3DTranslate(toAni, 0, 0, -600);
            toViewController.view.layer.transform = toAni;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.2 animations:^{
            if (self.type == AnimationTypeDismiss) {
                fromSnapShot.layer.transform = CATransform3DTranslate(fromSnapShot.layer.transform,
                                                                      width, 0.0, 0);
                toViewController.view.layer.transform = CATransform3DTranslate(toViewController.view.layer.transform, -width, 0.0, 0.0);
            }
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.2 animations:^{
            fromSnapShot.layer.transform = CATransform3DTranslate(fromSnapShot.layer.transform, 0.0, 0.0, -200);
            toViewController.view.layer.transform = CATransform3DTranslate(toViewController.view.layer.transform, 0, 0, 500);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:0.2 animations:^{
            CATransform3D fromT = fromSnapShot.layer.transform;
            CATransform3D toT = toViewController.view.layer.transform;
            if (self.type == AnimationTypeDismiss) {
                fromT = CATransform3DTranslate(fromT, floorf(-width), 0, 200);
                toT = CATransform3DTranslate(toT, floorf(width * 0.03), 0, 0);
            }
            fromSnapShot.layer.transform = fromT;
            toViewController.view.layer.transform = toT;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.80 relativeDuration:0.20 animations:^{
            toViewController.view.layer.transform = CATransform3DIdentity;
        }];
    } completion:^(BOOL finished) {
        [fromSnapShot removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
