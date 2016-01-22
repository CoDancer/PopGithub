
//
//  DrawerViewController.m
//  PopViewController
//
//  Created by onwer on 15/12/28.
//  Copyright © 2015年 onwer. All rights reserved.
//

#define GlobalColor(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//抽屉顶部距离 底部一样
#define ScaleTopMargin 35
//app的高度
#define AppWidth ([UIScreen mainScreen].bounds.size.width)
//app的宽度
#define AppHeight ([UIScreen mainScreen].bounds.size.height)
//抽屉拉出来右边剩余比例
#define ZoomScaleRight 0.14

//推荐cell的高度
#define RnmdCellHeight 210.0
//推荐headView的高度
#define RnmdHeadViewHeight 60.0
//背景的灰色
#define BackgroundGrayColor GlobalColor(51, 52, 53)

#import "DrawerViewController.h"
#import "UIView+Category.h"
#import "PickerView.h"

@interface DrawerViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, strong) UIView *customNaviView;
@property (nonatomic, strong) UIButton *recoverBtn;
@property (nonatomic, assign) BOOL weatherShowHiddenView;
@property (nonatomic, strong) UITableView *leftMainTableView;
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation DrawerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.currentView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)configView {
    
    [self addCustomNaviView];
    [self addCurrentBodyView];
}

- (UIView *)currentView {
    
    if (!_currentView) {
        _currentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _currentView.backgroundColor = [UIColor whiteColor];
        
    }
    return _currentView;
}

- (UITableView *)leftMainTableView {
    
    if (!_leftMainTableView) {
        _leftMainTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _leftMainTableView.top = 64;
        _leftMainTableView.height = AppHeight - 64;
        _leftMainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _leftMainTableView.backgroundColor = [UIColor colorWithWhite:0.953 alpha:1.000];
        _leftMainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftMainTableView.delegate = self;
        _leftMainTableView.dataSource = self;
    }
    return _leftMainTableView;
}

- (UIImageView *)rightImageView {
    
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _rightImageView.top = 64;
        _rightImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _rightImageView;
}

- (void)addCustomNaviView {
    
    [self.currentView addSubview:self.customNaviView];
}

- (UIView *)customNaviView {
    
    if (!_customNaviView) {
        
        _customNaviView = [self getCustomNaviView];
        UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"标题一",@"标题二"]];
        segmentControl.tintColor = [UIColor colorWithRed:0.780 green:0.905 blue:0.991 alpha:0.670];
        segmentControl.width = self.view.width * 0.5;
        segmentControl.height = 30.0f;
        
        NSMutableDictionary *textAttribute = [NSMutableDictionary dictionary];
        textAttribute[NSFontAttributeName] = [UIFont boldSystemFontOfSize:16.0f];
        textAttribute[NSForegroundColorAttributeName] = [UIColor whiteColor];
        [segmentControl setTitleTextAttributes:textAttribute forState:UIControlStateNormal];
        [segmentControl setTitleTextAttributes:textAttribute forState:UIControlStateSelected];
        segmentControl.selectedSegmentIndex = 0;
        [segmentControl addTarget:self action:@selector(segmentControlDidTap:) forControlEvents:UIControlEventValueChanged];
        
        segmentControl.centerX = self.view.centerX;
        segmentControl.centerY = 42;
        
        [_customNaviView addSubview:segmentControl];
    }
    return _customNaviView;
}

- (void)addCurrentBodyView {
    [self.currentView addSubview:self.leftMainTableView];
}

- (void)showDrawerView {
    
    if (!self.weatherShowHiddenView) {
        //缩放比例
        CGFloat zoomScale = (AppHeight - 64  - ScaleTopMargin * 2) / (AppHeight);
        //X移动距离
        CGFloat moveX = AppWidth - AppWidth * ZoomScaleRight;
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:0 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeScale(zoomScale, zoomScale);
            self.currentView.transform = CGAffineTransformTranslate(transform, moveX, -32);
            self.weatherShowHiddenView = YES;
            [self addRecoverBtnOnCurrentView];
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)addRecoverBtnOnCurrentView {
    
    self.recoverBtn = [UIButton new];
    [self.recoverBtn setBackgroundColor:[UIColor clearColor]];
    self.recoverBtn.frame = self.currentView.bounds;
    [self.recoverBtn addTarget:self action:@selector(recoverCurrentView) forControlEvents:UIControlEventTouchUpInside];
    [self.currentView addSubview:self.recoverBtn];
}

- (void)recoverCurrentView {
    
    if (self.weatherShowHiddenView) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:0 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
            self.currentView.transform = CGAffineTransformTranslate(transform, 0, 0);
            self.weatherShowHiddenView = NO;
        } completion:^(BOOL finished) {
        }];
    }
    if (self.recoverBtn) {
        [self.recoverBtn removeFromSuperview];
    }
}

- (void)segmentControlDidTap:(UISegmentedControl *)segmentView {
    if (segmentView.selectedSegmentIndex == 0) {
        [self.currentView addSubview:self.leftMainTableView];
        [self.rightImageView removeFromSuperview];
    }else {
        [self.currentView addSubview:self.rightImageView];
        [self.leftMainTableView removeFromSuperview];
    }
}

- (void)researchRecommend {
    
}

- (void)choiceAddressBtnDidTapWithButton:(UIButton *)button {
    NSLog(@"Ok");
    [PickerView showPickerViewWithAddressBlock:^(NSString *addressInfo) {
        [button setTitle:addressInfo forState:UIControlStateNormal];
        button.selected = YES;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.0f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor lightGrayColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    return cell;
}



@end
