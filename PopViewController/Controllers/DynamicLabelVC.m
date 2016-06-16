//
//  DynamicLabelVC.m
//  PopViewController
//
//  Created by onwer on 16/3/25.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "DynamicLabelVC.h"
#import "UIView+Category.h"
#import "WaverView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Image.h"
#import "UIImage+XB.h"


//当前设备的屏幕宽度
#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
//当前设备的屏幕高度
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

@interface DynamicLabelVC()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *staticLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) WaveView *waveView;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIImageView *iamgeView;

@end

@implementation DynamicLabelVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self configView];
    
   // UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    self.imageView = [UIImageView new];
    self.imageView.size = CGSizeMake(50, 50);
    UIImage *image = [UIImage imageNamed:@"post_decibel_wave5"];
    [image imageByFlipVertical];
    self.imageView.image = image;
    self.imageView.bottom = SCREEN_HEIGHT - 50;
    self.imageView.centerX = self.view.centerX;
    //[self.imageView addRoundCorners];
    [self.view addSubview:self.imageView];
    
    self.waveView = [[WaveView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 100 , self.view.width, 125.0)];
    [self.view addSubview:self.waveView];
    
//    NSError *setCategoryError = nil;
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error: &setCategoryError];
//    
//    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
//                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
//                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
//                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
//                              nil];
//    NSError *error;
//    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:@"dev/null"] settings:settings error:&error];
//    if (self.recorder) {
//        [self.recorder prepareToRecord];
//        self.recorder.meteringEnabled = YES;
//    }
//    else{
//        NSLog(@"init recorder failed");
//    }
//    [self startRecordIfMicrophoneEnabled];
//    
//    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 300, 250, 90)];
//    self.imageView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.imageView];
//    
//    [self test];
}

//抽取一个动画效果
-(void)animationStartWithCount:(NSInteger)count andName:(NSString *)name
{
    
    NSMutableArray *imageArray = [NSMutableArray array];
    self.imageArray = imageArray;
    
    for (int i = 0; i < count; i++) {
        
        NSString *imageName = [NSString stringWithFormat:@"image%d",i+1];
        
        NSString *imagePath = [[NSBundle mainBundle]pathForResource:imageName ofType:@"png"];
        
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        
        
        [self.imageArray addObject:image];
        
    }
    
    self.imageView.animationImages = self.imageArray;
    self.imageView.contentMode = UIViewContentModeCenter | UIViewContentModeScaleAspectFit;
    //NSLog(@"%@",self.imageArray);
    
//    if (![name isEqualToString:@"stand"]) {
//        
//        NSTimeInterval time = self.imageArray.count *1 / 30.0;
//        NSLog(@"%ld",self.imageArray.count);
//        [self performSelector:@selector(standAnimation) withObject:nil afterDelay:time];
//    }
    
    [self.imageView startAnimating];
}

- (void)test {
    
    self.imageView.animationRepeatCount = 0;
    self.imageView.animationDuration = 1.50;
    [self animationStartWithCount:6 andName:@"xiaozhao1"];
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    [self configView];
}

- (void)configView {

    UITextView *v = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, 320, 100)];
    v.backgroundColor = [UIColor redColor];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 84, 240, 100)];
    self.textView.backgroundColor = [UIColor lightGrayColor];
    self.textView.textContainerInset = UIEdgeInsetsZero;
    self.textView = v;
    NSLog(@"");
    [self.view addSubview:self.textView];
    self.sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [self.sureBtn setTitle:@"sure" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(sureBtnDidTap) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn.right = self.textView.right;
    self.sureBtn.top = self.textView.bottom + 10;
    [self.view addSubview:self.sureBtn];
    
    self.textLabel = [UILabel new];
    self.textLabel.top = self.sureBtn.bottom + 10;
    self.textLabel.font = [UIFont systemFontOfSize:16.0f];
    self.textLabel.left = 20;
    self.textLabel.textColor = [UIColor blackColor];
    [self.textLabel sizeToFit];
    
    [self.view addSubview:v];
    
}

- (void)sureBtnDidTap {
    
    NSString *text = self.textView.text;
    CGSize lableSize = CGSizeMake(SCREEN_WIDTH - 40, 0);
    CGRect rect=[text boundingRectWithSize:lableSize
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f],NSFontAttributeName, nil] context:nil];
    self.textLabel.size = rect.size;
    self.textLabel.text = text;
    self.textLabel.numberOfLines = 0;
    [self.view addSubview:self.textLabel];
    
    [self getStaticLabelOrgin];
}

- (void)getStaticLabelOrgin {
    
    NSString *text = self.textView.text;
    CGSize lableSize = CGSizeMake(SCREEN_WIDTH - 40, 0);
    CGRect rect=[text boundingRectWithSize:lableSize
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f],NSFontAttributeName, nil] context:nil];
    CGFloat needHeight = rect.size.height;
    CGSize labelSize2 = CGSizeMake(0, 20);
    CGRect rect2 = [text boundingRectWithSize:labelSize2
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f],NSFontAttributeName, nil] context:nil];
    CGFloat labelWidth = rect2.size.width;
    NSDecimalNumber *labelWidthNumber = [[NSDecimalNumber alloc] initWithFloat:labelWidth];
    NSDecimalNumber *scrWd = [[NSDecimalNumber alloc] initWithFloat:SCREEN_WIDTH];
    int needWidth = [labelWidthNumber intValue] % ([scrWd integerValue] - 40) + 20;
    
    if (self.staticLabel != nil) {
    }else {
        self.staticLabel = [UILabel new];
    }
    
    self.staticLabel.left = needWidth + 10;
    self.staticLabel.top = self.textLabel.top + needHeight - 20;
    self.staticLabel.text = @"someStr";
    self.staticLabel.font = [UIFont systemFontOfSize:16.0f];
    self.staticLabel.textColor = [UIColor redColor];
    [self.staticLabel sizeToFit];
    [self.view addSubview:self.staticLabel];
}

- (void)startRecordIfMicrophoneEnabled
{
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        __weak typeof(self) wself = self;
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                // Microphone enabled code
                NSLog(@"Microphone is enabled..");
                
                [wself startRecord];
            }
            else {
                // Microphone disabled code
                NSLog(@"Microphone is disabled..");
                
                // We're in a background thread here, so jump to main thread to do UI work.
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"麦克风不可用" message:@"该应用需要访问您的麦克风，请到设置/隐私/麦克风，开启" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alertView show];
                });
            }
        }];
    }
    else{
        [self startRecord];
    }
}

- (void)startRecord
{
    [self.recorder record];
    [self performSelector:@selector(getDecibelValue) withObject:nil afterDelay:0];
}

- (void)getDecibelValue
{
    [self.recorder updateMeters];
    
    float avg = [self.recorder averagePowerForChannel:0];
    //float avg = arc4random()%5;
    NSLog(@"%f",avg);
    
    float minValue = -45;
    float range = 45;
    float outRange = 100;
    
    if (avg < minValue){
        avg = minValue;
    }
    
    float decibels = (avg + range) / range * outRange;
    NSInteger currentDecibel = ceil(decibels);
//    _currentDecibelLabel.text = [NSString stringWithFormat:@"当前分贝:%zd",currentDecibel];
//    if (currentDecibel > _currentDecibel) {
//        _currentDecibel = currentDecibel;
//    }
    
    [self.waveView addWaveWithDecibelValue:currentDecibel];
    //    NSLog(@"%f",decibels);
    
    [self performSelector:@selector(getDecibelValue) withObject:nil afterDelay:0.1];
}

@end
