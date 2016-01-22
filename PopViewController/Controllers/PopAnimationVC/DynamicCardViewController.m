//
//  DynamicCardViewController.m
//  PopViewController
//
//  Created by onwer on 16/1/14.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "DynamicCardViewController.h"
#import "CustomCard.h"
#import "POP.h"
#import "UIView+Category.h"
#import "DynamicCardsView.h"


@interface DynamicCardViewController()

@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) NSArray *allImageArr;



@property (nonatomic, assign) NSInteger subImageCount;

@property (nonatomic, strong) DynamicCardsView *cardView;

@end

@implementation DynamicCardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"Cards";
    self.subImageCount = 3;
    [self.view addSubview:self.cardView];
}

- (NSArray *)imageArr {
    
    if (!_imageArr) {
        NSMutableArray *subImage = [NSMutableArray array];
        for (int i = 0; i < self.subImageCount; i++) {
            [subImage addObject:self.allImageArr[i]];
        }
        self.imageArr = [subImage copy];
    }
    return _imageArr;
}

- (NSArray *)allImageArr {
    
    if (!_allImageArr) {
        _allImageArr = @[@"meishi1.jpg",@"meishi2.jpg",@"meishi3.jpg",@"boat.jpg",@"boat.jpg"];
    }
    return _allImageArr;
}

- (DynamicCardsView *)cardView {
    
    if (!_cardView) {
        CGRect cardViewFrame = self.view.bounds;
        _cardView = [[DynamicCardsView alloc] initWithFrame:cardViewFrame subImageArray:self.imageArr allImageArr:self.allImageArr];
    }
    return _cardView;
}


@end
