//
//  ViewController.m
//  PopViewController
//
//  Created by onwer on 15/12/21.
//  Copyright © 2015年 onwer. All rights reserved.
//

#import "ViewController.h"
#import "NewViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIView+Category.h"
#import "UIButton+Category.h"
#import "DynamicCellVC.h"
#import "PickerView.h"
#import "NewsCollectionViewVC.h"
#import "DrawerViewController.h"
#import "CustomAnimationVC.h"
#import "ModalAnimaion.h"
#import "Transform2DOr3DVC.h"
#import "ShuffleAnimatiion.h"
#import "FoldViewController.h"
#import "InternetDataViewController.h"
#import "BookListViewController.h"
#import "ButtonShakeAniVC.h"
#import "DynamicCardViewController.h"
#import "Cards3DViewController.h"
#import "DynamicViewController.h"
#import "DynamicLabelVC.h"
#import "VoiceVCViewController.h"

@interface ViewController ()
{
    ModalAnimaion *modalAnimation;
}
@property (nonatomic, strong) ShuffleAnimatiion *shuffleAnimationController;
@property (nonatomic, strong) NSString *selectedAddress;

@end

@implementation ViewController

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)viewDidLoad {
    self.title = @"TEST";
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    [self configView];
}

- (void)configView {
    
    [self addPushButton];
    [self addPresentVCButton];
    [self addTableViewBtn];
    [self addPickerViewBtn];
    [self addFieldView];
    [self addNewsCollectionViewBtn];
    [self addDrawerViewBtn];
    [self addAnimationBtn];
    [self addTransform2DOr3DBtn];
    [self addFoldViewBtn];
    [self addGetInternetDataBtn];
    [self enterBookListBtn];
    [self popAniBtn];
    [self dynamicCardsBtn];
    [self CardsOf3DBtn];
    [self dynamic];
    [self dynamicLabel];
    [self dynamicVoice];
}

- (void )addPushButton {

    UIButton *pushBtn = [UIButton getButtonWithTitle:@"push" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.500 green:0.108 blue:0.400 alpha:1.000]];
    pushBtn.tag = 100;
    pushBtn.left = 10;
    pushBtn.top = 10 + 64;
    [pushBtn addTarget:self action:@selector(pushNewVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushBtn];
}

- (void)pushNewVC {
    NewViewController *VC = [NewViewController new];
    VC.title = @"pushedVC";
    VC.weatherPush = YES;
    [self.navigationController pushViewController:VC animated:YES];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}

- (void)addPresentVCButton {
    UIButton *presentBtn = [UIButton getButtonWithTitle:@"presentVC" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.500 green:0.724 blue:0.815 alpha:1.000]];
    presentBtn.tag = 101;
    UIButton *pushBtn = [self.view viewWithTag:100];
    presentBtn.left = pushBtn.right + 10;
    presentBtn.top = 10 + 64;
    [presentBtn addTarget:self action:@selector(presentVCTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:presentBtn];
}

- (void)presentVCTap {
    NewViewController *VC = [NewViewController new];
    VC.weatherPush = NO;
    VC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:VC animated:YES completion:nil];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}

- (void)addTableViewBtn {
    UIButton *cellBtn = [UIButton getButtonWithTitle:@"dynamicCell" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.500 green:0.724 blue:0.815 alpha:1.000]];
    cellBtn.tag = 102;
    UIButton *presentBtn = [self.view viewWithTag:101];
    cellBtn.left = presentBtn.right + 10;
    cellBtn.top = 10 + 64;
    [cellBtn addTarget:self action:@selector(cellBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cellBtn];
}

- (void)cellBtnTap {
    DynamicCellVC *vc = [DynamicCellVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addFieldView {
    UITextField *field = [UITextField new];
    field.tag = 104;
    field.userInteractionEnabled = NO;
    [self.view addSubview:field];
    [field setFont:[UIFont systemFontOfSize:15.0f]];
    field.placeholder = @"显示信息";
    field.adjustsFontSizeToFitWidth = YES;
    [field sizeToFit];
    [field setBackgroundColor:[UIColor colorWithRed:0.911 green:0.407 blue:0.815 alpha:1.000]];
    field.textColor = [UIColor whiteColor];
    field.center = self.view.center;
}

- (void)addPickerViewBtn {
    UIButton *pickerBtn = [UIButton getButtonWithTitle:@"pickerView" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.500 green:0.724 blue:0.157 alpha:1.000]];
    pickerBtn.tag = 103;
    UIButton *cellBtn = [self.view viewWithTag:102];
    pickerBtn.left = cellBtn.right + 10;
    pickerBtn.top = 10 + 64;
    [pickerBtn addTarget:self action:@selector(pickerBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pickerBtn];
}

- (void)pickerBtnTap {
    UITextField *field = [self.view viewWithTag:104];
    field.text = @"地址";
    [PickerView showPickerViewWithAddressBlock:^(NSString *addressInfo) {
        field.text = addressInfo;
        [field sizeToFit];
        field.center = self.view.center;
        field.adjustsFontSizeToFitWidth = YES;
    }];
    [field sizeToFit];
    field.center = self.view.center;
}

- (void)addNewsCollectionViewBtn {
    UIButton *NewsBtn = [UIButton getButtonWithTitle:@"newsViewBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.500 green:0.724 blue:0.157 alpha:1.000]];
    NewsBtn.tag = 105;
    UIButton *pushBtn = [self.view viewWithTag:100];
    NewsBtn.left = 10;
    NewsBtn.top = pushBtn.bottom + 10;
    [NewsBtn addTarget:self action:@selector(newsViewBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:NewsBtn];
}

- (void)newsViewBtnTap {
    [self.navigationController pushViewController:[NewsCollectionViewVC new] animated:YES];
}

- (void)addDrawerViewBtn {
    UIButton *drawerBtn = [UIButton getButtonWithTitle:@"drawerViewBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.500 green:0.724 blue:0.157 alpha:1.000]];
    drawerBtn.tag = 106;
    UIButton *newsBtn = [self.view viewWithTag:105];
    drawerBtn.left = newsBtn.right + 10;
    drawerBtn.top = newsBtn.top;
    [drawerBtn addTarget:self action:@selector(drawerViewBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:drawerBtn];
}

- (void)drawerViewBtnTap {
    [self.navigationController pushViewController:[DrawerViewController new] animated:YES];
}

- (void)addAnimationBtn {
    
    modalAnimation = [[ModalAnimaion alloc] init];
    _shuffleAnimationController = [[ShuffleAnimatiion alloc] init];
    UIButton *animationBtn = [UIButton getButtonWithTitle:@"animationBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.500 green:0.724 blue:0.157 alpha:1.000]];
    animationBtn.tag = 107;
    UIButton *drawerBtn = [self.view viewWithTag:106];
    animationBtn.left = drawerBtn.right + 10;
    animationBtn.top = drawerBtn.top;
    [animationBtn addTarget:self action:@selector(animationBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:animationBtn];
}

- (void)animationBtnTap {
    
    CustomAnimationVC *vc = [CustomAnimationVC new];
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    modalAnimation.type = AnimationTypePresent;
    return modalAnimation;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    modalAnimation.type = AnimationTypeDismiss;
    return modalAnimation;
}

- (void)addTransform2DOr3DBtn {
    
    UIButton *transformBtn = [UIButton getButtonWithTitle:@"TransformBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.161 green:0.724 blue:0.302 alpha:1.000]];
    transformBtn.tag = 108;
    UIButton *newsBtn = [self.view viewWithTag:105];
    transformBtn.top = newsBtn.bottom + 10;
    transformBtn.left = 10;
    [transformBtn addTarget:self action:@selector(transformBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transformBtn];
}

- (void)transformBtnTap {
    
    Transform2DOr3DVC *vc = [Transform2DOr3DVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addFoldViewBtn {
    
    UIButton *foldViewBtn = [UIButton getButtonWithTitle:@"FoldViewBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.198 green:0.495 blue:0.724 alpha:1.000]];
    foldViewBtn.tag = 109;
    UIButton *transformBtn = [self.view viewWithTag:108];
    foldViewBtn.top = transformBtn.top;
    foldViewBtn.left = transformBtn.right + 10;
    [foldViewBtn addTarget:self action:@selector(foldViewBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:foldViewBtn];
}

- (void)foldViewBtnTap {
    
    [self.navigationController pushViewController:[FoldViewController new] animated:YES];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (void)addGetInternetDataBtn {
    
    UIButton *dataBtn = [UIButton getButtonWithTitle:@"InternetData" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.173 green:0.724 blue:0.629 alpha:1.000]];
    dataBtn.tag = 110;
    UIButton *foldViewBtn = [self.view viewWithTag:109];
    dataBtn.top = foldViewBtn.top;
    dataBtn.left = foldViewBtn.right + 10;
    [dataBtn addTarget:self action:@selector(dataBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dataBtn];
}

- (void)dataBtnTap {
    
    [self.navigationController pushViewController:[InternetDataViewController new] animated:YES];
}

- (void)enterBookListBtn {
    
    UIButton *bookListBtn = [UIButton getButtonWithTitle:@"bookList" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.094 green:0.724 blue:0.305 alpha:1.000]];
    bookListBtn.tag = 111;
    UIButton *transform = [self.view viewWithTag:108];
    bookListBtn.top = transform.bottom + 10;
    bookListBtn.left = 10;
    [bookListBtn addTarget:self action:@selector(enterBookListBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bookListBtn];
}

- (void)enterBookListBtnTap {
    
    [self.navigationController pushViewController:[BookListViewController new] animated:YES];
}

- (void)popAniBtn {
    
    UIButton *popAniBtn = [UIButton getButtonWithTitle:@"popAniBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.357 green:0.516 blue:0.724 alpha:1.000]];
    popAniBtn.tag = 112;
    UIButton *bookListBtn = [self.view viewWithTag:111];
    popAniBtn.top = bookListBtn.top;
    popAniBtn.left = bookListBtn.right + 10;
    [popAniBtn addTarget:self action:@selector(popAniBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popAniBtn];
}

- (void)popAniBtnTap {
    
    [self.navigationController pushViewController:[ButtonShakeAniVC new] animated:YES];
}

- (void)dynamicCardsBtn {
    
    UIButton *cardsBtn = [UIButton getButtonWithTitle:@"cardsBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.669 green:0.287 blue:0.724 alpha:1.000]];
    cardsBtn.tag = 113;
    UIButton *popAniBtn = [self.view viewWithTag:112];
    cardsBtn.top = popAniBtn.top;
    cardsBtn.left = popAniBtn.right + 10;
    [cardsBtn addTarget:self action:@selector(cardsBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cardsBtn];
}

- (void)cardsBtnTap {
    
    [self.navigationController pushViewController:[DynamicCardViewController new] animated:YES];
}

- (void)CardsOf3DBtn {
    
    UIButton *cardsBtn = [UIButton getButtonWithTitle:@"cards3DBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.203 green:0.219 blue:0.724 alpha:1.000]];
    cardsBtn.tag = 114;
    UIButton *cardBtn = [self.view viewWithTag:113];
    cardsBtn.top = cardBtn.top;
    cardsBtn.left = cardBtn.right + 10;
    [cardsBtn addTarget:self action:@selector(cards3DBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cardsBtn];
}

- (void)cards3DBtnTap {
    
    Cards3DViewController *vc = [Cards3DViewController new];
    vc.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    [self.navigationController pushViewController:[Cards3DViewController new] animated:YES];
}

- (void)dynamic {
    
    UIButton *cardsBtn = [UIButton getButtonWithTitle:@"dynamic" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.203 green:0.219 blue:0.724 alpha:1.000]];
    cardsBtn.tag = 115;
    UIButton *cardBtn = [self.view viewWithTag:111];
    cardsBtn.top = cardBtn.bottom + 10;
    cardsBtn.left = cardBtn.left;
    [cardsBtn addTarget:self action:@selector(dynamicBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cardsBtn];
}

- (void)dynamicBtnTap {
    
    DynamicViewController *vc = [DynamicViewController new];
    vc.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    [self.navigationController pushViewController:[DynamicViewController new] animated:YES];
}

- (void)dynamicLabel {
    
    UIButton *labelBtn = [UIButton getButtonWithTitle:@"labelBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.724 green:0.476 blue:0.360 alpha:1.000]];
    labelBtn.tag = 116;
    UIButton *cardBtn = [self.view viewWithTag:115];
    labelBtn.top = cardBtn.top;
    labelBtn.left = cardBtn.right + 10;
    [labelBtn addTarget:self action:@selector(labelBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:labelBtn];
}

- (void)labelBtnTap {
    
    DynamicLabelVC *vc = [DynamicLabelVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dynamicVoice {
    
    UIButton *voiceBtn = [UIButton getButtonWithTitle:@"voiceBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.724 green:0.476 blue:0.360 alpha:1.000]];
    voiceBtn.tag = 117;
    UIButton *labelBtn = [self.view viewWithTag:116];
    voiceBtn.top = labelBtn.top;
    voiceBtn.left = labelBtn.right + 10;
    [voiceBtn addTarget:self action:@selector(voiceBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:voiceBtn];
}

- (void)voiceBtnTap {
    
    VoiceVCViewController *vc = [VoiceVCViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
