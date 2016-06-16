//
//  CustomOperation.h
//  PopViewController
//
//  Created by onwer on 16/3/16.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomOperation : NSOperation

- (instancetype)initWithView:(UIView *)view animator:(UIDynamicAnimator *)ani;

@end
