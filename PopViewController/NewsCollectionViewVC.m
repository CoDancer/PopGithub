//
//  NewsCollectionViewVC.m
//  PopViewController
//
//  Created by onwer on 15/12/25.
//  Copyright © 2015年 onwer. All rights reserved.
//

#import "NewsCollectionViewVC.h"
#import "NewsCollectionViewCell.h"
#import "UIView+Category.h"
#import "NewViewController.h"

#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define separationWidth 8.0
#define Cell_Width (kScreen_Width - 10 * 2 - separationWidth * 2)/3.0
#define Cell_Height (kScreen_Width - 15 * 2 - separationWidth * 3)/4.0

@interface NewsCollectionViewVC()<UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) CGFloat collectionViewHeight;

@end

@implementation NewsCollectionViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"NewsView";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configView];
}

- (void)configView {
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[NewsCollectionViewCell class] forCellWithReuseIdentifier:@"NewsCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (CGFloat)collectionViewHeight {
    if (!_collectionViewHeight) {
        CGFloat collectionViewHeight = 85 * 4 + 8 * 3 + 15;
        if (collectionViewHeight <= kScreen_Height) {
            _collectionViewHeight = collectionViewHeight;
        }else {
            _collectionViewHeight = kScreen_Height;
        }
    }
    return _collectionViewHeight;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumInteritemSpacing = 8.0;
        flowLayout.minimumLineSpacing = 8.0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 64 + 15, kScreen_Width - 10*2, self.collectionViewHeight) collectionViewLayout:flowLayout];
        _collectionView.centerY = kScreen_Height/2.0 + 16;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (void)prepareVisibleCellsForAnimationWithRow:(NSInteger )row andCell:(NewsCollectionViewCell *)cell{
    cell.frame = CGRectMake(cell.centerX, cell.centerY, 0, 0);
    cell.alpha = 0.f;
}

- (void)animateVisibleCell:(NewsCollectionViewCell *)cell withRow:(NSInteger)row cellFrame:(CGRect)cellFrame {
    cell.alpha = 1.f;
    [UIView animateWithDuration:0.25f
                          delay:0.2 * row
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         cell.frame = cellFrame;
                     }
                     completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsCell" forIndexPath:indexPath];
    NewsCollectionViewCell *cell2 = [NewsCollectionViewCell new];
    cell2 = cell;
    CGRect cellFrame = cell.frame;
    [self prepareVisibleCellsForAnimationWithRow:indexPath.row andCell:cell];
    [self animateVisibleCell:cell2 withRow:indexPath.row cellFrame:cellFrame];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"123");
    NewsCollectionViewCell *cell = (NewsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.25f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         cell.frame = CGRectMake(cell.centerX, cell.centerY, 0, 0);
                     }
                     completion:^(BOOL finished) {
                         [self.navigationController pushViewController:[NewViewController new] animated:YES];
                     }];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90, 85);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

@end
