//
//  VoiceVCViewController.m
//  PopViewController
//
//  Created by onwer on 16/4/12.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "VoiceVCViewController.h"
#import "UIView+Category.h"
#import "DyLineView.h"
#import <AVFoundation/AVFoundation.h>

//当前设备的屏幕宽度
#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
//当前设备的屏幕高度
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

@interface VoiceVCViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) DyLineView *lineView;
@property (nonatomic, strong) DyLineView *leftLineView;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) UIView *RippleView;

@end

@implementation VoiceVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self configView];
}

- (void)configView {
    
    self.RippleView = [[UIView alloc] initWithFrame:(CGRect){0,0,90,90}];
    self.RippleView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
    self.RippleView.layer.cornerRadius = 45;
    self.RippleView.center = self.view.center;
    self.RippleView.layer.masksToBounds=true;
    self.RippleView.alpha=0;
    [self imageWithPoint:self.view.center];
    
    self.imageView = [UIImageView new];
    self.imageView.size = CGSizeMake(60, 60);
    self.imageView.image = [UIImage imageNamed:@"input_btn_recording"];
    [self.view addSubview:self.imageView];
    self.imageView.center = self.view.center;
    
    self.lineView = [[DyLineView alloc] initWithFrame:CGRectMake(self.view.centerX + 40, 0 , 100, 60)];
    self.lineView.centerY = self.view.centerY;
    [self.view addSubview:self.lineView];
    
    self.leftLineView = [[DyLineView alloc] initWithFrame:CGRectMake(0, 0 , 100, 60)];
    self.leftLineView.right = self.imageView.left - 10;
    self.leftLineView.centerY = self.view.centerY;
    [self.view addSubview:self.leftLineView];
    
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error: &setCategoryError];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    NSError *error;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:@"dev/null"] settings:settings error:&error];
    if (self.recorder) {
        [self.recorder prepareToRecord];
        self.recorder.meteringEnabled = YES;
    }
    else{
        NSLog(@"init recorder failed");
    }
    
    
    [self startRecordIfMicrophoneEnabled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    float   level;                // The linear 0.0 .. 1.0 value we need.
    
    float   minDecibels = -60; // Or use -60dB, which I measured in a silent room.
    
    float   decibels = [self.recorder averagePowerForChannel:0];
    
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 2.0f;
        
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        
        float   amp             = powf(10.0f, 0.05f * decibels);
        
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
    
        level = powf(adjAmp, 1.0f / root);
        
    }
    [self.lineView addWaveWithDecibelValue:level * 100 directionLeft:NO];
    [self.leftLineView addWaveWithDecibelValue:level * 100 directionLeft:YES];
    [self performSelector:@selector(getDecibelValue) withObject:nil afterDelay:0.1];
    NSLog(@"平均值 %f", level * 120);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.recorder stop];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)imageWithPoint:(CGPoint)point
{
    CGPoint location = self.view.center;
    [self.view addSubview:self.RippleView];
    self.RippleView.layer.zPosition = -1;
    self.RippleView.center = location;
    self.RippleView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.RippleView.alpha=1;
                         
                     }];
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.RippleView.transform = CGAffineTransformMakeScale(1,1);
                         self.RippleView.alpha=0;
                         self.view.alpha=1;
                     } completion:^(BOOL finished) {
                         [self.RippleView removeFromSuperview];
                         [self performSelector:@selector(imageWithPoint:) withObject:nil afterDelay:1.0];
                     }];
    
}

@end
