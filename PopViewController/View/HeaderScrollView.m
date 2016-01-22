//
//  HeaderScrollView.m
//  PopViewController
//
//  Created by onwer on 15/12/29.
//  Copyright © 2015年 onwer. All rights reserved.
//

#import "HeaderScrollView.h"
#import "UIView+Category.h"
#import "UIImageView+WebCache.h"

@interface HeaderScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UIPageControl *pageView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HeaderScrollView

+ (instancetype)scrollHeadViewWithImages:(NSArray *)images {
    
    HeaderScrollView *headerView = [HeaderScrollView new];
    headerView.imageArray = images;
    return headerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        [self startTimer];
    }
    return self;
}

- (UIPageControl *)pageView {
    
    if (!_pageView) {
        _pageView = [UIPageControl new];
        _pageView.hidesForSinglePage = YES;
    }
    return _pageView;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat y = self.height - 25;
    CGFloat w = self.width;
    CGFloat h = 25;
    self.pageView.frame = CGRectMake(x, y, w, h);
}

- (void)didMoveToSuperview {
    
    [self.superview addSubview:self.pageView];
    [self stopTimer];
    [self SD_SetImageView];
}

- (void)SD_SetImageView {
    
    NSInteger count = self.imageArray.count;
    int i = 0;
    for (NSString *urlStr in self.imageArray) {
        //获取网络请求路径
        NSURL *url = [NSURL URLWithString:urlStr];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        imageV.contentMode = UIViewContentModeScaleToFill;
        [imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ImageLodingFailed_6P"]];
        
        CGFloat w = self.bounds.size.width;
        CGFloat h = self.bounds.size.height;
        imageV.frame = CGRectMake(i * w, 0, w, h);
        
        [self insertSubview:imageV atIndex:i];
        i++;
    }
    
    if (count <= 1) return;
    
    self.pageView.numberOfPages = count;
    self.contentSize = CGSizeMake(count * self.bounds.size.width, 0);
}

//监听scrollView滚动，改变pageView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger count = self.imageArray.count;
    if (count > 1) {
        NSInteger currentIndex = floor((scrollView.contentOffset.x - scrollView.width / 2) / scrollView.width) + 1;
        self.pageView.currentPage = currentIndex - 1;
        if(currentIndex == 0){
            self.pageView.currentPage = count - 1;
        }else if(currentIndex == count + 1){
            self.pageView.currentPage = 0;
        }
        if (scrollView.contentOffset.x <= 0) {
            [self scrollToIndex:count animated:NO];
        } else if (scrollView.contentOffset.x >= scrollView.width * (count + 1)) {
            [self scrollToIndex:1 animated:NO];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)startTimer {
    
    NSInteger count = self.imageArray.count;
    if(!_timer && count > 1) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(automaticallyRound) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer {
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)automaticallyRound {
    if (self.imageArray.count > 1) {
        [self scrollToIndex:self.pageView.currentPage + 2 animated:YES];
    }
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    [self setContentOffset:CGPointMake(index * self.width, 0) animated:animated];
}

@end
