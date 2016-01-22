//
//  BookListViewController.m
//  PopViewController
//
//  Created by onwer on 16/1/11.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "BookListViewController.h"
#import "UIView+Category.h"
#import "CustomBookCell.h"
#import "BookListModel.h"
#import "CustomAnimationVC.h"
#import "ModalAnimaion.h"

@interface BookListViewController()<UITableViewDataSource,
                                    UITableViewDelegate,
                                    CustromBookCellDelegate>

@property (nonatomic, strong) UITableView *bookTableView;
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong) NSMutableArray *eachGroupModel;
@property (nonatomic, strong) ModalAnimaion *modalAnimation;

@end

@implementation BookListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"BookList";
    [self.bookTableView registerClass:[CustomBookCell class] forCellReuseIdentifier:@"BookCell"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self fetchLocalData];
    [self configView];
}

- (void)configView {
    
    [self.view addSubview:self.bookTableView];
}

- (UITableView *)bookTableView {
    
    if (!_bookTableView) {
        _bookTableView = [[UITableView alloc]
                          initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)
                          style:UITableViewStylePlain];
        [_bookTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _bookTableView.backgroundColor = [UIColor lightGrayColor];
        _bookTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _bookTableView.delegate = self;
        _bookTableView.dataSource = self;
    }
    return _bookTableView;
}

- (NSArray *)dataArray {
    
    if (!_modelArray) {
        _modelArray = [NSArray array];
    }
    return _modelArray;
}

- (ModalAnimaion *)modalAnimation {
    
    if (!_modalAnimation) {
        _modalAnimation = [ModalAnimaion new];
    }
    return _modalAnimation;
}

- (void)fetchLocalData {
    
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"foundData" ofType:@"plist"]];
    if (dataArray.count != 0) {
        NSMutableArray *models = [NSMutableArray array];
        [dataArray enumerateObjectsUsingBlock:^(NSDictionary *obj,
                                                     NSUInteger idx,
                                                     BOOL * _Nonnull stop) {
            BookListModel *bookListModel = [BookListModel bookListModelWithDict:obj];
            if (idx % 3 == 0) {
                self.eachGroupModel = [NSMutableArray new];
                [models addObject:self.eachGroupModel];
            }
            [self.eachGroupModel addObject:bookListModel];
        }];
        self.modelArray = [models copy];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.modelArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell"];
    cell.bookModels = self.modelArray[indexPath.row];
    cell.bookDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200;
}

- (void)bookViewDidTapWithBookModel:(BookListModel *)bookModel bookView:(BookView *)bookView{
    
    NSLog(@"%@",bookModel);
    CustomAnimationVC *vc = [CustomAnimationVC new];
    vc.bookModel = bookModel;
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    self.modalAnimation.type = AnimationTypePresent;
    return self.modalAnimation;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.modalAnimation.type = AnimationTypeDismiss;
    return self.modalAnimation;
}

@end
