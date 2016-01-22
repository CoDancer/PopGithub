//
//  PickerView.h
//  PopViewController
//
//  Created by onwer on 15/12/23.
//  Copyright © 2015年 onwer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreen_Width  [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Frame [UIScreen mainScreen].bounds

typedef void(^GetAddressBlock)(NSString *addressInfo);

@interface PickerView : UIView

+ (void)showPickerViewWithAddressBlock:(GetAddressBlock )addressBlock;



@end
