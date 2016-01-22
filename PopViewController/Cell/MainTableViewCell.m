//
//  MainTableViewCell.m
//  PopViewController
//
//  Created by onwer on 15/12/29.
//  Copyright © 2015年 onwer. All rights reserved.
//

#import "MainTableViewCell.h"

@interface MainTableViewCell()

@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation MainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

- (UIImageView *)centerImageView {
    
    return nil;
}

@end
