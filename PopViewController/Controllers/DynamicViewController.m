//
//  DynamicViewController.m
//  PopViewController
//
//  Created by onwer on 16/3/3.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "DynamicViewController.h"
#import <MapKit/MapKit.h>
#import "CustomOperation.h"
#import "UIView+Category.h"

@interface DynamicViewController ()

@property (nonatomic, strong) NSArray *animatorArr;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    [self.timer fireDate];
}

- (NSArray *)animatorArr {
    
    NSMutableArray *aniArr = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        UIDynamicAnimator *ani = [UIDynamicAnimator new];
        [aniArr addObject:ani];
    }
    if (!_animatorArr) {
        _animatorArr = [aniArr copy];
    }
    return _animatorArr;
}

- (void )getAnimatorWithAni:(UIDynamicAnimator *)ani view:(UIView *)view idx:(NSInteger)i{
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[view]];
    gravityBehaviour.magnitude = 100;
    gravityBehaviour.gravityDirection=CGVectorMake(0, 1);
    UICollisionBehavior *collision = [UICollisionBehavior new];
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
    [itemBehavior setElasticity:0.6];
    [collision addItem:view];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    CGPoint startP;
    CGPoint endP;
    if (i < 3) {
        startP = CGPointMake(0, 440 - 10);
        endP = CGPointMake(320, 440 - 10);
    }else if (i >= 3 && i <=5) {
        startP = CGPointMake(0, 440 - 10 - 60 - 50);
        endP = CGPointMake(320, 440 - 10 - 60 - 50);
    }else if (i > 5 && i < 9) {
        startP = CGPointMake(0, 440 - 10 - (60 + 50)*2);
        endP = CGPointMake(320, 440 - 10 - (60 + 50)*2);
    }
    [collision addBoundaryWithIdentifier:@"line1" fromPoint:startP toPoint:endP];
    [ani addBehavior:gravityBehaviour];
    [ani addBehavior:collision];
    [ani addBehavior:itemBehavior];
}

- (void)getDynamicViewWithIndex:(NSInteger)idx {
    
    UIView *dynamciView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    dynamciView.layer.cornerRadius = 25;
    [self.view addSubview:dynamciView];
    if (idx%3 == 0) {
        dynamciView.left = 160 - 20 - 50*3/2.0;
        dynamciView.backgroundColor = [UIColor colorWithRed:0.500 green:0.724 blue:0.815 alpha:1.000];
    }else if (idx%3 == 1){
        dynamciView.centerX = 160;
        dynamciView.backgroundColor = [UIColor colorWithRed:0.216 green:0.815 blue:0.271 alpha:1.000];
    }else if (idx%3 == 2) {
        dynamciView.left = 160 + 50/2.0 + 20;
        dynamciView.backgroundColor = [UIColor colorWithRed:0.054 green:0.127 blue:0.815 alpha:1.000];
    }
    [self getAnimatorWithAni:self.animatorArr[idx] view:dynamciView idx:idx];
}

- (void)timeChange {
    static int time = 0;
    if (time == 0 || time <= 8) {
        [self getDynamicViewWithIndex:time];
    }
    time ++;
    if (time > 8) {
        time = 0;
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
