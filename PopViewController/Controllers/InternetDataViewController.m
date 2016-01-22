//
//  InternetDataViewController.m
//  PopViewController
//
//  Created by onwer on 16/1/11.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "InternetDataViewController.h"
#import "UIView+Category.h"
#import "NSString+Category.h"
#import "UIButton+Category.h"

@interface InternetDataViewController()

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *getDataBtn;

@end

@implementation InternetDataViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configView];
}

- (void)configView {
    
    UILabel *infoLabel = [UILabel new];
    infoLabel.tag = 100;
    infoLabel.text = @"请输入网页地址：";
    infoLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [infoLabel sizeToFit];
    
    infoLabel.left = 15;
    infoLabel.top = 64 + 10;
    [self.view addSubview:infoLabel];
    [self.view addSubview:self.inputField];
    [self.view addSubview:self.getDataBtn];
}

- (UITextField *)inputField {
    
    if (!_inputField) {
        _inputField = [UITextField new];
        _inputField.size = CGSizeMake(self.view.width - 15 * 2, 25);
        _inputField.font = [UIFont boldSystemFontOfSize:15.0f];
        _inputField.backgroundColor = [UIColor lightGrayColor];
        _inputField.textColor = [UIColor whiteColor];
        
        _inputField.left = 15;
        _inputField.top = [self.view viewWithTag:100].bottom + 10;
    }
    return _inputField;
}

- (UIButton *)getDataBtn {
    
    if (!_getDataBtn) {
        _getDataBtn = [UIButton getButtonWithTitle:@"GetDataBtn" titleColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15.0f] backgroundColor:[UIColor colorWithRed:0.173 green:0.724 blue:0.629 alpha:1.000]];
        [_getDataBtn addTarget:self action:@selector(fetchInternetData) forControlEvents:UIControlEventTouchUpInside];
        _getDataBtn.left = 15;
        _getDataBtn.top = self.inputField.bottom + 10;
    }
    return _getDataBtn;
}

- (void)fetchInternetData {
    
    self.inputField.text = @"http://difang.kaiwind.com/shanghai/dfmssy/201509/25/t20150925_2885285.shtml";
    if (self.inputField.text.length == 0) {
        return;
    }else {
        NSString *urlStr = [NSString urlString:self.inputField.text];
        NSString *regstr = @"<td class=\'z_bg_05\'>\\w{11}</td><td class=\'z_bg_13\'>(\\w{2}\\s{0,1})*</td>";
        NSMutableArray *dataArray = [urlStr substringByRegular:regstr];
        NSLog(@"%@",dataArray);
    }
}

@end
