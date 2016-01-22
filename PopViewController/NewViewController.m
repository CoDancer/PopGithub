//
//  NewViewController.m
//  PopViewController
//
//  Created by onwer on 15/12/21.
//  Copyright © 2015年 onwer. All rights reserved.
//

#import "NewViewController.h"
#import "UIView+Category.h"
#import "ViewController.h"
#import "SDCycleScrollView.h"
#import "DynamicCellVC.h"
#import "SDWebImageManager.h"
#import "Utils.h"
#import "UIImage+Category.h"
#import "NSString+Category.h"
#import "SDImageCache.h"

//绿色主题
#define Color(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define GolbalGreen Color(33, 197, 180)
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenBounds [UIScreen mainScreen].bounds
#define TopViewHeight 200
#define SelectdViewHeight 45
#define HeaderViewHeight 245

@interface NewViewController ()<SDCycleScrollViewDelegate,
                                UIScrollViewDelegate,
                                UITableViewDataSource,
                                UITableViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) SDCycleScrollView *topScrollView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIImageView *IVOnCoverView;
@property (nonatomic, strong) UIButton *buttonOnCoverView;
@property (nonatomic, assign) NSInteger whichPic;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UITableView *bottomTableView;
@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) UIView *ViewOnTopScrollView;
@property (nonatomic, strong) UILabel *titleLabel;
/** 记录scrollView上次偏移的Y距离 */
@property (nonatomic, assign) CGFloat scrollY;

@property (nonatomic, strong) UIView *selectedView;

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configView];
}

- (UIView *)topView {
    
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:self.topScrollView.bounds];
        _topView.backgroundColor = [UIColor clearColor];
        [_topView addSubview:self.topScrollView];
        [self.topScrollView.superview addSubview:self.ViewOnTopScrollView];
    }
    return _topView;
}

- (UIView *)naviView {
    
    if (!_naviView) {
        _naviView = [UIView new];
        _naviView.frame = CGRectMake(0, 0, self.view.width, 64);
        _naviView.backgroundColor = GolbalGreen;
        _naviView.alpha = 0.0;
    }
    return _naviView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"test";
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_titleLabel sizeToFit];
        _titleLabel.left = 30;
        _titleLabel.top = 32;
    }
    return _titleLabel;
}

- (NSArray *)imageArray {
    
    if (!_imageArray) {
        _imageArray = @[@"http://img.chengmi.com/cm/3bc2198c-c909-4698-91b2-88e00c5dff2a",
                        @"http://img.chengmi.com/cm/dba3fb4d-b5ef-4218-b976-52cba4538381",
                        @"http://img.chengmi.com/cm/934ad87f-400c-452e-9427-12a03fe9cf6e"];
    }
    return _imageArray;
}

- (UIScrollView *)backgroundScrollView {
    
    if (!_backgroundScrollView) {
        _backgroundScrollView = [UIScrollView new];
        _backgroundScrollView.frame = self.view.bounds;
        _backgroundScrollView.backgroundColor = [UIColor lightGrayColor];
        _backgroundScrollView.pagingEnabled = YES;
        _backgroundScrollView.bounces = NO;
        _backgroundScrollView.showsHorizontalScrollIndicator = NO;
        _backgroundScrollView.delegate = self;
        [_backgroundScrollView setContentSize:CGSizeMake(320, 0)];
    }
    return _backgroundScrollView;
}

- (SDCycleScrollView *)topScrollView {
    
    if (!_topScrollView) {
        _topScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, 200) delegate:self placeholderImage:nil];
        _topScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _topScrollView.currentPageDotColor = GolbalGreen;
        _topScrollView.imageURLStringsGroup = self.imageArray;
    }
    return _topScrollView;
}

- (UIView *)ViewOnTopScrollView {
    if (!_ViewOnTopScrollView) {
        _ViewOnTopScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width * self.imageArray.count, 200)];
        _ViewOnTopScrollView.backgroundColor = GolbalGreen;
        _ViewOnTopScrollView .alpha = 0.0;
    }
    return _ViewOnTopScrollView;
}

- (UITableView *)bottomTableView {
    
    if (!_bottomTableView) {
        _bottomTableView = [UITableView new];
        _bottomTableView.backgroundColor = [UIColor lightGrayColor];
        _bottomTableView.scrollEnabled = YES;
        _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        _bottomTableView.frame = [UIScreen mainScreen].bounds;
        _bottomTableView.contentInset = UIEdgeInsetsMake(self.selectedView.bottom, 0, 0, 0);
    }
    return _bottomTableView;
}

- (UIView *)selectedView {
    
    if (!_selectedView) {
        _selectedView = [UIView new];
        _selectedView.backgroundColor = [UIColor lightGrayColor];
        _selectedView.frame = CGRectMake(0, self.topView.bottom, self.view.width, 45);
    }
    return _selectedView;
}

- (UIView *)coverView {
    
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.view.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewDidTap)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

- (UIImageView *)IVOnCoverView {
    
    if (!_IVOnCoverView) {
        _IVOnCoverView = [UIImageView new];
        _IVOnCoverView.size = CGSizeMake(self.view.width, 200);
    }
    return _IVOnCoverView;
}

- (UIButton *)buttonOnCoverView {
    
    if (!_buttonOnCoverView) {
        _buttonOnCoverView = [UIButton new];
        [_buttonOnCoverView setImage:[UIImage imageNamed:@"gen_download"] forState:UIControlStateNormal];
        [_buttonOnCoverView addTarget:self action:@selector(downloadPicture) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonOnCoverView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configView {
    
    [self addBottomScrollViewToView];
    [self addTopViewInHeaderView];
    [self addNaviViewToView];
    [self addBackButton];
}

- (void)addBackButton {
    UIButton *backBtn = [UIButton new];
    [backBtn setTitle:@"back" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [backBtn setBackgroundColor:[UIColor colorWithRed:0.500 green:0.898 blue:0.400 alpha:1.000]];
    [backBtn sizeToFit];
    backBtn.center = self.view.center;
    [backBtn addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomTableView addSubview:backBtn];
}

- (void)backVC {
    if (!_weatherTapInCell) {
        if (_weatherPush) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            ViewController *vc = [ViewController new];
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            UINavigationController *uinaVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:uinaVC animated:YES completion:nil];
        }
    }else {
        DynamicCellVC *vc = [DynamicCellVC new];
        UINavigationController *uinaVC = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:uinaVC animated:YES completion:nil];
    }
    
}

- (void)addNaviViewToView {
    
    [self.view addSubview:self.naviView];
    [self.view addSubview:self.titleLabel];
}

- (void)addTopViewInHeaderView {
    
    [self.view addSubview:self.topView];
}

- (void)addBottomScrollViewToView {
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView addSubview:self.bottomTableView];
    [self.view addSubview:self.selectedView];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {

    self.whichPic = index;
    [[SDWebImageManager sharedManager] downloadImageWithURL:self.imageArray[index] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.IVOnCoverView.image = image;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
            self.IVOnCoverView.frame = CGRectMake(0, 0, self.view.width, 200);
            self.IVOnCoverView.center = self.view.center;
            self.buttonOnCoverView.size = CGSizeMake(50, 50);
            self.buttonOnCoverView.bottom = self.view.height - 20;
            self.buttonOnCoverView.centerX = self.view.centerX;
            [self.view addSubview:self.coverView];
            [self.view addSubview:self.IVOnCoverView];
            [self.view addSubview:self.buttonOnCoverView];
            self.coverView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)downloadPicture {
    
    [self downloadPictureWithIndex:self.whichPic];
}

- (void)downloadPictureWithIndex:(NSInteger)index {
    
    NSURL *urlOrPath = [NSURL URLWithString:self.imageArray[index]];
    NSString *savePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:urlOrPath.absoluteString];
   // NSString *urlOrPath = [self.imageArray[index] otherImageDownloadPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath isDirectory:nil]) {
        UIImage *image = [UIImage imageWithContentsOfFile:savePath];
        if (image) {
            [image saveToAlbumWithMetadata:nil customAlbumName:@"FabLook" completionBlock:^{
                //[UIHelper showAutoHideHUDforView:self title:@"保存成功" subTitle:nil];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"需要访问您的照片" message:@"请启用照片-设置/隐私/照片" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            } failureBlock:^(NSError *error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"需要访问您的照片" message:@"请启用照片-设置/隐私/照片" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                
            }];
            
        }
    }
}

- (void)coverViewDidTap {
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
        self.coverView.alpha = 0;
        self.buttonOnCoverView.size = CGSizeZero;
        self.IVOnCoverView.frame = CGRectMake(0, 0, self.view.width, 200);
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        [self.IVOnCoverView removeFromSuperview];
        [self.buttonOnCoverView removeFromSuperview];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat moveOffset = offsetY + HeaderViewHeight;
    self.scrollY = offsetY;
    CGFloat naviH = 64;
    
    //NaviView alpha
    CGFloat startF = 0;
    CGFloat alphaScaleShow = (moveOffset + startF) / (TopViewHeight - naviH);
    if (alphaScaleShow >= 0.94) {
        [UIView animateWithDuration:0.04 animations:^{
            self.naviView.alpha = 1;
        }];
    }else {
        self.naviView.alpha = 0;
    }
    self.ViewOnTopScrollView.alpha = alphaScaleShow;
    if (moveOffset > 0) {
        CGRect headRect = self.topView.frame;
        headRect.origin.y = -(offsetY + HeaderViewHeight);
        self.topView.frame = headRect;
    }else {
        self.topView.bottom = TopViewHeight - moveOffset ;
        self.selectedView.height = SelectdViewHeight;
    }

    CGFloat scaleTopView = 1 - (offsetY + HeaderViewHeight) / 100;
    scaleTopView = scaleTopView > 1 ? scaleTopView : 1;
    CGAffineTransform transform = CGAffineTransformMakeScale(scaleTopView, scaleTopView);
    CGFloat ty = (scaleTopView - 1) * TopViewHeight;
    self.topView.transform = CGAffineTransformTranslate(transform, 0, -ty * 0.1);
    
    if (offsetY >= -(naviH + SelectdViewHeight)) {
        self.selectedView.frame = CGRectMake(0, naviH, ScreenWidth, SelectdViewHeight);
    } else {
        self.selectedView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenWidth, SelectdViewHeight);
    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}





@end
