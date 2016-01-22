//
//  DynamicCellVC.m
//  PopViewController
//
//  Created by onwer on 15/12/22.
//  Copyright © 2015年 onwer. All rights reserved.
//

#import "DynamicCellVC.h"
#import "UIView+Category.h"
#import "CustomCollectionCell.h"
#import "NewViewController.h"

@interface DynamicCellVC ()<UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) CGFloat collectionViewY;

@end

@implementation DynamicCellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YALChatDemoList" ofType:@"plist"]];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.369 green:0.357 blue:0.604 alpha:1.000];
    self.title = @"dynamicCell";
    self.collectionViewY = 0;
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height) collectionViewLayout:flowLayout];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.369 green:0.357 blue:0.604 alpha:1.000];
    [self.collectionView registerClass:[CustomCollectionCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionBottom];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.collectionView performBatchUpdates:nil completion:nil];
    }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - Private

- (void)prepareVisibleCellsForAnimationWithRow:(NSInteger )row andCell:(CustomCollectionCell *)cell{

    cell.frame = CGRectMake(-CGRectGetWidth(cell.bounds), cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
    cell.alpha = 0.f;

}

- (void)animateVisibleCell:(CustomCollectionCell *)cell withRow:(NSInteger)row {

    cell.alpha = 1.f;
    [UIView animateWithDuration:0.25 delay:0.2 *row usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:0 animations:^{
        cell.frame = CGRectMake(0.f, cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
    } completion:^(BOOL finished) {
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dictionary = self.dataArray[indexPath.row];
    cell.model = dictionary;
    if (collectionView.contentSize.height - kScreen_Height > collectionView.contentOffset.y ||
        collectionView.contentOffset.y < 0) {
        if (collectionView.contentOffset.y == 0) {
            [self prepareVisibleCellsForAnimationWithRow:indexPath.row andCell:cell];
            [self animateVisibleCell:cell withRow:indexPath.row];
        }else {
            [self prepareVisibleCellsForAnimationWithRow:1 andCell:cell];
            [self animateVisibleCell:cell withRow:1];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NewViewController *VC = [NewViewController new];
    VC.weatherTapInCell = YES;
    [self presentViewController:VC animated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(CGRectGetWidth(self.view.bounds), 60.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
